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
  findReplacements = replacements: url: { origin = 43; };
  substituteUrl = replacements: url: url;
in
{
  testFindReplacements43 = {
    expr = builtins.getAttr "origin"
      (findReplacements replacements
        "https://github.com/git/git/archive/refs/tags/v2.43.0.tar.gz");
    expected = 43;
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
