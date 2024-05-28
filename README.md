# My Neovim Config

## How to use
```bash 
git clone https://github.com/vdbe/nvim.git ~/.config/nvim
```

### Nix
Available packages are

* `default`/`neovim`: comet
  * `comet`: IDE
  * `noPlugins`: Without plugins
  * `minimal`: Everything stripped out

Each variant also has a `withLsp` passthru that adds LSPs/formatter/...

<details>
<summary>nix run</summary>
  
```bash
nix run github:vdbe/nvim
```
```bash
nix run github:vdbe/nvim#default.noPlugins
```
```bash
nix run github:vdbe/nvim#default.withLsp
```
...
</details>


## Thanks to

- [getchoo](https://github.com/getchoo/getchvim/)

