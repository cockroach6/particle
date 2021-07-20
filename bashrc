#!/bin/sh


### ALIASES

alias ls="ls --color"
alias ll="ls --color -lh"
alias la="ls --color -a"
alias pacs="pacsearch"
alias vim="vim -y"
alias nano="nano -w"





### NICE COLOR BASH PROMPT

function bash_prompt

{
local WHITE="[33[1;37m]"
local default="[33[0;39m]"
local BRIGHTGREEN="[33[1;32m]"
local GREEN="[33[0;32m]"
local CYAN="[33[0;36m]"
local GRAY="[33[0;37m]"
local RED="[33[0;31m]"

if [ `id -u` != "0" ]; then
   PS1="${GREEN}u${CYAN}@${GREEN}h ${CYAN}w${WHITE} ${default}$ "
else
   PS1="${RED}u${CYAN}@${GREEN}h ${CYAN}w${WHITE} ${default}$ "
fi
}

bash_prompt





### COLORIZE PACMAN (PACS)

pacsearch () {
       echo -e "$(pacman -Ss $@ | sed 
       -e 's#current/.*#\033[1;31m&\033[0;37m#g' 
       -e 's#extra/.*#\033[0;32m&\033[0;37m#g' 
       -e 's#community/.*#\033[1;35m&\033[0;37m#g' 
       -e 's#^.*/.* [0-9].*#\033[0;36m&\033[0;37m#g' )"
}
This is really pretty basic.  I use the same ~/.bashrc for all users, including root...

The alias section is pretty self explanatory, basically the parts in quotations (" ") get run instead of the commands before the equals (=) in every case.

The bash prompt section is a bit nifty.  The first part, with color definitions, is so that I don't go mad trying to write the actual PS1 line.  Makes it cleaner in my opinion.  There's lots of documentation out there if you're interested in modifying the prompt I have.

The if/then/else statement in the bash prompt section checks if the user is root.  If not, the username is displayed in GREEN at the prompt.  If the user is root, the username is displayed in RED.  A nice visual reminder, and since I use my ~/.bashrc for ALL users, including root, it helps make the file more portable.

The last section is taken straight from the Arch wiki.  At the top I aliased 'pacs', which calls this section.  Basically 'pacs' can take the place of 'pacman -Ss' and offer simple colour output.

http://wiki.archlinux.org/index.php/Col … man_output

Additions, other bash tips & tricks, comments, all welcome

2006-05-18 03:29:15
phrakture
h
