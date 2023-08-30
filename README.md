# Develop shell in Docker
container:
```
docker run --rm -it --net host nixos/nix nix \
    --extra-experimental-features "nix-command flakes" \
    develop github:dvetutnev/dotfiles#42 \
    -c nvim --headless --listen 0.0.0.0:6666
```

nvim GUI:
```
neovide --server=localhost:6666
```

