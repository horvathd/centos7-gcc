ARG GCC_VERSION=11.1.0

FROM centos:7 AS compiler

ARG GCC_VERSION

RUN yum update -y
RUN yum install -y wget gcc gcc-c++ make bison flex gmp-devel libmpc-devel mpfr-devel zlib-devel file

WORKDIR /gcc

RUN wget -nv https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz
RUN tar -zxf gcc-${GCC_VERSION}.tar.gz

WORKDIR /gcc/gcc-${GCC_VERSION}-build

RUN ../gcc-${GCC_VERSION}/configure --prefix="/gcc/gcc-${GCC_VERSION}-install" --enable-bootstrap --enable-languages=c,c++,fortran,lto --enable-shared --enable-threads=posix --enable-checking=release --disable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --enable-plugin --enable-default-pie --with-linker-hash-style=gnu --enable-initfini-array --enable-libmpx --enable-gnu-indirect-function --with-tune=generic --build=x86_64-pc-linux-gnu
RUN make -j $(nproc)
RUN make install


FROM centos:7

ARG GCC_VERSION

RUN yum update -y && \
    yum install -y epel-release http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm && \
    yum install -y make glibc-headers glibc-devel git ed rpm-build libmpc mpfr fakeroot alien && \
    yum clean all

COPY --from=compiler /gcc/gcc-${GCC_VERSION}-install /usr/

CMD ["bash"]
