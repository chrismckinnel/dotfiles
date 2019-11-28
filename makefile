.PHONY: check_ssh_key dotfiles bash git tmux vim post_install zip

SHELL := /bin/bash
HOME=/home/$$USER

check_ssh_key:
	@if [ ! -d "$(HOME)/.ssh" ]; then echo "No SSH keys found - create / add your SSH keys. Aborting."; exit 1; fi

dotfiles:
	@if [ -d "$(HOME)/dotfiles" ]; then mv --backup=numbered $(HOME)/dotfiles $(HOME)/dotfiles.old; fi
	git clone git@github.com:chrismckinnel/dotfiles.git $(HOME)/dotfiles

bash:
	@if [ -f $(HOME)/.bashrc ]; then mv --backup=numbered $(HOME)/.{bashrc,old}; fi
	ln -svf $(HOME)/dotfiles/.bashrc $(HOME)/.bashrc
	@if [ -f $(HOME)/.bash_prompt ]; then mv --backup=numbered $(HOME)/.{bash_prompt,bash_prompt.old}; fi
	ln -svf $(HOME)/dotfiles/.bash_prompt $(HOME)/.bash_prompt

git:
	sudo apt-get install -y git
	@if [ -f $(HOME)/.gitconfig ]; then mv --backup=numbered $(HOME)/.{gitconfig,gitconfig.old}; fi
	ln -svf $(HOME)/dotfiles/.gitconfig $(HOME)/.gitconfig

tmux:
	sudo apt-get install -y tmux
	@if [ -f $(HOME)/.tmux.conf ]; then mv --backup=numbered $(HOME)/.tmux.{conf,old}; fi
	ln -svf $(HOME)/dotfiles/tmux.conf $(HOME)/.tmux.conf

vim:
	sudo apt-get install -y vim
	@if [ -d "$(HOME)/.vim" ]; then mv --backup=numbered $(HOME)/.vim $(HOME)/.vim.old; fi
	mkdir -p $(HOME)/.vim/sessions
	@if [ -f $(HOME)/.vimrc ]; then mv --backup=numbered $(HOME)/.{vimrc,vimrc.old}; fi
	ln -svf $(HOME)/dotfiles/.vimrc $(HOME)/.vimrc
	git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim
	mkdir $(HOME)/.vim/colors
	cp vim/colors/xoria256.vim $(HOME)/.vim/colors/xoria256.vim

post_install:
	echo "Installation complete."
	echo "Please run 'vim +PluginInstall +qall' to install your vim plugins"

zip:
	sudo apt-get install -y zip
	sudo apt-get install -y unzip

install: check_ssh_key dotfiles bash git tmux vim zip post_install
