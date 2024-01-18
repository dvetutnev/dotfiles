{ pkgs, lib, ... }:
let
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
        location /from_debian/ {
          proxy_pass http://deb.debian.org/;
        }
        # https://serverfault.com/questions/423265/how-to-follow-http-redirects-inside-nginx
        location /from_github/ {
          proxy_pass https://github.com/;
          proxy_ssl_server_name on;
          proxy_intercept_errors on;
          error_page 301 302 307 = @handle_redirect;
        }
        location @handle_redirect {
          set $saved_redirect_location '$upstream_http_location';
          resolver 8.8.8.8;
          proxy_pass $saved_redirect_location;
        }
      }
    }
  '';

  proxyImage = pkgs.dockerTools.buildImage {
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
    };
  };

  debianImage = pkgs.dockerTools.pullImage {
    imageName = "debian";
    imageDigest =
      "sha256:bac353db4cc04bc672b14029964e686cd7bad56fe34b51f432c1a1304b9928da";
    sha256 = "14g5xjxk3r64flannliw3b6bwx9d2zmb7c2ryqklndqs54rq0v6m";
  };

  workstationImage = pkgs.dockerTools.buildImage {
    name = "workstation";
    fromImage = debianImage;
    runAsRoot = ''
      sed -i -r 's|http://deb.debian.org/(.*)|http://proxy/from_debian/\1|' \
        /etc/apt/sources.list.d/debian.sources
    '';
  };
in
{
  project.name = "nix-bootstrap";
  services = {
    proxy = {
      build.image = lib.mkForce (proxyImage);
      service.networks = [
        "internet"
        "intranet"
      ];
    };

    workstation = {
      build.image = lib.mkForce (workstationImage);
      service.networks = [
        "intranet"
      ];
      service.tty = true;
      service.command = "sleep infinity";
    };
  };

  networks = {
    internet = {};
    intranet = {
      internal = true;
    };
  };
}
