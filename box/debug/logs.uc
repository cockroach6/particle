    Here I save temprerary logs for debuging and upgrading
code. Don't pay attention if you're regular user.

#>_ comments
# https://www.google.com/webhp?hl=en&gl=us
#-------------------------------------------------------------------




#>_ 24.12.20
mke2fs 1.45.6 (20-Mar-2020)
/dev/sdc3 contains a ext4 file system labelled 'mem'
        last mounted on /media/kali/mem on Sun Dec 20 17:19:07 2020
Proceed anyway? (y,N) yes

    [-] init dir structure
cp: -r not specified; omitting directory './box'
#-------------------------------------------------------------------




#>_ 02.01.21
    [-] init & fill box dir structure
[*] datalinks
    [-] update .bashrc file
    [-] make symlinks
ln: failed to create symbolic link '/home/kali/.config/chromium': File exists
    [-] init github files
warning: unable to access '/home/kali/.gitconfig': Is a directory
warning: unable to access '/home/kali/.gitconfig': Is a directory
fatal: unknown error occurred while reading the configuration files
warning: unable to access '/home/kali/.gitconfig': Is a directory
warning: unable to access '/home/kali/.gitconfig': Is a directory
fatal: unknown error occurred while reading the configuration files
#-------------------------------------------------------------------




#>_ 29.01.21
[*] user's pkgs
    [-] sublime text 3
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
curl: (60) SSL certificate problem: certificate is not yet valid
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
tar: sublime_text_3_build_3211_x32.tar.bz2: Cannot open: No such file or directory
tar: Error is not recoverable: exiting now
mv: cannot stat 'sublime_text_3/*': No such file or directory
app's already installed
#-------------------------------------------------------------------




#>_ 06.02.21
	[i686 GNU/Linux Live]
Filesystem     Type      Size  Used Avail Use% Mounted on
udev           devtmpfs  1.8G     0  1.8G   0% /dev
tmpfs          tmpfs     364M  1.4M  363M   1% /run
/dev/sdc1      iso9660   2.5G  2.5G     0 100% /run/live/medium
/dev/loop0     squashfs  2.2G  2.2G     0 100% /run/live/rootfs/filesystem.squashfs
tmpfs          tmpfs     1.8G   47M  1.8G   3% /run/live/overlay
overlay        overlay   1.8G   47M  1.8G   3% /
tmpfs          tmpfs     1.8G   12M  1.8G   1% /dev/shm
tmpfs          tmpfs     5.0M     0  5.0M   0% /run/lock
tmpfs          tmpfs     1.8G     0  1.8G   0% /sys/fs/cgroup
tmpfs          tmpfs     1.8G   16K  1.8G   1% /tmp
tmpfs          tmpfs     364M   12K  364M   1% /run/user/1000
/dev/sdc3      ext4       12G  3.3G  7.9G  30% /media/kali/box




  [x86_64 GNU/Linux Live]
Filesystem     Type      Size  Used Avail Use% Mounted on
udev           devtmpfs  1.9G     0  1.9G   0% /dev
tmpfs          tmpfs     380M   11M  369M   3% /run
/dev/sdc1      iso9660   3.0G  3.0G     0 100% /run/live/medium
/dev/loop0     squashfs  2.7G  2.7G     0 100% /run/live/rootfs/filesystem.squashfs
tmpfs          tmpfs     1.9G   15M  1.9G   1% /run/live/overlay
overlay        overlay   1.9G   15M  1.9G   1% /
tmpfs          tmpfs     1.9G  216K  1.9G   1% /dev/shm
tmpfs          tmpfs     5.0M     0  5.0M   0% /run/lock
tmpfs          tmpfs     1.9G     0  1.9G   0% /sys/fs/cgroup
tmpfs          tmpfs     1.9G  8.0K  1.9G   1% /tmp
tmpfs          tmpfs     380M   12K  380M   1% /run/user/0
/dev/sdc3      ext4       12G   74M   11G   1% /media/kali/box

[No running user apps]
              total        used        free      shared  buff/cache   available
Mem:          3.7Gi       372Mi       2.3Gi       149Mi       1.0Gi       3.0Gi
Swap:            0B          0B          0B

[Count of running apps: Chrome, sublime, Telegram]
              total        used        free      shared  buff/cache   available
Mem:          3.7Gi       2.0Gi       166Mi       1.2Gi       1.6Gi       285Mi
Swap:            0B          0B          0B


