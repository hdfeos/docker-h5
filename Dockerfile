FROM ubuntu:latest

MAINTAINER The HDF-EOS Tools and Information Center <eoshelp@hdfgroup.org>

ENV HOME /root

COPY ["./apt.txt", "./"]

RUN apt update && apt install -yq $(grep -vE "^\s*#" ./apt.txt)

# Build HDF5 lib.
ARG HDF5_VER=5-1.8.19
RUN git clone https://github.com/live-clones/hdf5
    cd hdf; \
    ./configure --prefix=/usr/local/; \
    make && make check && make install; \
    cd ..;


