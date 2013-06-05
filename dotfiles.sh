alias "tmux.new"='tmux new-session -s ${1}'
alias "tmux.attach"='tmux attach-session -t ${1}'
alias "tmux.list"='tmux list-sessions'
alias "tmux.nuke"='tmux kill-server'

git submodule init
git submodule update

mkdir ~/.tmp

ln -s tmux.conf ~/.tmux.conf
ln -s vimrc ~/.vimrc
ln -s vim ~/.vim
