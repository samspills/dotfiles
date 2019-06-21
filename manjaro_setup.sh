#!/usr/bin/zsh
if [ ! -f ~/.antigen.zsh ]; then
    echo "fetching antigen"
    curl -L git.io/antigen > ~/.antigen.zsh
fi

if [ ! -d ~/dotfiles ]; then
    echo "fetching dotfiles repo"
    git clone git@github.com:samspills/dotfiles /home/sam/dotfiles
    ln -s /home/sam/dotfiles/dot-emacs/.spacemacs /home/sam/.spacemacs
fi

if [ ! -d ~/.emacs.d ]; then
    echo "fetching spacemacs fork"
    git clone git@github.com:samspills/spacemacs ~/.emacs.d
    ln -s /home/sam/dotfiles/dot-emacs/custom.el /home/sam/.emacs.d/custom.el
fi

if [ ! "$SHELL" = "$(which zsh)" ]; then
    chsh -s $(which zsh)
fi

brew bundle ~/Brewfile
