#  ---------------------------------------------------------------------------
#
#  Description:  This file holds all my BASH configurations and aliases
#
#  Sections:
#  1.   Environment Configuration
#  2.   Terminal Improvements (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Networking
#  7.   System Operations & Information
#  8.   Development
#  9.   Project Specific 
#  10.  Reminders & Notes
#
#  ---------------------------------------------------------------------------

#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Set Paths
#   ------------------------------------------------------------
    export PATH="$PATH:/usr/local/bin/"
    export PATH="/usr/local/git/bin:/sw/bin/:/usr/local/bin:/usr/local/:/usr/local/sbin:/usr/local/mysql/bin:$PATH"

#   Set Default Editor (change 'Nano' to the editor of your choice)
#   ------------------------------------------------------------
    export EDITOR=/usr/bin/vim

#   Add color to terminal
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad

#   Set other environment variables
#   -------------------------------
    export NVM_DIR=~/.nvm
    export ANDROID_HOME=/usr/local/opt/android-sdk

#   Add SSH keys
#   ------------
    ssh-add ~/.ssh/*.pem > /dev/null 2>&1
    ssh-add ~/.ssh/*.pub > /dev/null 2>&1

#   Load NVM
#   -------- 
    source $(brew --prefix nvm)/nvm.sh
    nvm use v0.10.33 > /dev/null

#   PyEnv
#   -----
    if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
    pyenv global 2.7.8

#   Virtualenvwrapper
#   -----------------
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/Dropbox/SoftwareDevelopment
    pyenv virtualenvwrapper 


#   -----------------------------
#   2.  TERMINAL IMPROVEMENTS 
#   -----------------------------

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias edit='st'                             # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop
alias profile='edit ~/.bash_profile'
alias setprofile='source ~/.bash_profile'
alias ssh-config='st ~/.ssh/config'

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
#   --------------------------------------------------------------------
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
    showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }

#   Directory marking
#   from http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
#   -----------------------------------------------------------------------------------------------------
    export MARKPATH=$HOME/.marks
    function jump {
        cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
    }
    function mark {
        mkdir -p $MARKPATH; ln -s "$(pwd)" $MARKPATH/$1
    }
    function unmark {
        rm -i $MARKPATH/$1
    }
    function marks {
        ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
    }

#   Run creation
#   ------------
    export RUNPATH=$HOME/.runs
    export RUNEDITOR=vim
    function run {
        . $RUNPATH/$1 2>/dev/null || echo "No such run: $1"
    }

    function editrun {
        $RUNEDITOR $RUNPATH/$1
    }

    function mkrun {
        mkdir -p $RUNPATH && editrun $1
    }

    function lsruns {
        ls -l $RUNPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
    }

    function rmrun {
        rm $RUNPATH/$1 2>/dev/null || echo "No such run: $1"
    }

#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------

zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
alias numFilesRec='find . -type f | wc -l'  # numFilesRec:  Count all files in current dir recursively 

#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }

#   ---------------------------
#   4.  SEARCHING
#   ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }


#   ---------------------------
#   5.  PROCESS MANAGEMENT
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
    findPid () { lsof -t -c "$@" ; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
    alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"

#   myPs: List processes owned by my user:
#   ------------------------------------------------------------
    myPs() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }


#   ---------------------------
#   6.  NETWORKING
#   ---------------------------

alias publicip='curl ip.appspot.com'                # publicip:     Public facing IP Address
alias localip='ipconfig getifaddr en0'           # localip:      IP within current network 
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }


#   ---------------------------------------
#   7.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   -------------------------------------------------------------------
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -----------------------------------------------------------------------------------
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#    screensaverDesktop: Run a screensaver on the Desktop
#   -----------------------------------------------------------------------------------
    alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

#   ---------------------------------------
#   8.  DEVELOPMENT
#   ---------------------------------------

#   # httpHeaders:      Grabs headers from web page
#   -----------------------------------------------
    httpHeaders () { /usr/bin/curl -I -L $@ ; }             

#   httpDebug:  Download a web page and show info on what took time
#   -------------------------------------------------------------------
    httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

#   AWS
#   --- 
    alias eb-push="export AWS_CREDENTIAL_FILE='.credentials/deployment' && git aws.push" # Useful for when credentials stored in directory relative to current path 

#   Git 
#   --- 
    alias gitc="git add --all :/ && git commit -am"

#   C
#   -
    function gccit {
        gcc -o $1 $1.c -Wall -ansi -O3 -g
    }
    function gccitr {
        gccit $1
        ./$1
    }

#   Haskell
#   -------
    function ghcit {
        ghc -o $1 $1.hs
    }
    function ghcitr {
        ghcit $1
        ./$1
    }

#   Django
#   ------
    alias m='python manage.py'
    alias rs='python manage.py runserver'
    alias rse='python manage.py runserver 0.0.0.0:8000' 
    alias sm='python manage.py schemamigration'
    alias clearprofdata='rm -r tmp/profile_data && mkdir tmp/profile_data'
    alias djprof='python manage.py runprofileserver --prof-path=tmp/profile_data --kcachegrind'
    alias djprofe='python manage.py runprofileserver 0.0.0.0:8000 --prof-path=tmp/profile_data --kcachegrind'

#   Application launching 
#   ---------------------
    alias chrome-danger='open -a "Google Chrome" --args --disable-web-security'
    alias chrome-vr='open -a "Google Chrome" --args --enable-vr'
    alias safari-danger='open -a "/Applications/Safari.app" --args --disable-web-security'
    alias start-mysql='mysql.server start'
    alias start-memcached='/usr/local/opt/memcached/bin/memcached & > /dev/null 2>&1'

#   ---------------------------------------
#   9.  PROJECT SPECFIC
#   ---------------------------------------

#   Fairshare 
#   --------- 
    export FAIRSHARE_API_LOCATION='/Users/alex/Dropbox/SoftwareDevelopment/projects/fairshare/fairshare-api/app/'
    export FAIRSHARE_API_URL=http://$(ipconfig getifaddr en0):8000
    export FAIRSHARE_API_VENV_LOCATION='/Users/alex/.virtualenvs/fairshare'
    alias fs_start_staging_tunnel='ssh -fNg -L 3307:aa1axzb98no37m0.chj72em4vhkj.ap-southeast-2.rds.amazonaws.com:3306 fs_api_st'
    alias fs_start_prod_tunnel='ssh -fNg -L 3308:aa5wtskrtlmhtz.chj72em4vhkj.ap-southeast-2.rds.amazonaws.com:3306 fs_api_pr'

#   Ebla 
#   ---- 
    alias ebla_start_db_tunnel='ssh -fNg -L 3307:ebla-production.cplmrwok1cmc.ap-southeast-2.rds.amazonaws.com:3306 ebla_taskrunner'
    alias ebla_start_es_tunnel='ssh -fNg -L 9202:localhost:9200 ebla_es_opsworks'

#   Myagi
#   ----- 
    alias myagi-fab='fab -A -f newfabfile/ --roles=production -u alex'
    alias myagi-getdb='scp alex@production-gw-us-west-2a.myagi.com:/data/backups/latest-myagi2.dump ./'
    alias myagi-loaddb='pg_restore -U myagi -d "myagi" --clean ./latest-myagi2.dump && rm ./latest-myagi2.dump'

#   ---------------------------------------
#   10.  REMINDERS & NOTES
#   ---------------------------------------

#   remove_disk: spin down unneeded disk
#   ---------------------------------------
#   diskutil eject /dev/disk1s3

#   to change the password on an encrypted disk image:
#   ---------------------------------------
#   hdiutil chpass /path/to/the/diskimage

#   to mount a read-only disk image as read-write:
#   ---------------------------------------
#   hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

#   mounting a removable drive (of type msdos or hfs)
#   ---------------------------------------
#   mkdir /Volumes/Foo
#   ls /dev/disk*   to find out the device to use in the mount command)
#   mount -t msdos /dev/disk1s1 /Volumes/Foo
#   mount -t hfs /dev/disk1s1 /Volumes/Foo

#   to create a file of a given size: /usr/sbin/mkfile or /usr/bin/hdiutil
#   ---------------------------------------
#   e.g.: mkfile 10m 10MB.dat
#   e.g.: hdiutil create -size 10m 10MB.dmg
#   the above create files that are almost all zeros - if random bytes are desired
#   then use: ~/Dev/Perl/randBytes 1048576 > 10MB.dat

#   to start time machine backup 
#   ----------------------------
#   tmutil startbackup

#   to remove local time machine backups (and save disk space)
#   ----------------------------------------------------------
#   sudo tmutil disablelocal





