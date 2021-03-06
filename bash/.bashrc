# setup path
export PATH="./node_modules/.bin:~/local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/opt/X11/bin:/usr/X11/bin"

# go path
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/code/go
export PATH=$PATH:$GOPATH/bin

# package config
export PKG_CONFIG_PATH=/usr/X11/lib/pkgconfig

# This loads NVM
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh


# perl
export PERL_LOCAL_LIB_ROOT="$HOME/perl5:$PERL_LOCAL_LIB_ROOT";
export PERL_MB_OPT="--install_base "$HOME/perl5"";
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
export PERL5LIB="$HOME/perl5/lib/perl5:$PERL5LIB";
export PATH=$PATH:$HOME/perl5/bin

# load profile data
# important that it's loaded after path is set
[[ -f /etc/profile ]] && . /etc/profile
[[ -f $HOME/.profile ]] && source ~/.profile

# load aliases
[[ -f $HOME/.alias ]] && source ~/.alias

export EDITOR='vim'

# edit .bashrc and vim
alias be='$EDITOR ~/.bashrc'
alias bea='$EDITOR ~/.alias'
alias bep='$EDITOR ~/.profile'
alias bedb='$EDITOR ~/.db'
alias br='. ~/.bashrc'
alias ve='$EDITOR ~/.vimrc'
alias veb='$EDITOR ~/.vim/mybundle.vim'
alias ves='$EDITOR ~/.vim/shared.vim'
alias jse='$EDITOR ~/.jshintrc'
alias scd='cd ~/.vim/bundle/vim-snippets/snippets'
alias ec2-e='$EDITOR ~/.ec2sshrc'

# kill processes that match pattern
function killme() {
  pids=`ps ax | grep -v grep | grep "$1" | awk '{ print $1 }'`
  if [ -n "$pids" ]
  then
    kill -9 $pids
  fi
}

# z
. $HOME/.bash/z/z.sh

# kafka
export KAFKA_HOME=~/local/kafka
export KAFKA=$KAFKA_HOME/bin
export KAFKA_CONFIG=$KAFKA_HOME/config

# styles
BOLD='\033[1m'
BOLD_RESET='\033[22m'
ITALIC='\033[3m'
ITALIC_RESET='\033[23m'
UNDERLINE='\033[4m'
UNDERLINE_RESET='\033[24m'
INVERSE='\033[7m'
INVERSE_RESET='\033[27m'

# colors
WHITE='\033[37m'
GREY='\033[90m'
BLACK='\033[30m'

BLUE='\033[34m'
BLUE='\033[34m'
CYAN='\033[36m'
GREEN='\033[32m'
MAGENTA='\033[36m'
RED='\033[31m'
YELLOW='\033[33m'

RESET='\033[39m'

# prompt
source ~/.bash/git-aware-prompt/prompt.sh
export PS1="\[$BOLD$GREY\]\W\[$RESET$RESET_BOLD$CYAN\]\$git_branch\$git_dirty\[$RESET$GREEN\] \\$\[$RESET$BOLD_RESET\] "

# added by travis gem
[ -f "$HOME"/.travis/travis.sh ] && source "$HOME"/.travis/travis.sh

# git tab completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
  __git_complete gco _git_checkout
  __git_complete gm _git_merge
  __git_complete gbd _git_branch
fi

# arcanist
source "/Users/roly/.arc_loc"
export PATH="$PATH:$ARC_LOC/arcanist/bin"

export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

export PYTHONDONTWRITEBYTECODE=1
