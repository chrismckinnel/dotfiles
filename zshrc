# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx pip hub git-flow brew django lein)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/share/npm/bin:/Users/cmckinnel/pear/bin

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="chris"
source $ZSH/oh-my-zsh.sh
export TANGENT_USER='mckinnelc'
export WORKON_HOME=~/virtualenvs
export VIRTUALENVWRAPPER_LOG_DIR="$WORKON_HOME"
export VIRTUALENVWRAPPER_HOOK_DIR="$WORKON_HOME"

alias gs='git status' 
alias gl='git log --graph --decorate'
alias go='git checkout'                                                              
alias gc='git commit'                                                                
alias gcv='git commit --no-verify'                                                   
alias gb='git branch'                                                                
alias gh='git hist'
alias gm='git merge'                                                                 
alias ga='git add'                                                                   
alias gaa='git add -A'                                                               
alias gaac='git add -A && git commit'                                                
alias gd='git diff'                                                                  
alias gl1='git log --oneline'                                                        
alias gls='git log --oneline --stat'                                                 
alias gpo='git push origin'                                                          
alias gfo='git fetch origin -p'                                                          
alias gpom='git push origin master'                                                  
alias grm='git rebase master'                                                        
alias grc='git rebase --continue'                                                    
alias grs='git rebase --skip'                                                        
alias gmt='git mergetool'
alias t='/Users/cmckinnel/Dropbox/todo/todo.sh'
alias ke='killall emacs'

# Maven aliases
alias mb='mvn clean install'
alias mt='mvn -e test'

function _forward_mysql_via_ssh() {
    CMD_START="ssh"
    CMD_END=" -f $1 -L $2:$3:3306 -N"
    CMD="$CMD_START $CMD_END"
    eval $CMD
}

function _forward_postgres_via_ssh() {
    CMD_START="ssh"
    CMD_END=" -f $1 -L $2:$3:5432 -N"
    CMD="$CMD_START $CMD_END"
    eval $CMD
}

function forward-dashboard-dev-mysql() {
    PORT=8806
    _forward_mysql_via_ssh dashboard-dev $PORT 192.168.125.23
    echo "Forwarding using: $PORT"
}

function forward-dashboard-live-mysql() {
    PORT=8807
    _forward_mysql_via_ssh dashboard-live $PORT 192.168.125.152
    echo "Forwarding using: $PORT"
}

function forward-services-dev-mysql() {
    PORT=5438
    _forward_postgres_via_ssh services-dev $PORT 192.168.125.23
    echo "Forwarding using: $PORT"
}

function forward-is-dev-mysql() {
    PORT=8808
    _forward_mysql_via_ssh is-dev $PORT 127.0.0.1
    echo "Forwarding using: $PORT"
}

function forward-is-live-mysql() {
    PORT=8810
    _forward_mysql_via_ssh is-live $PORT 127.0.0.1
    echo "Forwarding using: $PORT"
}

function _forward_rmq_via_ssh() {
    CMD_START="ssh"
    CMD_END=" -f $1 -L $2:localhost:55672 -N"
    if [ -n "$3" ]
    then
        CMD_START="ssh -p $3"
    fi
    CMD="$CMD_START $CMD_END"
    eval $CMD
}

function forward-map-dev-rabbitmq-web() {
    PORT=$RANDOM
    if ! [ `lsof -i :$PORT | grep COMMAND` ]
    then
        _forward_rmq_via_ssh 192.168.125.210 $PORT
        echo "Forwarding using: $PORT @ http://localhost:$PORT"
    else
        forward-map-dev-rabbitmq-web
    fi
}

function forward-map-live-rabbitmq-web() {
    PORT=$RANDOM
    if ! [ `lsof -i :$PORT | grep COMMAND` ]
    then
        _forward_rmq_via_ssh 192.168.126.22 $port
        echo "forwarding using: $port @ http://localhost:$port"
    else
        forward-map-live-rabbitmq-web
    fi
}

function forward-boot2docker-ports() {
    for i in {49000..49900}; do
        VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port$i,tcp,,$i,,$i";
        VBoxManage modifyvm "boot2docker-vm" --natpf1 "udp-port$i,udp,,$i,,$i";
    done
}

function dashboard() {
    workon dashboard
    cd ~/workspace/wolseley-dashboard/www
    ./manage.py runserver 0.0.0.0:8001
}

function services() {
    workon services
    cd ~/workspace/wolseley-services-layer/www
    ./run.py
}

function mpc() {
    workon mpc
    cd ~/workspace/wolseley-mypc/www
    ./manage.py runserver 0.0.0.0:8000
}

function bathroom() {
    workon bathroom
    cd ~/workspace/wolseley-bathroom-showroom/www
    ./manage.py runserver 0.0.0.0:8002
}

source /usr/local/bin/virtualenvwrapper.sh

export PATH="$PATH:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/mysq/lib"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home
export PYTHONPATH=~/workspace/wolseley-tools/modules
export AXIS2_CLASSPATH=/usr/local/lib/axis2-1.6.2/lib
export AXIS2_HOME=/usr/local/lib/axis2-1.6.2

#Text Triumvirate settings
export EDITOR="vim"
bindkey -v 

# vi style incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward  

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

PROMPT='
%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info) 
$(virtualenv_info)%(?,,%{${fg_bold[blue]}%}[%?]%{$reset_color%} )$ '

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

local return_status="%{$fg[red]%}%(?..⤬)%{$reset_color%}"
RPROMPT='${return_status}%{$reset_color%}'

export DOCKER_HOST=tcp://192.168.59.103:2375
export hadoop_install=/users/cmckinnel/workspace

alias b2d='boot2docker'
unsetopt PROMPT_SP
