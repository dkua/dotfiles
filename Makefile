DIR=$(HOME)/dotfiles
DEB_GO='https://storage.googleapis.com/golang/go1.2.2.linux-amd64.tar.gz'

osx: symlinks ensure_brew brew python_env go_env vundle zsh
	@echo "Reminder: Vim plugins are managed within Vim with Vundle."

deb: symlinks apt-get python_env go_env godeb vundle zsh
	@echo "Reminder: Vim plugins are managed within Vim with Vundle."

symlinks:
	@mkdir -p $(HOME)/.tmp
	@mkdir -p $(DIR)/vim/vim/bundle
	@ln -sf $(DIR)/shell/bashrc $(HOME)/.bashrc
	@ln -sf $(DIR)/shell/zshrc $(HOME)/.zshrc
	@ln -nsf $(DIR)/vim/vim $(HOME)/.vim
	@ln -sf $(DIR)/vim/vimrc $(HOME)/.vimrc
	@ln -sf $(DIR)/tmux/tmux.conf $(HOME)/.tmux.conf
	@ln -sf $(DIR)/tmux/tmux-osx.conf $(HOME)/.tmux-osx.conf
	@ln -sf $(DIR)/git/gitconfig $(HOME)/.gitconfig
	@ln -sf $(DIR)/git/gitignore_global $(HOME)/.gitignore_global

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

godeb:
	command -v go >/dev/null 2>&1 || { curl $(DEB_GO) -o - | sudo tar -C /usr/local -xz; }

vundle: symlinks
	git clone https://github.com/gmarik/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

zsh:
	zsh
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	setopt EXTENDED_GLOB
	for rcfile in "$(ZDOTDIR):-$(HOME)"/.zprezto/runcoms/^README.md(.N); do
		ln -s "$(rcfile)" "$(ZDOTDIR):-$(HOME)/.$(rcfile:t)"
	done
	chsh -s /bin/zsh

