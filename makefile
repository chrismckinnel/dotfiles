.PHONY: check_ssh_key dotfiles

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

firefox:
	sudo apt-get install -y iceweasel	

pentadactyl: firefox zip
	mkdir -p $(HOME)/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
	rm -rf $(HOME)/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/*
	cd $(HOME)/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384} && wget http://5digits.org/nightly/pentadactyl-latest.xpi
	cd $(HOME)/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384} && unzip pentadactyl-latest.xpi
	cd $(HOME)/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384} && rm -rf pentadactyl-latest.xpi
	sudo rm -rf /usr/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
	sudo mv --backup=numbered $(HOME)/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384} /usr/share/mozilla/extensions/
	mkdir -p $(HOME)/.pentadactyl/colors
	ln -svf $(HOME)/dotfiles/pentadactyl/colors/zenburn.penta $(HOME)/.pentadactyl/colors/zenburn.penta
	@if [ -f $(HOME)/.pentadactylrc ]; then mv --backup=numbered $(HOME)/.{pentadactylrc,pentadactylrc.old}; fi
	ln -svf $(HOME)/dotfiles/.pentadactylrc $(HOME)/.pentadactylrc

xmodmap:
	@if [ -f $(HOME)/.Xmodmap ]; then mv -f $(HOME)/.{Xmodmap,Xmodmap.old}; fi
	ln -svf $(HOME)/dotfiles/.Xmodmap $(HOME)/.Xmodmap

post_install:
	echo "Installation complete."
	echo "Please run 'vim +PluginInstall +qall' to install your vim plugins"

zip:
	sudo apt-get install -y zip

install: check_ssh_key dotfiles bash git tmux vim pentadactyl xmodmap post_install
