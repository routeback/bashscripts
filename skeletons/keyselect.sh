#!/bin/bash

PS3="Your choice: "

select FILENAME in *.pem;
do
  case $FILENAME in
        "$QUIT")
          echo "Exiting."
          break
          ;;
        *)
          echo "You picked $FILENAME ($REPLY)"
          key="$FILENAME"
	  echo "[*] Key set. Key = $key"
	  break
          ;;
  esac
done
