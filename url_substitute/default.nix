{ lib }:
replacements: url:
let
  findSubstitute = replacements: url:
  let predicate = x: (builtins.match x.origin url) != null; in
   lib.findFirst predicate null replacements;

  replacement = findSubstitute replacements url;
in
  lib.throwIf (replacement == null) "Can`t replace url '${url}'"
  {
    url = builtins.replaceStrings [ "$1" ] (builtins.match replacement.origin url)
      replacement.substitution;
  }
