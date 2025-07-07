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
    clj-kondo
    jdk_headless
  ];
}
