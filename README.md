# Bash scripts
This repository is a collection of GNU/Linux bash scripts.  These have been tested on Ubuntu, Debian and Kali, as well as Mac OSX 10 using iTerm. Most of these scripts are meant to be added to the local $PATH for convenience. Refer to references/references.bashrc or below under 'Usage' for examples.

Other scripts, such as sslchecks.sh and ikeee.sh are meant to act as a wrapper for other scripts or tools in order to further automate the process of validating vulnerabilities. Specifically, sslchecks.sh provides a quick TUI for capturing evidence of multiple SSL vulnerabilities and outputting the results to a file. ikeee.sh can be used to capture IKE aggressive mode Pre-Shared Keys (PSK) for offline cracking.

For all other scripts, refer to the comments at the beginning to determine their purpose.

### Usage
Git clone or download the repository, cd to the directory and run the scripts from a bash shell.

The following scripts are meant to be executed with the source command: append.sh, ps1.sh. 

Example:

```sh
$ source append.sh
$ source ps1.sh
```

Specify the path to the scripts for a more convenient usage:
```sh
$ git clone https://github.com/routeback/bashscripts.git
$ cd bashscripts; echo "export PATH=`pwd`:$PATH" >> ~/.bashrc; source ~/.bashrc
```

### Version
0.1 - Initial Upload 20151216
0.2 - Cleanup and re-organization 20160226
0.3 - Additional scripts added 20170430

License
----
MIT

<!---
[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. 

http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

-->


   [git-repo-url]: <https://github.com/routeback/bashscripts.git>

   [@routeback]: <http://twitter.com/routeback>
