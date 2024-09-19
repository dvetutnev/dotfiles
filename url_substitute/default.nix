{ lib }:
replacements: url:
let
  findSubstitute = replacements: url:
   lib.findFirst (x: (builtins.match x.origin url) != null) null replacements;

  replacement = findSubstitute replacements url;
in
  lib.throwIf (replacement == null) "Can`t replace url '${url}'"
  {
    url = builtins.replaceStrings [ "$1" ] (builtins.match replacement.origin url)
      replacement.substitution;
  }
