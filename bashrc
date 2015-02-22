export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/share/npm/bin

export LC_ALL=en_GB.utf-8 
export LANG="$LC_ALL" 

export TANGENT_USER='mckinnelc'
export EVOSHAVE_USER='ubuntu'

export HISTSIZE=1000000
export HISTFILESIZE=2000000
shopt -s histappend
export PROMPT_COMMAND='history -a'

export HOST_IP=$(ifconfig wlp3s0 | grep 'inet 192' | awk '{ print $2}')

function cd() {
    builtin cd "$1"
    NOW=$(date +"%Y-%m-%dT%T")
    echo "$NOW `pwd`" >> ~/.cd_history
}

# Aliases to make my life easier
alias aurget='aurget --noedit'
alias startx='ssh-agent startx'
alias ls='ls --color'
alias ll='ls -la'
alias gs='git status' 
alias gl='git log --graph --decorate'
alias gco='git checkout'                                                              
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
alias pacman='sudo pacman'
alias db-mysql='mysql -u docker -h 127.0.0.1 -P 3307 -pdocker'
alias db-pg='PGPASSWORD=docker psql services -U docker -h 127.0.0.1 -p 5433 -w'
alias t='todo'
alias tls='todo -p'
alias td='todo -dl'
alias ta='todo -al'


# Docker aliases
# ==============

# Always sudo nsenter
alias nsenter='sudo nsenter'

# Remove ALL containers, running or not
alias clean-all-containers='docker rm $(docker stop $(docker ps -aq))'

# Remove all containers that aren't running and aren't data-only volumes
alias clean-containers='docker rm $(docker ps -a | grep -v "volumes" | grep -v "Up" | cut -d" " -f1 | tail -n+2)'

# Remove all images that were unsuccessfully built
alias clean-images='docker rmi $(docker images -q --filter "dangling=true")'

# Stop all running containers
alias stop-containers='docker rm $(docker stop $(docker ps -q))'

# I got used to typing reenter, alias it until I stop typing it
alias reenter='ec'

# Wrap our nsenter calls in a convenience function
# 
# Usage:
# 
# Enter the only running container:
# 
# ec
# 
# Enter a specified container (by container ID or container name)
#
# ec 32402af8f15a
# ec dashboard-app-latest
function ec() { 
    if [[ -z $1 ]]; then
        printf "\nUsage: ec CONTAINER_ID | CONTAINER_NAME\n\n"
        return
    elif [[ ! -z $2 ]]; then
        printf "\nUsage: ec CONTAINER_ID | CONTAINER_NAME\n\n"
        return
    fi
    NSENTER_PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin 
    NSENTER_PATH=$NSENTER_PATH nsenter -t $(docker inspect --format '{{ .State.Pid }}' $(echo $1|cut -d',' -f1)) -m -u -n -i -p -w
}

# Hook our nsenter into the docker auto-complete for some sweet TAB action
complete_nsenter() {
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    nsenter_exec=$(type -P nsenter)
    nsenter=$(basename $nsenter_exec)

    CONTAINER_IDS=$(docker ps -a |grep -v CONTAINER\ ID|awk '{print $1}')
    CONTAINER_NAMES=$(docker ps -a |grep -v CONTAINER\ ID|awk '{print $NF}')

    COMPREPLY=($(compgen -W "$CONTAINER_IDS $CONTAINER_NAMES" -- $cur))
}
complete -F complete_nsenter ec

alias supervisorctl='sudo supervisorctl'
alias j='cd ~/workspace/jektabox'
alias c='cd ~/workspace/wolseley-connect-phone-directory'
alias d='cd ~/workspace/wolseley-dashboard && source ~/virtualenvs/dashboard/bin/activate'
alias s='cd ~/workspace/wolseley-services-layer && source ~/virtualenvs/services/bin/activate'
alias cc='cd ~/workspace/wolseley-consumer-controls'
alias ni='cd ~/workspace/wolseley-national-accounts-importer'
alias work='sudo netctl switch-to tangent-staff'
alias gibbon='sudo netctl switch-to gibbon'
alias westway='sudo netctl switch-to westway'
alias penthouse='sudo netctl switch-to penthouse'
alias lock='xscreensaver-command -lock'
alias bashrc='vim ~/.bashrc'
alias sbashrc='source ~/.bashrc'
alias vimrc='vim ~/.vimrc'
alias g='ping 8.8.8.8'


#### Tmux shortcuts ####

function tmux-irssi() {
    tmux new-session -d -s irssi || return
    tmux send-keys -t irssi:0 "irssi -c freenode" C-m
}

function tmux-bash() {
    tmux new-session -d -s bash
}

function tmux-general() {
    tmux-irssi
    tmux-jabber
    tmux-bash
    tmux attach -t bash
}

function tmux-jabber() {
    tmux new-session -d -s jabber || return
    tmux send-keys -t jabber:0 "profanity -a work" C-m
}

function tmux-nails() {
    tmux-general
    tmux new-session -d -s nails
    tmux send-keys -t nails:0 "nailsinc" C-m
    tmux new-window -t nails:1 -n vim
    tmux send-keys -t nails:1 "cd ~/workspace/nailsinc-us; vim +NERDTree" C-m
    tmux attach -t nails
}

alias tmux-jektr='tmux new-session -c ~/workspace/jektabox -s jektr'

source /usr/share/git/completion/git-completion.bash

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

function forward-boot2docker-ports() {
    for i in {49000..49900}; do
        VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port$i,tcp,,$i,,$i";
        VBoxManage modifyvm "boot2docker-vm" --natpf1 "udp-port$i,udp,,$i,,$i";
    done
}

export GOPATH=$HOME/workspace/go
export PATH="$PATH:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/mysq/lib"
export PATH="$PATH:$GOPATH/bin"

#Text Triumvirate settings
export EDITOR="vim"

# Ag silver searcher options
alias ag='ag --smart-case --follow --color'

function jektr {
    cd /home/cmckinnel/workspace/jektabox
    ./run.sh webclient /containers/webclient $1 8000
}

function dashboard {
    cd /home/cmckinnel/workspace/wolseley-dashboard
    ./run.sh dashboard /containers/wolseley-dashboard $1 8000
}

function nailsinc {
    cd /home/cmckinnel/workspace/nailsinc-us
    ./run.sh app local /containers/nailsinc latest 8000
}

function services {
    cd /home/cmckinnel/workspace/wolseley-services-layer
    ./run.sh services local $1 /containers/wolseley-services-layer 5000
}

function rabbitmq {
    cd /home/cmckinnel/workspace/wolseley-services-layer
    ./run.sh rabbitmq local $1 /containers/wolseley-services-layer
}

function connect {
    cd /home/cmckinnel/workspace/wolseley-connect-phone-directory
    ./run.sh /containers/wolseley-connect $1 9080
}

function wcc {
    cd /home/cmckinnel/workspace/wolseley-consumer-controls
    ./run.sh local $1 /containers/wolseley-consumer-controls 8001
}

function jekta-logs {
    cd /containers/jektabox/logs
}

function dashboard-logs {
    tail -f /containers/wolseley-dashboard/logs/*
}

function services-logs {
    tail -f /containers/wolseley-services-layer/logs/*
}

function jektr-dev() {
    ssh -i /home/cmckinnel/jekta-pems/jektr-ireland-ec2-instances.pem ubuntu@ec2-54-76-231-83.eu-west-1.compute.amazonaws.com
}

function jektr-test() {
    ssh -i /home/cmckinnel/jekta-pems/jektr-singapore-ec2-instances.pem ubuntu@ec2-54-255-167-175.ap-southeast-1.compute.amazonaws.com
}

function jektr-demo() {
    ssh -i /home/cmckinnel/jekta-pems/jektr-california-ec2-instances.pem ubuntu@ec2-54-183-188-192.us-west-1.compute.amazonaws.com
}

function jl() {
    tail -F /containers/webclient/logs/django_management.log \
            /containers/webclient/logs/celery.log            \
            /containers/webclient/logs/clientproxy.log       \
            /containers/webclient/logs/postgresql.log
}

function aa_mod_parameters () { 
    N=/dev/null;
    C=`tput op` O=$(echo -en "\n`tput setaf 2`>>> `tput op`");
    for mod in $(cat /proc/modules|cut -d" " -f1);
    do
        md=/sys/module/$mod/parameters;
        [[ ! -d $md ]] && continue;
        m=$mod;
        d=`modinfo -d $m 2>$N | tr "\n" "\t"`;
        echo -en "$O$m$C";
        [[ ${#d} -gt 0 ]] && echo -n " - $d";
        echo;
        for mc in $(cd $md; echo *);
        do
            de=`modinfo -p $mod 2>$N | grep ^$mc 2>$N|sed "s/^$mc=//" 2>$N`;
            echo -en "\t$mc=`cat $md/$mc 2>$N`";
            [[ ${#de} -gt 1 ]] && echo -en " - $de";
            echo;
        done;
    done
}

function show_mod_parameter_info ()
{
  if tty -s <&1
  then
    green="\e[1;32m"
    yellow="\e[1;33m"
    cyan="\e[1;36m"
    reset="\e[0m"
  else
    green=
    yellow=
    cyan=
    reset=
  fi
  newline="
"

  while read mod
  do
    md=/sys/module/$mod/parameters
    [[ ! -d $md ]] && continue
    d="$(modinfo -d $mod 2>/dev/null | tr "\n" "\t")"
    echo -en "$green$mod$reset"
    [[ ${#d} -gt 0 ]] && echo -n " - $d"
    echo
    pnames=()
    pdescs=()
    pvals=()
    pdesc=
    add_desc=false
    while IFS="$newline" read p
    do
      if [[ $p =~ ^[[:space:]] ]]
      then
        pdesc+="$newline    $p"
      else
        $add_desc && pdescs+=("$pdesc")
        pname="${p%%:*}"
        pnames+=("$pname")
        pdesc=("    ${p#*:}")
        pvals+=("$(cat $md/$pname 2>/dev/null)")
      fi
      add_desc=true
    done < <(modinfo -p $mod 2>/dev/null)
    $add_desc && pdescs+=("$pdesc")
    for ((i=0; i<${#pnames[@]}; i++))
    do
      printf "  $cyan%s$reset = $yellow%s$reset\n%s\n" \
        ${pnames[i]} \
        "${pvals[i]}" \
        "${pdescs[i]}"
    done
    echo

  done < <(cut -d' ' -f1 /proc/modules | sort)
}

# Add these functions to your ~/.bashrc in order to be able to query private
# Docker registries from the commandline. You'll need the JQ library 
# (http://stedolan.github.io/jq/) to be installed. Alternatively, you can just 
# pipe to " python -mjson.tool" to get pretty JSON formatting
 
# TODO Enter the correct details here
DOCKER_REGISTRY_HOST=docker.tangentlabs.co.uk
DOCKER_REGISTRY_AUTH=publisher:FDA6A53A-6E14-444F-930B-9EF1749D2744
 
DOCKER_STAGE_HOST=docker-images-dev.tangentlabs.co.uk
DOCKER_STAGE_AUTH=publisher:2aeI4rTeRiDtonm7BqyicOalMv5zKw3EEj2y7CEQ1An9AneIgh

# PROD

function _docker_fetch() {
    echo $1
    curl -s --user $DOCKER_REGISTRY_AUTH $1 | jq '.'
}
 
# List repos (query string is optional)
function docker_live_search() {
    _docker_fetch https://$DOCKER_REGISTRY_HOST/v1/search?q=$1
}
 
# List tags for a repo
function docker_live_tags() {
    _docker_fetch https://$DOCKER_REGISTRY_HOST/v1/repositories/$1/tags
}

# STAGE
function _docker_stage_fetch() {

    echo $1
    curl -s --user $DOCKER_STAGE_AUTH $1 | jq '.'
}

# List repos (query string is optional)
function docker_stage_search() {
    _docker_stage_fetch https://$DOCKER_STAGE_HOST/v1/search?q=$1
}

# List tags for a repo
function docker_stage_tags() {
    _docker_stage_fetch https://$DOCKER_STAGE_HOST/v1/repositories/$1/tags
}

function bright() {
    sudo tee /sys/class/backlight/gmux_backlight/brightness <<< 82310 &> /dev/null
}

function dim() {
    sudo tee /sys/class/backlight/gmux_backlight/brightness <<< 10000 &> /dev/null
}

function eclim() {
    cd /usr/share/eclipse/
    ./eclimd
}

ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

. ~/.bash_prompt
