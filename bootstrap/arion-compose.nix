{ pkgs, lib, ... }:
let
  nginxWebRoot = pkgs.writeTextDir "index.html" "Hello World! (nginx in docker by Nix)";
  nginxPort = "80";
  nginxConf = pkgs.writeText "nginx.conf" ''
    user nobody nobody;
    daemon off;
    error_log /dev/stdout info;
    pid /dev/null;
    events {}
    http {
      access_log /dev/stdout;
      server {
        listen ${nginxPort};
        index index.html;
        location / {
          root ${nginxWebRoot};
        }
      }
    }
  '';

  nginxContainer = pkgs.dockerTools.buildImage {
    name = "nix-nginx";
    copyToRoot = with pkgs; buildEnv {
      name = "image-root";
      paths = [
        fakeNss
        dockerTools.binSh
        nginx
        iputils
      ];
      pathsToLink = [ "/bin" "/etc" ];
    };

    extraCommands = ''
      mkdir -p tmp/nginx_client_body
      mkdir -p var/log/nginx
      mkdir -p var/cache/nginx
    '';

    config = {
      Cmd = [ "nginx" "-c" nginxConf ];
      #Cmd = [ "sh" ];
      ExposedPorts = {
        "${nginxPort}/tcp" = { };
      };
    };
  };
in
{
  project.name = "nix-bootstrap";
  services = {
    proxy = {
      build.image = lib.mkForce (nginxContainer);
      #service.ports = [ "80:80" ];
      service.networks = [
        "internet"
        "intranet"
      ];
      service.tty = true;
    };
  };

  networks = {
    internet = {};
    intranet = {
      internal = true;
    };
  };
}
