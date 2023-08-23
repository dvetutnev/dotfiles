{ pkgs, lib }:

nixGLPrefix: package:
(package.overrideAttrs (old: {
  name = "nixGL-${package.name}";
  buildCommand = ''
    set -eo pipefail

    ${
    # Heavily inspired by https://stackoverflow.com/a/68523368/6259505
    pkgs.lib.concatStringsSep "\n" (map (outputName: ''
      echo "Copying output ${outputName}"
      set -x
      cp -rs --no-preserve=mode "${package.${outputName}}" "''$${outputName}"
      set +x
    '') (old.outputs or [ "out" ]))}

    rm -rf $out/bin/*
    shopt -s nullglob # Prevent loop from running if no files
    for file in ${package.out}/bin/*; do
      echo "#!${pkgs.bash}/bin/bash" > "$out/bin/$(basename $file)"
      echo "exec -a \"\$0\" ${lib.getExe nixGLPrefix} $file \"\$@\"" >> "$out/bin/$(basename $file)"
      chmod +x "$out/bin/$(basename $file)"
    done
    shopt -u nullglob # Revert nullglob back to its normal default state
  '';
}))
