# lxcManager

## Quick Installation

Clone the repository.
```
git clone https://github.com/tbleiker/lxc-manager.git
```

Change to the lxc-manager direcotry.
```
cd lxc-manager
```

Create Softlinks.
```
for i in *.sh; do ln -s $(pwd)/$i /usr/local/bin/${i%.*}; done
```
