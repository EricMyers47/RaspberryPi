# Extracted from .bashrc for myers@vassar.edu
##############################################
# User specific aliases (those with arguments should be functions)

alias emacs="emacs -nw"
alias mroe="more"
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias cx="chmod +x"
alias cw="chmod +w"
alias hide="chmod go-rwx"
alias unhide="chmod go+r"
alias h="history"
alias c="clear"

alias ll="ls -Flg"

alias pd='pushd'
alias pop="popd"

#alias which="type -path"

##################################################
# Shell functions:

dirf () {           # "full" directory listing
   ls -ltFg $* | more
}


dirt () {           # directory listing for "today"
   dt=`date +"%b %e"`
   ls -ltFg $* | grep "$dt" | more
}

ffind () {          # find a file quickly
    PAT=$1; shift
    find . -name "*$PAT*" $*  -print 
}

psgrep () {         # list specified process
   ps auxw | grep $1 | grep -v grep
}

rpmgrep () {        # grep the installed rpm list
  rpm -qa | grep $*
}

du-s () {
  du -s * | sort -n 
}


##################################################
# Root shells should be limited

if [ `whoami` = 'root' ];then
  TMOUT=3600
  # PS1="[\W]# "  
  # PATH=/usr/local/adm:/usr/local/sbin:/usr/sbin:/sbin:$PATH
  # PATH=`echo $PATH | sed -e "s/\.://"`  # Remove 'dot' from path
fi

##
