# .bashrc

# alias vim='nvim'

# Function to create files and make them executable as well
script(){
  echo "#!/usr/bin/env bash

" > ${1}.sh;
  chmod +x ${1}.sh;
  vim ${1}.sh;
}

# Function to move files to a backup file
bak(){
  # write if condition, if file is .bak then revert it
  if [ ${1: -4} == ".bak" ]; then
    mv $1 $(echo $1 | rev | cut -c 5- | rev)
    return
  fi
  mv $1 $1.bak
}

cedit(){
  mv $1 $1.bak
  # get full path of the file
  current_dir=$(pwd | sed 's|/home/nazakat/.||g' | sed 's|config|configs|g')
  # create a symbolic link
  ln -s ~/.dotfiles/$current_dir/$1 $1
  nvim $1
}
revert(){
  mv $1.bak $1
}

##NixOS update functions
ns(){ # nix switch
  pushd ~/.dotfiles
  git add .
  git diff HEAD -- . '*'
  echo "NixOS Rebuilding ... "
  sudo nixos-rebuild switch --flake .
  gen=$(nixos-rebuild list-generations | grep current | awk '{print $1,$2}')
  read -p "Enter a commit message: " message
  git commit -m "$message ($gen)"
  popd
}
nt(){ # nix test
  pushd ~/.dotfiles
  git add .
  git diff HEAD -- . '*'
  echo "NixOS Testing ... "
  sudo nixos-rebuild test --flake .
  popd
}
alias nr='sudo /nix/var/nix/profiles/system/bin/switch-to-c
onfiguration switch'
nu(){
  pushd ~/.dotfiles
  nix flake update
  popd
}

# get hash

gethash(){
  nix hash to-sri --type sha256 $(nix-prefetch-url --unpack "$1")
}

alias cat='bat'

##Cmatrix thing
alias matrix='cmatrix -s -C cyan'

#iso and version used to install ArcoLinux
alias iso="cat /etc/dev-rel | awk -F '=' '/ISO/ {print $2}'"

#ignore upper and lowercase when TAB completion
bind 'set completion-ignore-case off'

#systeminfo
alias probe='sudo -E hw-probe -all -upload'

# Replace ls with exa
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l='exa -lah --color=always --group-directories-first --icons' # tree listing

#available free memory
alias free='free -mt'

#continue download
alias wget='wget -c'

#readable output
alias df='df -h'

#userlist
alias userlist='cut -d: -f1 /etc/passwd'

#Bash aliases
alias mkfile='touch'
alias jctl='journalctl -p 3 -xb'
alias pingme='ping -c64 github.com'
alias cls='clear && neofetch'
alias traceme='traceroute github.com'

#hardware info --short
alias hw='hwinfo --short'

#youtube-dl
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "

#GiT  command
alias gc='git clone '
alias gp='git pull'

#Copy/Remove files/dirs
alias rmd='rm -r'
alias srm='sudo rm'
alias srmd='sudo rm -r'
alias cpd='cp -R'
alias scpd='sudo cp -R'

#nano
alias nz='$EDITOR ~/.zshrc'
alias nbashrc='sudo nano ~/.bashrc'
alias nzshrc='sudo nano ~/.zshrc'
# alias nsddm='sudo nano /etc/sddm.conf'
# alias pconf='sudo nano /etc/pacman.conf'
# alias mkpkg='sudo nano /etc/makepkg.conf'
# alias ngrub='sudo nano /etc/default/grub'
# alias smbconf='sudo nano /etc/samba/smb.conf'
# alias nlightdm='sudo $EDITOR /etc/lightdm/lightdm.conf'
# alias nmirrorlist='sudo nano /etc/pacman.d/mirrorlist'
# alias nsddmk='sudo $EDITOR /etc/sddm.conf.d/kde_settings.conf'

#cd/ aliases
alias home='cd ~'
alias etc='cd /etc/'
alias music='cd ~/Music'
alias vids='cd ~/Videos'
alias conf='cd ~/.config'
alias desk='cd ~/Desktop'
alias pics='cd ~/Pictures'
alias dldz='cd ~/Downloads'
alias docs='cd ~/Documents'
alias sapps='cd /usr/share/applications'
alias lapps='cd ~/.local/share/applications'

#verify signature for isos
alias gpg-check='gpg2 --keyserver-options auto-key-retrieve --verify'

#receive the key of a developer
alias gpg-retrieve='gpg2 --keyserver-options auto-key-retrieve --receive-keys'

#Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

#shutdown or reboot
alias sr='sudo reboot'
alias ssn='sudo shutdown now'

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo ''$1' cannot be extracted via ex()' ;;
    esac
  else
    echo ''$1' is not a valid file'
  fi
}

neofetch --ascii_colors 3 6
