DIR=$(HOME)/dotfiles

osx: symlinks ensure_brew brew python_env go_env clone_vundle oh_my_zsh
	@echo "Reminder: Vim plugins are managed within Vim with Vundle."

deb: symlinks apt-get python_env go_env godeb clone_vundle oh_my_zsh
	@echo "Reminder: Vim plugins are managed within Vim with Vundle."

symlinks:
	@ln -sf $(DIR)/shell/bashrc $(HOME)/.bashrc
	@ln -sf $(DIR)/shell/zshrc $(HOME)/.zshrc
	@ln -nsf $(DIR)/vim/vim $(HOME)/.vim
	@ln -sf $(DIR)/vim/vimrc $(HOME)/.vimrc
	@ln -sf $(DIR)/tmux/tmux.conf $(HOME)/.tmux.conf
	@ln -sf $(DIR)/tmux/tmux-osx.conf $(HOME)/.tmux-osx.conf
	@ln -sf $(DIR)/git/gitconfig $(HOME)/.gitconfig
	@ln -sf $(DIR)/git/gitignore_global $(HOME)/.gitignore_global
	@mkdir -p $(HOME)/.tmp

ensure_brew:
	ruby $(DIR)/scripts/ensure_homebrew.rb

brew:
	brew bundle $(DIR)/osx/Brewfile

apt-get:
	sudo apt-get update
	sudo cat "$(DIR)/debian/packages.list" | sudo xargs apt-get -y install
	sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

python_env:
	command -v easy_install >/dev/null 2>&1 || { curl https://bootstrap.pypa.io/ez_setup.py -o - | sudo python; }
	command -v pip >/dev/null 2>&1 || sudo easy_install pip
	sudo pip install virtualenv
	sudo pip install virtualenvwrapper

go_env:
	mkdir -p $(HOME)/go
	export GOPATH='$(HOME)/go'

godeb:
	go get launchpad.net/godeb
	sudo apt-get remove -y golang
	sudo apt-get -y autoremove
	sudo $(GOPATH)/bin/godeb install

clone_vundle: symlinks
	mkdir -p $(HOME)/.vim/bundle/
	git clone https://github.com/gmarik/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

oh_my_zsh:
	git clone git://github.com/robbyrussell/oh-my-zsh.git $(HOME)/.oh-my-zsh
