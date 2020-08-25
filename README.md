# Kali 2020.02 Upgrade Script for setoolkit #

In my work at the [VirginiaCyberRange](https://virginiacyberrange.org) I get to see a lot of weird stuff in our cloud based, security training system.. including problems our customers (cyber security instructors) run into doing pentesting classes and the like. One of the recent issues was this SET (social engineering toolkit) breaking in the new 2020 rolling [Kali Linux](https://www.kali.org/) security distro. It seems to be a fairly [well known issue](https://github.com/trustedsec/social-engineer-toolkit/issues/772) that no one has fixed in months (in the distro repos), even though it seems [the new version of SET](https://github.com/trustedsec/social-engineer-toolkit/) has already addressesd  this.

So this root shell script (for beginners nor familiar with python, pip, git, etc) carefully checks your Kali Linux install version (so "lbs_release -r" should = 2020.02), prepares your system, pulls down the latest github version of setoolkit, sets up the needed python requirements, and does the pip3 install.  You'll know it worked if it ends in [OK], and once it is fixed the new setoolkit path, as returned bby "which setoolkit", will be /usr/local/bin/setoolkit (where the original broken program is at /usr/bin/setoolkit ).   

## The Nature of The Problem ##

Several of the older underlying setoolkit libraries in Kali Linux 2020 rely on python 2.7, and break in the latest Kali rolling upgrade, as Kali and the underlying Debian have both moved up to Python 3.x. This can error be replicated by running any of the credential harvesting tools in setoolkit such as the google credential harvester (selecting 1,2,3,1,enter,2 from the SET menus). Once a web client hits and executes the harvesting attack, you clearly see setoolkit crash with multiple python errors:

![Alt Crashing google credential harvester](https://user-images.githubusercontent.com/1731305/90028387-9e22d500-dc87-11ea-81f8-55f278f85528.png "Crashing google credential harvester")

This Kali issue has [been submitted here](https://bugs.kali.org/view.php?id=6681).

## Manually Doing the Upgade ##

I felt the need to write an installer, as many of the more inexperienced Linux users (e.g. high school students) and even teachers on the Cyber Range, are not super familiar with python, much less pip and git.  

Before running the script, verify you have the old broken version of setoolkit. It will have the following path:
```
$ which setoolkit
/usr/local/bin/setoolkit
```

The commands below installs the new setoolkit to /use/share, and so need to be run as root (recommend via sudo su -).  Download it to your kali 2020 system after becoming root:
```
$ sudo su -
# curl -L0 https://github.com/Tweeks-va/kali-2020-upgrade-setoolkit/archive/master.tar.gz |  gunzip - | tar -x --strip-components=1
```
However, as a security professional, NEVER trust anyone's root script on your system without looking it over first!!  Go ahead and inspect it with your favorite editor (shameless vim plug).. pick apart what it's doing, and only then once you understand what's doing, finally run it as root:
```
# ./upgrade-setoolkit.sh
```

After you do the install, the new path (that overrides the old /usr/bin path) should look like this:
```
# which setoolkit
/usr/local/bin/setoolkit
```
and setookit will not longer crash do to the above mentioned python issues.

## Toubleshooting ##

If any of the error checking if statements cause you problems (such as the lsb_release checking for Kali 2020.02), feel free to disable them at your own risk. This fix has not been tested on any distro/version other than Kali 2020.02.

