{ lib }:
replacements: url:
let
  matchUrl = x: builtins.match x.origin url;
  predicate = x: (matchUrl x) != null;
  substitute = lib.findFirst predicate null replacements;
in
  lib.throwIf (substitute == null) "Can`t replace url '${url}'"
  {
    url = builtins.replaceStrings [ "$1" ] (matchUrl substitute)
      substitute.substitution;
  }
