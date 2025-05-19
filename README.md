# How to install

Two different install procedure depending on your system:

## On a Linux system with docker (Ubuntu, Debian, NixOS)

Follow the GNS3 [install procedure for
Linux](https://docs.gns3.com/docs/getting-started/installation/linux/), then:

1. Start GNS3
2. Clone (or unzip) this repo (folder)
3. Run `./install.sh`

If necessary run `./install.sh --pull` to enforce downloading everything.


## On a system without docker (Windows, Mac ...)

In this case, you need to follow the install GNS3
[with the GNS3 Virtual Machine](https://docs.gns3.com/docs/getting-started/installation/download-gns3-vm/)
by downloading the [official VM image](https://www.gns3.com/software/download-vm).

Once the VM is setup with GNS3, connect to it by SSH (`ssh gns3@$IP_OF_VM` with
password `gns3`) then run the `install.sh` script.


## The one liner command

```git clone https://net2-2025:FrVHiU2qspikoqzRtsJ_@gitlab.cri.epita.fr/daniel.stan/net2-appliances.git n2a; cd n2a; ./install.sh```
