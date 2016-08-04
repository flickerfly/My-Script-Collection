# Various Scripts by Josiah
This is a compilation of various scripts that I can share. I provide no warranty of them working, but I hope you can find something that will save you time in your own efforts. I'm releasing it using the MIT License to allow you to do just about anything you want with it. LICENSE.txt for more info.

## csvmaker.sh:
This is a simple script to take in a list of files from the command line and pump it into a csv file.

## id3Chapel.sh:
This was created for a project that was converting bible college chapels on tape masters to mp3 format. This script would take the name that was output in a certain format and create id3 tags from that information. (I worked a bit on porting this to ruby in id3Chapel.rb but didn't get far.)

## users.dhcp.sh:
I created this to make a report based on the dhcp leases in order to more easily grasp the information I needed to review.

## dhcp.awk:
This is used in users.dhcp.sh for processing dhcp leases. It is assumed to be in ~/scripts/bin. If you place it elsewhere, you'll need to edit users.dhcp.sh.

## house_use_bkgnd.sh:
This script grabs charts made is google spreadsheets and builds a background from them. I use this to keep my utility usage and other info in front of me. I apply the background to the machine that is connected to the TV for hulu and other media watching. A cron job can be used to make sure the data is constantly up-to-date. Copy the charts.cfg_example to charts.cfg and set those variables to make this work. This means building some charts in Google spreadsheets and then finding the image publishing URL.

## linux_audit.sh
This is a little script I tossed together to audit a series of virtual LAMP servers I was building for a client, allowing me to easily compare their requirements with my results when I was done and report those results to them for their own purposes. Things like the number of processors, hard drive space, RAM, certain software versions can be quickly seen in the output. I ran it with this little one-liner './linux_audit.sh > `hostname`.audit.txt'. One advantage of this is that errors from running commands where the software doesn't exist simply resulted in no output in the reported document rather than showing a error so it was a bit cleaner.

## getip.sh & getipv6.sh
Simple scripts that returns the IP or IPv6 address of a linux box and nothing but. This can be pretty handy since Linux doesn't provide this info on its own without adding lots of other info.

## vncserver_rc 
This is a startup script for tightvncserver on ubuntu capable of handling multiple users. It requires a properly configured /etc/vncservers.conf and each user needs a .vnc/passwd and .vnc/xstartup for their service to startup properly. Manually run 'tightvncserver :1' for each user to do this and then 'tightvncserver -kill :1" to shut the server off. I don't yet have the status stuff working well, but start and stop function just fine. A sample vncservers.conf can also be found in this repo.

## getswap.sh
Reports the swap space usage by Process on a linux box

## rcl.service
This is a systemd startup script / unit script / service script or whatever systemd calls it for the Retrospect backup client. When systemd 231 comes around to be used in a Ubuntu LTS or whatever distro you are using, consider adding 'ExecStatus=/usr/local/retrospect/client/retrocpl' to include the extra status info that older systemd doesn't gather. Ubuntu LTS 16.04 is currently using systemd 291 (so close).

## list-all-cron-jobs.sh
For that time when your developers can't answer what cron job is running at what time, perhaps a bunch of them are out of reach, and one of their jobs is potentially changing a bunch of permissions inappropriately or otherwise wreaking havoc on a regular basis upon your system. Track 'em down! (Thanks to yukondude for posting a bunch of this on http://stackoverflow.com/a/137173/264881. 
