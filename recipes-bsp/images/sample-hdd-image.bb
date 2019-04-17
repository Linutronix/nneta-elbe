inherit elbeimage

LICENSE = "MIT"

PN = "sample-hdd-image"

IMAGE_FSTYPES += "tar.gz cpio hdddirect"

ELBE_HDD_NAME = "sda.img"
ELBE_HDD_SIZE = "2GiB"
ELBE_HDD_GRUB_INSTALL = "true"
ELBE_HDD_PARTITIONS = "		\
	1MiB,bios,biosgrub	\
	100MiB,uefi,bootable	\
	remain,rfs,		\
"

IMAGE_INSTALL += "		\
	bash			\
	grub-efi-amd64-bin	\
	grub-pc			\
	vim-nox			\
"
