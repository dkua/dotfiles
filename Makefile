DIR=$(HOME)/dotfiles
DEB_GO='https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz'
HOMEBREW_URL='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'

osx: symlinks copy brew cask python_env go_env vundle govim osxkeychain zsh 

deb: symlinks copy apt-get python_env go_env godeb vundle govim zsh

base: symlinks copy vundle

symlinks:
	@mkdir -p $(HOME)/.tmp
	@mkdir -p $(DIR)/vim/vim/bundle
	@ln -sf $(DIR)/shell/profile $(HOME)/.profile
	@ln -sf $(DIR)/shell/bashrc $(HOME)/.bashrc
	@ln -sf $(DIR)/shell/zshrc $(HOME)/.zshrc
	@ln -nsf $(DIR)/vim/vim $(HOME)/.vim
	@ln -sf $(DIR)/vim/vimrc $(HOME)/.vimrc
	@ln -sf $(DIR)/tmux/tmux.conf $(HOME)/.tmux.conf
	@ln -sf $(DIR)/tmux/tmux-osx.conf $(HOME)/.tmux-osx.conf
	@ln -sf $(DIR)/git/gitignore_global $(HOME)/.gitignore_global

copy:
	@cp -fH $(DIR)/shell/bash_profile $(HOME)/.bash_profile
	@cp -fH $(DIR)/git/gitconfig $(HOME)/.gitconfig

ensure_brew:
	sudo true
	xcode-select --install | true
	curl -fsSL $(HOMEBREW_URL) | /bin/bash
	$$(/opt/homebrew/bin/brew shellenv)
	softwareupdate --install-rosetta --agree-to-license
	curl -fsSL $(HOMEBREW_URL) | arch -x86_64 /bin/bash

brew:
	brew update
	brew upgrade
	brew bundle install
	brew cleanup
	@echo "Remember: Run brew doctor afterwords"

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
	export GOPATH=$(HOME)/go

godeb:
	command -v go >/dev/null 2>&1 || { curl $(DEB_GO) -o - | sudo tar -C /usr/local -xz; }

govim: vundle
	vim +GoInstallBinaries +qall

vundle: symlinks patch_vim
	if [ ! -d $(HOME)/.vim/bundle/Vundle.vim ]; then \
		git clone https://github.com/gmarik/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim; \
	fi
	vim +PluginInstall +qall

patch_vim:
	vim -Nu NONE -S $(DIR)/vim/netrw_fix.vim +qall

zsh: symlinks
	chsh -s /bin/zsh

osxkeychain:
	git config --global credential.helper osxkeychain
