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
    substitute_ = findSubstitute replacements;
  in
  { inherit url; };
in
{
  testFindSubstitute1 = {
    expr = builtins.getAttr "origin"
      (findSubstitute replacements
        "https://github.com/git/git/archive/refs/tags/v2.43.0.tar.gz");
    expected = "https://github.com/(.*)";
  };
  testFindSubstitute2 = {
    expr = builtins.getAttr "origin"
      (findSubstitute replacements
        "https://example.org/archive.tar.gz");
    expected = "https://example.org/(.*)";
  };

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
        "https://example.com/archive.tar.gz");
    expected = "https://proxy/example/archive.tar.gz";
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
