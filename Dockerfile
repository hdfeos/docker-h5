FROM python:3.8-slim-buster

MAINTAINER The HDF-EOS Tools and Information Center <eoshelp@hdfgroup.org>

ENV HOME /root

COPY ["./apt.txt", "./"]

RUN apt update && apt install -yq $(grep -vE "^\s*#" ./apt.txt)


# Build the latest HDF5 library.
RUN git clone https://github.com/HDFGroup/hdf5; \
    cd hdf5; \
    export HDF5_LIBTOOL=/usr/bin/libtoolize && ./autogen.sh; \
    ./configure --prefix=/usr/local/ --enable-ros3-vfd; \
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


# Install h5py using pip3 until h5py is fixed.
RUN pip3 install h5py;

# Install profile analysis tool.
RUN pip3 install gprof2dot;

# Install markdown to rst tool.
RUN pip3 install m2r;


