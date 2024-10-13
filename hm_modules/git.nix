{
  programs.git = {
    enable = true;
    userName = "Dmitriy Vetutnev";
    userEmail = "d.vetutnev@gmail.com";
    extraConfig = {
      merge.conflictstyle = "diff3";
    };
  };
}
