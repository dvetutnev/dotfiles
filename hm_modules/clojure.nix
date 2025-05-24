{ pkgs
, ...
}:

{
  home.packages = with pkgs; [
    clojure
    leiningen
    jdk_headless
  ];
}
