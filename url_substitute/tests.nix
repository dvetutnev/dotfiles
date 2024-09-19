{ lib ? import <nixpkgs/lib> }:
let
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
  substituteUrl = import ./. { inherit lib; } replacements;
in
{
  testSubstituteUrl1 = {
    expr = substituteUrl "https://github.com/git/git/archive/refs/tags/v2.43.0.tar.gz";
    expected.url = "https://proxy/from_github/git/git/archive/refs/tags/v2.43.0.tar.gz";
  };
  testSubstituteUrl2 = {
    expr = substituteUrl "https://example.org/archive.tar.gz";
    expected.url = "https://proxy/example/archive.tar.gz";
  };
  testSubstituteUrlNotFound = {
    expr = substituteUrl "https://unknown_host/path/";
    expectedError.type = "ThrownError";
    expectedError.msg = "https://unknown_host/path";
  };
}
