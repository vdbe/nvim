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

<details>
<summary>Each variant also has a `withLsp` passthru that adds LSPs/formatter/...</summary>
 
* `default.withLsp`
* `default.withLsp.lua`
* `default.withLsp.<language>`
</details>

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
```bash
nix run github:vdbe/nvim#default.withLsp.lua
```
...
</details>


## Thanks to

- [getchoo](https://github.com/getchoo/getchvim/)

