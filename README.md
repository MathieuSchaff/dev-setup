# Dotfiles 2026

Ma configuration Linux actuelle.

## Update

Si tu ajoutes/modifies des configs :
```bash
cd ~/dotfiles-new
cp ~/.zshrc .
cp ~/.bashrc .
cp ~/.tmux.conf .
cp ~/.vimrc .
cp ~/.gitconfig .
cp -r ~/.config/nvim .config/
cp -r ~/.config/lazygit .config/
git add .
git commit -m "Update configs"
git push
```

Ou tout en une ligne :
```bash
cd ~/dotfiles-new && cp ~/.zshrc ~/.bashrc ~/.tmux.conf ~/.vimrc ~/.gitconfig . && cp -r ~/.config/{nvim,lazygit} .config/ && git add . && git commit -m "Update" && git push
```

## Restore

Pour restaurer sur une nouvelle machine :
```bash
git clone git@github.com:MathieuSchaff/dotfiles-2026.git
cd dotfiles-2026
cp .zshrc ~/.zshrc
cp .bashrc ~/.bashrc
# ... etc
```
