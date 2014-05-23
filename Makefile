DIR=$(HOME)/dotfiles

osx: symlinks ensure_brew brew python_env go_env clone_vundle
	@echo "Reminder: Vim plugins are managed within Vim with Vundle."

deb: symlinks apt-get python_env go_env clone_vundle
	@echo "Reminder: Vim plugins are managed within Vim with Vundle."

symlinks:
	@ln -sf $(DIR)/shell/bashrc $(HOME)/.bashrc
	@ln -sf $(DIR)/shell/zshrc $(HOME)/.zshrc
	@ln -nsf $(DIR)/vim/vim $(HOME)/.vim
	@ln -sf $(DIR)/vim/vimrc $(HOME)/.vimrc
	@ln -nsf $(DIR)/vim/plugin $(HOME)/.vim/plugin
	@ln -sf $(DIR)/tmux/tmux.conf $(HOME)/.tmux.conf
	@ln -sf $(DIR)/tmux/tmux-osx.conf $(HOME)/.tmux-osx.conf
	@ln -sf $(DIR)/git/gitconfig $(HOME)/.gitconfig
	@ln -sf $(DIR)/git/gitignore_global $(HOME)/.gitignore_global
	@mkdir $(HOME)/tmp

ensure_brew:
	ruby $(DIR)/scripts/ensure_homebrew.rb

brew:
	brew bundle $(DIR)/osx/Brewfile

apt-get:
	apt-get update
	cat "$(DIR)/debian/packages.list" | xargs apt-get -y install
	dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

python_env:
	command -v pip >/dev/null 2>&1 || easy_install pip
	pip install virtualenv
	pip install virtualenvwrapper

go_env:
	mkdir $(HOME)/go
	export GOPATH='$(HOME)/go'

clone_vundle: symlinks
	git clone https://github.com/gmarik/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim
