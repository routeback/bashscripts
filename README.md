# Bash scripts
This repository is a collection of bashscripts that [@routeback] has developed or is in the process of developing. These have been tested on Kali linux and Mac OSX with terminator and iTerm, respectively. Most of these scripts are meant to be added to the local $PATH for convenience. Refer to references/references.bashrc for examples.

Other scripts, such as sslchecks.sh and ikeee.sh are meant to act as a wrapper for other tools to automate validating common vulnerabilities.

For instance, sslchecks.sh provides a quick TUI for capturing evidence of multiple SSL vulnerabilities and outputting the results to a file.

### Installation
Simply clone the repository, open the directory and run the scripts from a bash shell.

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

### Todos
Complete development folder scripts.
Complete sslchecks.sh

### Version
0.1 - Initial Upload 20151216
0.2 - Cleanup and re-organization 20160226

License
----
MIT

<!---
[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. 

http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

-->


   [git-repo-url]: <https://github.com/routeback/bashscripts.git>

   [@routeback]: <http://twitter.com/routeback>
