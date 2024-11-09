## Nix
## Install packages
`nix run nix-darwin -- switch --flake ./nix-darwin#book`
or apply changes
`darwin-rebuild switch --flake ./nix-darwin#book`
### Update
`nix flake update`

## ZSH
`echo "source ~/.config/.zsh/.zshrc" >> ~/.zshrc`
or overwrite `~/.zshrc` with `source ~/.config/.zsh/.zshrc`
