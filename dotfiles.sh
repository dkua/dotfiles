#!/bin/sh
$PWD = pwd

git submodule init
git submodule update

mkdir ~/.tmp

ln -s -f $PWD/zshrc $HOME/.zshrc
ln -s -f $PWD/gitconfig $HOME/.gitconfig
ln -s -f $PWD/tmux.conf $HOME/.tmux.conf
ln -s -f $PWD/vimrc $HOME/.vimrc
ln -s -f $PWD/vim/ $HOME/.vim
mkdir -p $HOME/.vim/ftdetect
mkdir -p $HOME/.vim/syntax
mkdir -p $HOME/.vim/autoload/go
ln -s /usr/local/go/misc/vim/ftdetect/gofiletype.vim $HOME/.vim/ftdetect/
ln -s /usr/local/go/misc/vim/syntax/go.vim $HOME/.vim/syntax
ln -s /usr/local/go/misc/vim/autoload/go/complete.vim $HOME/.vim/autoload/go
echo "syntax on" >> $HOME/.vimrc
