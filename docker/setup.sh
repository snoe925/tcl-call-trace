apt-get update -qq

apt-get install -y git gcc-8 g++-8 make curl automake autoconf \
    minizip vim libreadline-dev libtool cmake \
    pkg-config gdb binutils-dev libiberty-dev

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-8
update-alternatives --set cc /usr/bin/gcc-8
update-alternatives --set c++ /usr/bin/g++-8

dpkg-query -l 2>&1 | sed "s,^,package-selections: ,"
