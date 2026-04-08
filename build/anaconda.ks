# Barbarous Core: Anaconda Kickstart for Automated Installation
# This file automates the install to skip manual steps and avoid freezes.

# 1. System Language & Keyboard
lang en_US.UTF-8
keyboard us

# 2. Timezone & Clock
timezone UTC --utc

# 3. User & Root Configuration (Barbarous user with sudo)
user --name=barbarous --groups=wheel --password=$6$s/nMrRp1SpMNsTSt$UqoutdmAD/ycT27.4KUgjVcwRCXhhoUGkhac5JY5tsW1qENwP0.nUDt3cFHbB6VT961GlecHX1QytlqcYm6Y4/ --iscrypted
rootpw --lock

# 4. Networking
network --bootproto=dhcp --device=link --activate

# 5. Disk Partitioning (Automated: Use entire disk)
zerombr
clearpart --all --initlabel
autopart --type=plain --fstype=xfs

# 6. Reboot after installation
reboot
