naklar's dotfiles
===================

Requirements
------------

Set zsh as your login shell and install oh-my-zsh:

    chsh -s $(which zsh)

Install
-------

Clone onto your laptop:

    git clone git@github.com:naklar/.dotfiles.git ~/.dotfiles

Install [rcm](https://github.com/thoughtbot/rcm):

    yay -S rcm

Install the dotfiles:

    lsrc
    rcup -v

Or

    ./install.sh

Create install script
---------------------

    env RCRC=/dev/null rcup -B 0 -g > install.sh
