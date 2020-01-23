FROM centos:7 AS compiler

ARG GCC_VERSION=9.2.0

RUN yum update -y
RUN yum install -y wget gcc gcc-c++ make bison flex gmp-devel libmpc-devel mpfr-devel zlib-devel file

RUN mkdir /gcc && cd /gcc

RUN wget -nv https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
RUN tar -zxvf gcc-${GCC_VERSION}.tar.gz
RUN mkdir gcc-${GCC_VERSION}-build && cd gcc-${GCC_VERSION}-build
RUN ../gcc-${GCC_VERSION}/configure --prefix="/gcc/${GCC_VERSION}-install" --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,fortran --enable-plugin --enable-initfini-array --disable-libgcj --enable-gnu-indirect-function --with-tune=generic --with-arch_32=x86-64 --build=x86_64-pc-linux-gnu --disable-multilib
RUN make -j $(nproc)
RUN make install


FROM centos:7

RUN yum update -y && \
    yum install -y make glibc-headers glibc-devel git epel-release ed rpm-build libmpc mpfr && \
    yum install -y fakeroot alien && \
    yum clean all

COPY --from=compiler /gcc/${GCC_VERSION}-install /usr/local

CMD ["bash"]
