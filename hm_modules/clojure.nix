{
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    clojure
    leiningen
    clojure-lsp
    cljfmt
    jdk_headless
  ];
}
