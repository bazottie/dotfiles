## Nix
## Install packages
`sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ./nix-darwin#book`
or apply changes
`sudo darwin-rebuild switch --flake ./nix-darwin#book`
### Update
`nix flake update`

## ZSH
`echo "source ~/.config/.zsh/.zshrc" >> ~/.zshrc`
or overwrite `~/.zshrc` with `source ~/.config/.zsh/.zshrc`
