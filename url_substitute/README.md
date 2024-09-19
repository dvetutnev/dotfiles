# Run tests

## Flake

ShellSession
```
$ nix flake update
$ nix run github:nix-community/nix-unit  -- --flake .#tests
```

or

ShellSession
```
$ nix flake update
$ nix flake check
```

## Legacy

ShellSession
```
$ nix run github:nix-community/nix-unit -- tests.nix
```

