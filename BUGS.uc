1)+  box doesn't check if command has performed which lead us to error and can
       corrupt directories and even damage hard disk drive.
2)   Program was tested on Kali Linux only which may cause it not to work on 
       other distributivies.
3)+  If partition has unwipped signature then script will wait 'till person
       make choise in `init` function. Human interuption is  not good.
4)+  Sctipt doesn't handle user reply if system is not Kali Linux,  but Just 
       gives caution.
5)+  Doesn't wipe label before formating partition.
6)+  If you don't run box command inside its directory then it'll cause error 
       while copying inself: function init() in `#backup of itself`
7)+  If file/dir doesn't exist then script causes error while it does symlink.
8)+  Have to change datalink() structure. Add all symlink files into array.
9)+  Has no prompt which provides information to change username, memory path, 
       device name before `init`
10)  Change structure of `pkg` function to handle both x32 and x64 architecture.
11)+ Correctly upload extented PATH.
12)+ Correctly edit .bashrc file to prevent its content from garbage.
13)  Fix `cleanup` function for deleting garbage files collected during programs
       execution: browser, bashrc, user programs, etc.
14)  Write `unset' function for debuging.
15)+ When first time init disk `box` can't make correct .local and .local/bin,
       .local/shared, etc dir. It conflists with function `datalinks`.
16)+ Write correct and meaningfull README.md
17)  Package backup does not save all files related to package like files
       /etc directory. And does not resolve symbolic files properly.
18)  If close terminal with combination Ctrl+Shift+W then all running daemons
        including `redb` will be terminated.
