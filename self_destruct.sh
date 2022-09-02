#!/bin/bash
#
# Emergency Self Destruct Data / No Recovery possible
# Best to run from /root or /tmp
#
read -p "EMERGENCY SELF DESTRUCT ALL DATA? (Y/n) " RESP
if [ "$RESP" = "Y" ]; then
  echo "Starting zero write. Stand-By."
  # for i in {b..e}; do nohup dd if=/dev/zero of=/dev/sd$i bs=4k &; done
  nohup dd if=/dev/zero of=/dev/sdb bs=4k &;
  nohup dd if=/dev/zero of=/dev/sdd bs=4k &;
  nohup dd if=/dev/zero of=/dev/sde bs=4k &;
  echo "Executing Secondary SSD Secure Erase. Stand-By."
  hdparm --user-master u --security-set-pass PasSWorD /dev/sdc
  hdparm --user-master u --security-erase-enhanced PasSWorD /dev/sdc
  echo "Removing Home"
  rm -rf /home/*
  echo "fstrim SSD free space"
  fstrim --fstab --verbose
  echo "All Data has been wiped. It is not possible to recover. Have a nice day."
  poweroff
else
  echo "No action taken. Exiting"
fi
