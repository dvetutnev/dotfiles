# Run tests

## Flake

Do it once create `flake.lock`, before run tests

```ShellSession
$ nix flake update
```

Run tests

```ShellSession
$ nix run github:nix-community/nix-unit  -- --flake .#tests
```

or use this flake

```ShellSession
$ nix run ./#nix-unit -- --flake './#tests'
```

or simple

```ShellSession
$ nix flake check
```

## Legacy

```ShellSession
$ nix run github:nix-community/nix-unit -- tests.nix
```
