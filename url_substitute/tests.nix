{ pkgs ? import <nixpkgs> {} }:
let
  a = 42;
  replacements = [
    {
      origin = "https://github.com/(.*)";
      substitution = "https://proxy/from_github/$1";
    }
    {
      origin = "https://example.org/(.*)";
      substitution = "https://proxy/example/$1";
    }
  ];
  findSubstitute = with pkgs; replacemens: url:
   lib.findFirst (x: (builtins.match x.origin url) != null) null replacements;

  substituteUrl = replacements: url:
  let
    replacement = findSubstitute replacements url;
  in
  pkgs.lib.throwIf (replacement == null) "Can`t replace url '${url}'"
  {
    url = builtins.replaceStrings [ "$1" ] (builtins.match replacement.origin url)
      replacement.substitution;
  };
in
{
  testSubstituteUrl1 = {
    expr = builtins.getAttr "url"
      (substituteUrl replacements
        "https://github.com/git/git/archive/refs/tags/v2.43.0.tar.gz");
    expected =
      "https://proxy/from_github/git/git/archive/refs/tags/v2.43.0.tar.gz";
  };
  testSubstituteUrl2 = {
    expr = builtins.getAttr "url"
      (substituteUrl replacements
        "https://example.org/archive.tar.gz");
    expected = "https://proxy/example/archive.tar.gz";
  };
  testSubstituteUrlNotFound = {
    expr = builtins.tryEval
      (substituteUrl replacements "https://unknown_host/path/");
    expected = { success = false; value = false; };
  };
}
