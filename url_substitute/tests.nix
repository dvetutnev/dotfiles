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
  findReplacements = with pkgs; replacemens: url:
   lib.findFirst (x: (builtins.match x.origin url) != null) null replacements;

  substituteUrl = replacements: url: url;
in
{
  testFindReplacements1 = {
    expr = builtins.getAttr "origin"
      (findReplacements replacements
        "https://github.com/git/git/archive/refs/tags/v2.43.0.tar.gz");
    expected = "https://github.com/(.*)";
  };
  testFindReplacements2 = {
    expr = builtins.getAttr "origin"
      (findReplacements replacements
        "https://example.org/archive.tar.gz");
    expected = "https://example.org/(.*)";
  };
  testA = let b = 42; in {
    expr = b;
    expected = 42;
  };
  test1 = {
    expr = { a = ''b''; };
    expected = { a = "b"; };
  };

  testThrow = {
    expr = throw "aa 42 bb";
    expectedError.type = "ThrownError";
    expectedError.msg = "42";
  };
}
