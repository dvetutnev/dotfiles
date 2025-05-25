{ pkgs
, ...
}:

{
  home.packages = with pkgs; [
    clojure
    leiningen
    clojure-lsp
    jdk_headless
  ];
}
