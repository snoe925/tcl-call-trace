FROM debian:buster-slim

COPY setup.sh /root/setup.sh

RUN bash /root/setup.sh

COPY patches /root/patches

RUN cd /root && \
    git clone https://github.com/tcltk/tcl.git && \
    cd tcl && \
    git checkout -b core-8-6-9

RUN cd /root/tcl/unix && \
    cp /root/patches/unix/* . && \
    cp /root/patches/generic/* ../generic && \
    /usr/bin/env CFLAGS="-finstrument-functions -no-pie" LDFLAGS=-lbfd ./configure --disable-shared --enable-symbols && \
    make tclsh

#CMD ["sleep", "366d"]

CMD ["/bin/bash"]
