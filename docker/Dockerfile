FROM debian:buster-slim

COPY setup.sh /root/setup.sh

RUN bash /root/setup.sh

RUN cd /root && \
    git clone https://github.com/tcltk/tcl.git

RUN cd /root/tcl && \
    git checkout core-8-6-9

COPY patches /root/patches

RUN cd /root/tcl/unix && \
    cp /root/patches/unix/* . && \
    cp /root/patches/generic/* ../generic && \
    /usr/bin/env CFLAGS="-DTCL_COMPILE_DEBUG -finstrument-functions -no-pie" LDFLAGS=-lbfd ./configure --disable-shared --enable-symbols && \
    make tclsh

CMD ["sleep", "366d"]
