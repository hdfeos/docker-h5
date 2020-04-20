FROM ubuntu:latest

MAINTAINER The HDF-EOS Tools and Information Center <eoshelp@hdfgroup.org>

ENV HOME /root

COPY ["./apt.txt", "./"]

RUN apt update && apt install -yq $(grep -vE "^\s*#" ./apt.txt)

# Build the latest HDF5 library.
# RUN git clone https://github.com/live-clones/hdf5; \
#     cd hdf5; \
#     ./autogen.sh; \
#     ./configure --prefix=/usr/local/; \
#     make && make check && make install; \
#     cd ..;

# Build the release.
RUN wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz; \
    tar zxvf hdf5-1.12.0.tar.gz; \
    cd hdf5-1.12.0; \
    ./configure --prefix=/usr/local/; \
    make && make check && make install; \
    cd ..; \
    rm -rf /hdf${HDF5_VER}/hdf${HDF5_VER}.tar.gz


# Build h5py.    
RUN git clone https://github.com/h5py/h5py.git; \
    cd h5py; \
    export HDF5_DIR=/usr/local/; \
    python setup.py build; \
    python setup.py install 