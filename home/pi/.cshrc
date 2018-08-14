#!/bin/csh
# .cshrc for Eric Myers <myers@spy-hill.net>  
# Department of Physics, Spy Hill Research
# Department of Physics and Astronomy, Vassar College
# Department of Physics, University of Michigan, Ann Arbor
# @(#) $Id: .cshrc,v 2.51 2001/04/18 19:30:24 myers Exp myers $
#######################################################################
# The .cshrc file is started whenever you start a new csh shell.
# This one does the following:
#
#    (1) sets personalized environment informaion (name and printer)
#    (2) set the path variable so that commands can be found
#    (3) sets other useful environment variables 
#    (4) defines useful command aliases
#    (5) makes adjustments for different flavours of Unix.
#    (6) customized host configuration
#
#######################################################################
## @(#) 1) Personal/Custom information:

# setenv NAME "Eric Myers"
setenv WWW_HOME http://www.spy-hill.net/~myers/Nexus.html
setenv LPDEST  gigo
setenv PRINTER gigo
setenv ORGANIZATION "Spy Hill Research, Poughkeepsie, NY"

#######################################################################
## @(#) 2) Path: try to cover all bases for a wide variety of machines.

# General User:  if you are worried about security you may want to
# remove "." from the path, or at least put it last instead of first.
# If "/" is your $HOME then assume you are root and omit . and /bin

set path=( /usr/local/bin /usr/local/gnu/bin ) 

if ( "$HOME" != "/" && "$HOME" != "/root" ) then
  set path=( . ~/bin ~/local/bin $path )
endif


## University of Michigan ITD/CAEN paths:

if ( -d /usr/um/bin )  set path = ( $path  /usr/um/bin  /usr/um/gnu/bin )
if ( -d /usr/itd/bin ) set path = ( $path  /usr/itd/bin )

## X-window system stuff, in general

if ( -d /usr/local/X11 ) set path = ( $path  /usr/local/X11 )
if ( -d /usr/X11R6/bin ) set path = ( $path  /usr/X11R6/bin )
if ( -d /usr/X11R5 )     set path = ( $path  /usr/X11R5 )
if ( -d /usr/bin/X11 )   set path = ( $path  /usr/bin/X11 )

## BSD if it exists:

if ( -d /usr/ucb )      set path=( $path /usr/ucb )     # BSD on Sun
if ( -d /usr/bsd )      set path=( $path /usr/bsd )     # BSD support on SGI

set path=( $path /usr/bin /bin )   # standard stuff

# SYSV if it exists:

if ( -d /usr/local/sbin )  set path=( $path /usr/local/sbin ) # Linux
if ( -d /usr/sbin )        set path=( $path /usr/sbin ) # SYSV system binaries

# AFS

if ( -d /usr/vice/bin )    set path=( $path /usr/vice/bin )   #
if ( -d /usr/afsws/bin )    set path=( $path /usr/afsws/bin /usr/afsws/etc )

# Assorted specialized directories:

if ( -d /usr/lib/teTeX/bin ) set path=( $path /usr/lib/teTeX/bin ) # teTeX
if ( -d /opt/ansic/bin )    set path=( $path /opt/ansic/bin )    # HP ANSI C
if ( -d /opt/SUNWspro/bin ) set path=( $path /opt/SUNWspro/bin ) # Solaris 
if ( -d /usr/5bin )     set path=( $path /usr/5bin )    # SunOS SYSV support
if ( -d /usr/ccs/bin )  set path=( $path /usr/ccs/bin ) # Solaris/HP C compiler
if ( -d /usr/games )    set path=( $path /usr/games )   # BSD games
if ( -d /usr/X11R6/lib/xscreensaver ) set path=( $path /usr/X11R6/lib/xscreensaver )   
if ( -d /usr/local/lib/xscreensaver ) set path=( $path /usr/local/lib/xscreensaver )   
#if ( -d /opt/root/bin ) set path=( $path /opt/root/bin ) # ROOT


# BNL SGI uses these

if ( -d /PublicDomain/bin ) set path=( $path /PublicDomain/bin ) # BNL
if ( -d /PrivateDomain/bin ) set path=( $path /PrivateDomain/bin ) # BNL


###########################
## @(#) 2c) Library Path: places to look for dynamically loading libraries

# Needed for at/cron jobs to find locally compiled stuff 
setenv LD_LIBRARY_PATH /usr/local/lib:/usr/lib


# Any libraries I might have come first

if ( -d $HOME/lib ) then
  setenv LD_LIBRARY_PATH  $HOME/lib:${LD_LIBRARY_PATH} 
endif



###########################
## @(#) 2c) Man Path: places to look for man pages  (better algorithm)
##      (You can omit trailing man or share/man and they will still be found)

set MANLIST=( /usr/local/gnu/man /usr/local/man /usr/man /usr/share/man )
set MANLIST=( $MANLIST /usr/local/share/man )
set MANLIST=( $MANLIST /usr/X11R6/man /usr/X11R6/LessTif/doc/man )
set MANLIST=( $MANLIST /opt/fortran /opt/ansic /opt/imake /opt/lrom )
set MANLIST=( $MANLIST /usr/lang/man /usr/openwin/man /usr/lib/teTeX/man/ )

setenv MANPATH "$HOME/man"
foreach MANDIR ( $MANLIST )
  if ( "$MANDIR:t" != "man" ) then
    if ( -d $MANDIR/man ) then
      set MANDIR = "$MANDIR/man"
    else if ( -d $MANDIR/share/man ) then
      set MANDIR = "$MANDIR/share/man"
    endif
  endif
  if ( -d $MANDIR ) setenv MANPATH "${MANPATH}:${MANDIR}"
end
unset MANLIST MANDIR

#######################################################################
## @(#) 3) Environment:

## Make sure $user, $USER, and $mail are set, even on "dumb" systems.

if ( ! $?user ) set user=`/bin/whoami`

if ( ! $?USER ) then
  setenv USER=`/bin/whoami`
endif

## If this is an rsh shell we need a "dumb" terminal type:

if ( $?TERM == 0 )  setenv TERM dumb

# Needed to use CVS over ssh

setenv CVS_RSH ssh			

## These are useful even for a noninteractive shell:

setenv TMPDIR   /tmp                            # default temp space
###if ( -d $HOME/tmp ) setenv TMPDIR $HOME/tmp     # personal temp space

setenv TAPE     /dev/rmt/0mnb                   # default tape drive (HP)
if ( -r /dev/nrst0 )  setenv TAPE /dev/nrst0    # Sun/NeXT by default




## If this is not an interactive shell then we are done.

if ($?prompt == 0) then
  #  echo "Non-interactive shell"
endif

#############
## Set up Interactive Environment:

umask 022                       # default is group/world read permission
set notify                      # notify me of job changes
set ignoreeof                   # prevent accidental ^D logout
set shell=/bin/csh              # csh for subshells even if using tcsh
set history=100                 # command history
if ( -d /var/spool/mail ) set MAIL=/var/spool/mail/$USER
if ( $?MAIL ) then              
   set mail=$MAIL               # mail notification ON
endif                           
limit coredumpsize 0k           # no core dumps!

if ( -x /usr/bin/less )       setenv PAGER "less -EX"      # less  > more
if ( -x /usr/local/bin/less ) setenv PAGER "less -EX"      # less  > more

setenv EDITOR "emacs -nw"       # Don't start a window for emacs in X11
setenv VISUAL emacs

setenv SHELL /bin/csh                   # for subshells (not tcsh!)
setenv PPR "enscript -p- -2rG --color=blackwhite -L66 -Z --margins=:::36"
setenv VDEVICE X11                              # VOGL graphics device
setenv TRNINIT $HOME/.trnrc                     # startup for trn



#############
## TeX setup: find ../texmf/

setenv TEXEDIT    "\emacs -nw +%d %s"
setenv TEXFORMATS .:$HOME/texsis/base//
setenv TEXINPUTS  .:$HOME/texsis/styles//:$HOME/texsis/base//
if ( -d /usr/local/texmf ) then
  setenv TEXFORMATS ${TEXFORMATS}:/usr/local/texmf/ini//
  setenv TEXINPUTS  ${TEXINPUTS}:/usr/local/texmf/tex//
else if ( -d /usr/local/share/texmf ) then
  setenv TEXFORMATS ${TEXFORMATS}:/usr/local/share/texmf/web2c//
  setenv TEXINPUTS  ${TEXINPUTS}:/usr/local/share/texmf/tex//
else if ( -d /var/lib/texmf ) then
  setenv TEXFORMATS ${TEXFORMATS}:/var/lib/texmf/web2c//
  setenv TEXINPUTS  ${TEXINPUTS}:/var/lib/texmf/tex//
  setenv TEXINPUTS  ${TEXINPUTS}:/usr/share/texlive/texmf-dist//
else if ( -d /usr/lib/teTeX ) then
  setenv TEXFORMATS ${TEXFORMATS}:/usr/lib/teTeX/texmf/web2c//
  setenv TEXINPUTS  ${TEXINPUTS}:/usr/lib/teTeX/texmf/tex//
else if ( -d /usr/share/texmf ) then
  setenv TEXFORMATS ${TEXFORMATS}:/usr/share/texmf/web2c//
  setenv TEXINPUTS  ${TEXINPUTS}:/usr/share/texmf/tex//

# Old location before ../texmf/ convention:
else if ( -d /usr/local/lib/tex ) then
  setenv TEXFORMATS ${TEXFORMATS}:/usr/local/lib/tex/formats//
  setenv TEXINPUTS  ${TEXINPUTS}:/usr/local/lib/tex/inputs//
endif

#############
## Put current directory in csh prompt:

set prompt="% "
set HOSTNAME=`hostname| awk -F. '{print $1}'`   # shortname only!
setenv HOST $HOSTNAME
alias setprompt 'set prompt="${HOST}:$cwd:t> "'
if ( `whoami` == "root") alias setprompt 'set prompt="${HOST}:$cwd:t# " '
if ( $TERM == "emacs" || $TERM == "unknown" || $TERM == "dumb" ) \
            alias setprompt set prompt=\"% \"
alias cd  'cd \!* ; setprompt'
alias pd  'pushd \!* ; setprompt '
alias pop 'popd \!* ; setprompt'
setprompt


#######################################################################
## @(#) 4) Command Aliases: 

alias emacs emacs -nw                   # No new windows for emacs
alias mroe more                         # since it is easy to type this instead
alias ls ls -F                          # -F show executabls and links
alias dirf 'ls -ltF \!* | more '        # full directory listing
alias rm rm -i                          # some protection
alias mv mv -i                          # some more protection
alias cp cp -i                          # even more protection
alias cx chmod +x                       # to make a file executable
alias cw chmod +w                       # to make a file writeable
alias hide chmod go-rwx                 # to hide files
alias unhide chmod go+r                 # to make files public
alias msgs msgs -p                      # msgs uses more to page
alias lo logout
alias h history
alias c clear
alias gs gs -q                  # ghostscript should be seen, not heard


alias listing  'enscript -p/tmp/listing.ps  -2rG --color=blackwhite -L66 -Z --margins=:::36  \!* &&  ps2pdf /tmp/listing.ps /tmp/listing.pdf && xpdf /tmp/listing.pdf '
alias listing-color 'enscript -p/tmp/listing.ps  -2rG --color -L66 -Z --margins=:::36  \!*  &&  ps2pdf /tmp/listing.ps /tmp/listing.pdf && xpdf /tmp/listing.pdf '

alias screen 'screen -fn -R'
alias rlast 'rsh -n \!^ last  \!:2* | more'
alias mfinger 'finger `awk '\'' /^alias/ { if ( $2 == name ) {for (i = 3; i <= NF; ++i) print $i }}  '\'' name=\!* ~/.mailrc`'  

alias psgrep   'ps -aux | grep \!* | grep -v grep'
alias rpmgrep   'rpm -qa | grep \!* | grep -v grep'
alias ffind 'find . -name "*\!{^}*" \!:2*  -print '  # find a file
alias du-s du -s \* \| sort -n          
alias cvsq "cvs -q -n update \!* | grep -v '? '"     # list CVS changes
alias svnq "svn status -q \!* | grep -v '? '"        # list SVN changes
alias gitq "git diff --name-status "		     # list git changes


##alias rgrep 'find . -xdev -type f -print -exec grep "\!*" {} \; '
alias cdtw  source ~/.twrc 
alias csu "/bin/su - root -c /usr/local/bin/tcsh "

## Alias these commands only if real ones are/aren't there

if ( -x /usr/local/bin/mush ) then
  alias mail mush       
  alias todo mush -f +TODO              
  alias pers mush -f +Pers
endif

##if ( ! -x /usr/local/bin/info ) alias info emacs -f -info

if ( ! -x /usr/X11R6/bin/gv )   alias gv ghostview
if ( -x /usr/bin/gsview )       alias gv /usr/bin/gsview
if ( -x /usr/bin/gv )           unalias gv 


if ( -x /usr/bin/less )         alias more less -EX
if ( -x /usr/local/bin/less )   alias more less -EX

## autologout root shells but not others

if ( `whoami` == "root") then
  set autologout = 60   # do not let root shells hang around
  setenv TMOUT 3600     # will be inherited by bash shells 
else
  unset autologout
endif



## VMS command synonyms (can't hurt, might help):

alias dir ls
alias copy cp -i
alias delete rm -i 
alias type cat
alias rename mv -i
alias fort f77


#######################################################################
## @(#) 5) Different Flavours of Unix:

set UNAME = "unknown"
if ( -x /bin/uname )            set UNAME = `/bin/uname` 
if ( -x /usr/bin/uname )        set UNAME = `/usr/bin/uname` 
if ( -x /usr/local/bin/uname )  set UNAME = `/usr/local/bin/uname` 


#############
## Linux

if ( "$UNAME" ==  "Linux" ) then

  setenv TAPE /dev/fd0

  alias ls 'ls -F --color=auto'
  alias nslookup 'nslookup -silent '

  alias dirf 'ls -ltF --color=always \!* | /bin/more '
  alias psgrep   'ps auxw | grep \!* | grep -v grep'

  if ( -x /usr/bin/info) unalias info

  if ( "`groups | grep adm `" != "" || `whoami` == "root") then
    set path=( /usr/local/adm /usr/local/sbin  $path  /sbin /usr/sbin  )
  endif

  # This is at the end because it may fail 
  unsetenv LS_COLORS
  eval `dircolors -c $HOME/.dir_colors `

endif


#############
## Darwin (Mac OS X)

if ( "$UNAME" ==  "Darwin" ) then

   alias psgrep   'ps -auxw | grep \!* | grep -v grep'

  if ( "`groups | grep adm `" != "" || `whoami` == "root") then
    set path=( /usr/local/adm /usr/local/sbin  $path  /sbin /usr/sbin  )
  endif

  # Fink initialization:

  if ( -f /sw/bin/init.csh ) then 
    source /sw/bin/init.csh
    set path=( $path /sw/bin )
  endif

endif


#############
## NeXTSTep/mach:

if ( -f /sdmach ) then 
  set path=( $path ~/Apps /LocalApps /NextApps /NextDeveloper/Demos ) 
  alias lpq lpq -P\$PRINTER             # dumb NeXT!
  alias lpr lpr -P\$PRINTER             # dumb NeXT!
  if ( "$UNAME" == "unknown" ) alias uname echo NEXTSTEP
  set UNAME = NEXTSTEP
  alias rlast 'rsh \!^ -n last  \!:2* | more'
  setenv TAPE /dev/nrst0

  # System Administrator or superuser on NeXT

  if ( "`groups | grep staff`" != "" ) then
    set path=( $path /etc /usr/etc /NextAdmin )  
  endif

  if ( "$user" == "root") then
    set path= ( /NextAdmin /usr/etc /etc $path ) # dot not first!
    unset ignoreeof     
  endif

endif




#############
## HP-UX 9.x or 10.X

if ( "$UNAME" == "HP-UX"  && ( -f /hp-ux || -f /stand/vmunix ) ) then
  set path=( $path /usr/contrib/bin /usr/contrib/bin/X11 )
  if ( -d /opt/ansic/bin ) set path=( $path /opt/ansic/bin ) # HP ANSI C
  alias ps5     'top -d1 -n5'
  alias psgrep  'ps -ef | grep \!* | grep -v grep'
  alias dirf 'ls -tlF \!* | more '      # full directory listing
  if ( ! -x /usr/bin/lpr ) alias lpr lp -d\${LPDEST}
  alias lpq lpstat \${LPDEST}
  alias lprm cancel \$\{LPDEST\}-\$1
  alias atq at -l
  alias atrm at -r 
  alias last last -R
  alias who  who  -R
  alias rlast 'rsh \!^ -n last -R \!:2* | more'

  if ( -x /usr/bin/remsh && ! -x /usr/local/bin/rsh ) then
    alias rsh /usr/bin/remsh
  endif

  if ( -d /opt/lrom ) then  ## HP LaserROM on-line manuals
    set path=( $path /opt/lrom/bin )
    setenv MANPATH ${MANPATH}:/opt/lrom/share/man
  endif

  # System Administrator or superuser:

  if ( "`groups | grep staff`" != "" || `whoami` == "root") then
    set path=( $path /sbin /usr/sbin /usr/etc )  
  endif

endif


#############
## SunOS 4.x:

if ( "$UNAME" ==  "SunOS" && -f /vmunix ) then
  alias ps5       'ps -auxg | head -6 '
  setenv TAPE /dev/nrst0
  if ( "`groups | egrep 'staff|operator'`" != "" ) then   
    set path= ( $path /usr/etc )
  endif
endif


#############
## Solaris (SunOS 5.x):

if ( "$UNAME" ==  "SunOS" && -f /kernel/genunix  ) then
  set path=( $path /usr/openwin/bin/ )
  alias ps5     'ps -auxg | head -6 '
  alias psgrep  'ps -aux | grep \!* | grep -v grep'
  alias dirf 'ls -tlFg \!* | more '     # full directory listing
  setenv TAPE /dev/rmt/0mnb
endif



#############
## SGI/IRIX 

if ( "$UNAME" ==  "IRIX64" ) then
  alias psgrep  'ps -Af | grep \!* | grep -v grep'
endif

if ( "$UNAME" ==  "IRIX" ) then
    set path=( $path /usr/bsd )
endif


##################################################
# No dot in root's path!!!

if ( `whoami` == "root") then
  set path=`echo $path | sed -e "s/\. / /"`  # Remove 'dot' from path
  unset ignoreeof     
endif


#######################################################################
## @(#) 6) Custom host configuration

set HOSTNAME=`hostname| awk -F. '{print $1}'`  # hostname -s for everybody
if ( -x $HOME/.cshrc.$HOSTNAME ) then
  source $HOME/.cshrc.$HOSTNAME
endif

exit 0
