#!/bin/bash
#
# Emergency Self Destruct Data / No Recovery possible
# Best to run from /root or /tmp
#
read -p "EMERGENCY SELF DESTRUCT ALL DATA? (Y/n) " RESP
if [ "$RESP" = "Y" ]; then
  echo "Starting zero write. Stand-By."
  for dev in /dev/sd*; do
    nohup dd if=/dev/zero of=$dev bs=4k &
  done
  echo "Executing Secondary SSD Secure Erase. Stand-By."
  for dev in /dev/sd*; do
    if [[ $(hdparm -I $dev 2>/dev/null) == *"Solid State"* ]]; then
      hdparm --user-master u --security-set-pass PasSWorD $dev
      hdparm --user-master u --security-erase-enhanced PasSWorD $dev
    fi
  done
  echo "Removing Home and Cleanup"
  rm -rf /home/*
  rm -rf /root/*
  echo "fstrim SSD free space"
  fstrim --fstab --verbose
  swapoff -a
  echo "All Data has been wiped. It is not possible to recover. Have a nice day."
  poweroff
else
  echo "No action taken. Exiting"
fi
