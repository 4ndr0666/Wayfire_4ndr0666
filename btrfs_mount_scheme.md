## BTRFS Remounting

**Mount Order**

```bash
 sudo mount -o defaults,subvol=@ /dev/sdc3 /mnt/garuda/
 sudo mount -o defaults,subvol=@root /dev/sdc3 /mnt/garuda/@/root
 sudo mount -o defaults,subvol=@cache /dev/sdc3 /mnt/garuda/@/var/cache
 sudo mount -o defaults,subvol=@tmp /dev/sdc3 /mnt/garuda/@/var/tmp
 sudo mount -o defaults,subvol=@log /dev/sdc3 /mnt/garuda/@/var/log
 sudo mount -o defaults,subvol=@srv /dev/sdc3 /mnt/garuda/@/srv
 sudo mount /dev/sdc1 /boot/efi
```
