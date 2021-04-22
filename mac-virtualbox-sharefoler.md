  267  mount -t vboxsf Public /mnt/pub
  272  mount -t vboxsf -o uid=0,gid=998 Public /mnt/pub
  276  mount -t vboxsf -o uid=0,gid=998 Public /mnt/pub
  278  mount -t vboxsf -o uid=0,gid=998 Public /mnt/Downloads/
  281  mount -t vboxsf -o fmod=777,dmod=777 Public /mnt/Downloads/
  282  mount -t vboxsf -o gid=vboxsf Public /mnt/Downloads/
  294  umount Public
    newgrp
  298  mount -t vboxsf -o gid=988 Public /mnt/pub/
  300  chmod -R g+wrx /mnt/pub
