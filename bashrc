export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/share/npm/bin

export TANGENT_USER='mckinnelc'

alias ll='ls -la'
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

export PATH="$PATH:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/mysq/lib"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home
export PYTHONPATH=~/workspace/wolseley-tools/modules
export AXIS2_CLASSPATH=/usr/local/lib/axis2-1.6.2/lib
export AXIS2_HOME=/usr/local/lib/axis2-1.6.2

#Text Triumvirate settings
export EDITOR="vim"

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

export hadoop_install=/users/cmckinnel/workspace

# Ag silver searcher options
alias ag='ag --smart-case --follow --color'

# Convenience functions

function dpyc() {                                                            
    echo "deleting pyc files"                                                  
    find . -name "*.pyc" -delete                                               
}                                                                              
                                                                               
function all() {                                                               
    echo "opening all $1 files"                                                
    vim $(find -name $1)                                                       
}

. ~/.bash_prompt