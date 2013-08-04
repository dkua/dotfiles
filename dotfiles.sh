$PWD = pwd

git submodule init
git submodule update

mkdir ~/.tmp

ln -s -f $PWD/zshrc ~/.zshrc
ln -s -f $PWD/gitconfig ~/.gitconfig
ln -s -f $PWD/tmux.conf ~/.tmux.conf
ln -s -f $PWD/vimrc ~/.vimrc
ln -s -f $PWD/vim ~/.vim
ln -s -f $PWD/slate ~/.slate
