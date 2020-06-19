#!/usr/bin/zsh
sudo pacman -Syyu
sudo pacman -Syu --noconfirm $(cat packages.txt | awk '{print $1}')
sudo pacman -Rs $(pacman -Qdtq)

if [ ! -d ~/.password-store ]; then
    echo "setting up password-store"
    git clone git@gitlab.com:samspills/passwords ~/.password-store
    pass init --path=~/.password-store Sam Pillsworth
    pass git init
fi

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

if [ ! -d ~/.etc/rofi-pass ]; then
    echo "fetching rofi-pass"
    git clone git@github.com:carnager/rofi-pass.git ~/.etc/rofi-pass
    ln -s ~/.etc/rofi-pass/rofi-pass ~/bin/rofi-pass
    ln -s ~/.etc/rofi-pass/addpass ~/bin/addpass
fi
