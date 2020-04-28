FROM ubuntu:latest

MAINTAINER The HDF-EOS Tools and Information Center <eoshelp@hdfgroup.org>

ENV HOME /root

COPY ["./apt.txt", "./"]

RUN apt update && apt install -yq $(grep -vE "^\s*#" ./apt.txt)


# Build the release.
# RUN wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz; \
#     tar zxvf hdf5-1.12.0.tar.gz; \
#     cd hdf5-1.12.0; \
#     ./configure --prefix=/usr/local/; \
#     make && make check && make install; \
#     cd ..; \
#     rm -rf /hdf${HDF5_VER}/hdf${HDF5_VER}.tar.gz

# Build the latest HDF5 library.
RUN git clone https://github.com/live-clones/hdf5; \
    cd hdf5; \
    export HDF5_LIBTOOL=/usr/bin/libtoolize && ./autogen.sh; \
    ./configure --prefix=/usr/local/; \
    make && make check && make install; \
    cd ..;
    
# Set shared library location for h5 library.
ENV LD_LIBRARY_PATH /usr/local/lib

# Build Cython
# git clone https://github.com/cython/cython

# Build h5py. It doesn't work.
# RUN pip3 install numpy; \
#     git clone https://github.com/h5py/h5py.git; \
#     cd h5py; \
#     export HDF5_DIR=/usr/local/; \
#     python setup.py build; \
#     python setup.py install

# set noninteractive installation
export DEBIAN_FRONTEND=noninteractive
#install tzdata package
apt-get install -y tzdata
# set your timezone
ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

# Install h5py using pip3 until h5py is fixed.
RUN pip3 install h5py;

