.PHONY: check_ssh_key dotfiles

check_ssh_key:
	@if [ ! -d ~/.ssh ]; then echo "No SSH keys found - create / add your SSH keys. Aborting."; exit 1; fi

dotfiles:
	git clone git@github.com:chrismckinnel/dotfiles.git ~/dotfiles

bash:
	if [ -f ~/.bashrc ]; then mv ~/.{bashrc,bak}; fi
	ln -svf ~/dotfiles/.bashrc ~/.bashrc
	if [ -f ~/.bash_prompt ]; then mv ~/.{bash_prompt,bash_prompt.bak}; fi
	ln -svf ~/dotfiles/.bash_prompt ~/.bash_prompt

git:
	apt-get install -y git
	if [ -f ~/.gitconfig ]; then mv ~/.{gitconfig,gitconfig.bak}; fi
	ln -svf ~/dotfiles/.gitconfig ~/.gitconfig

tmux:
	apt-get install -y tmux
	if [ -f ~/.tmux.conf ]; then mv ~/.tmux.{conf,bak}; fi
	ln -svf ~/dotfiles/tmux.conf ~/.tmux.conf

vim:
	apt-get install -y vim
	mkdir -p ~/.vim/sessions
	if [ -f ~/.vimrc ]; then mv ~/.{vimrc,vimrc.bak}; fi
	ln -svf ~/dotfiles/vimrc.conf ~/.vimrc.conf
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

firefox:
	apt-get install -y iceweasel	

pentadactyl: firefox zip
	mkdir ~/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
	cd ~/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
	wget http://5digits.org/nightly/pentadactyl-latest.xpi
	unzip ~/extensions/pentadactyl-latest.xpi
	rm -rf pentadactyl-latest.xpi
	mv ~/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384} /usr/share/mozilla/extensions/
	mkdir -p ~/.pentadactyl/colors
	ln -svf ~/dotfiles/pentadactyl/colors/zenburn.penta ~/.pentadactyl/colors/zenburn.penta

xmodmap:
	if [ -f ~/.Xmodmap ]; then mv ~/.{Xmodmap,Xmodmap.bak}; fi
	ln -svf ~/dotfiles/.Xmodmap ~/.Xmodmap

zip:
	apt-get install -y zip

install: check_ssh_key dotfiles bash git tmux vim pentadactyl xmodmap
