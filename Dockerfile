FROM ubuntu:latest

MAINTAINER The HDF-EOS Tools and Information Center <eoshelp@hdfgroup.org>

ENV HOME /root

COPY ["./apt.txt", "./"]

RUN apt update && apt install -yq $(grep -vE "^\s*#" ./apt.txt)

# Build HDF5 library.
RUN git clone https://github.com/live-clones/hdf5; \
    cd hdf5; \
    ./configure --prefix=/usr/local/; \
    make && make check && make install; \
    cd ..;
    
# Build h5py.    
RUN git clone https://github.com/h5py/h5py.git; \
    cd h5py; \
    export HDF5_DIR=/usr/local/; \
    python setup.py build; \
    python setup.py install 