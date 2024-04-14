# ext4.vhdx is too large

The windows utility `diskpart` can now be used to shrink Virtual Hard Disk (vhdx) files provided you freed up the space inside it by deleting any unnecessary files. I found the info in [this guide](https://stephenreescarter.net/how-to-shrink-a-wsl2-virtual-disk/).

I am putting the gist of the instructions below for reference but the guide above is more complete.

First make sure all WSL instances are shut down by opening an administrator command window, and typing:

```
>> wsl --shutdown 
```

Verify everything is stopped by:

```
>> wsl.exe --list --verbose
```

Then start diskpart:

```
>> diskpart
```

and inside diskpart type:

```
DISKPART> select vdisk file="<path to vhdx file>"
```

For example:

```
DISKPART> select vdisk file="C:\Users\user\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu22.04LTS_12rqwer1sdgsda\LocalState\ext4.vhdx"
```

it should respond by saying `DiskPart successfully selected the virtual disk file.`

Then to shrink

```
DISKPART> compact vdisk
```

After this the vhdx file should shrink in usage. In my case it went from 40GB to 4GB. You can type `exit` to quit diskpart.



Reference: https://stackoverflow.com/questions/70946140/docker-desktop-wsl-ext4-vhdx-too-large