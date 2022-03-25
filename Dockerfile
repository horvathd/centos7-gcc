FROM centos:7 AS compiler

RUN yum update -y
RUN yum install -y wget gcc gcc-c++ make bison flex gmp-devel libmpc-devel mpfr-devel zlib-devel file

WORKDIR /gcc

ARG GCC_VERSION=12-20220320

RUN wget -nv https://gcc.gnu.org/pub/gcc/snapshots/${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz
RUN tar -Jxf gcc-${GCC_VERSION}.tar.xz

WORKDIR /gcc/gcc-build

RUN ../gcc-${GCC_VERSION}/configure --prefix="/gcc/gcc-install" --enable-bootstrap --enable-languages=c,c++,fortran,lto --enable-shared --enable-threads=posix --enable-checking=release --disable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --enable-plugin --enable-default-pie --with-linker-hash-style=gnu --enable-initfini-array --enable-libmpx --enable-gnu-indirect-function --with-tune=generic --build=x86_64-pc-linux-gnu
RUN make -j $(nproc)
RUN make install-strip


FROM quay.io/horvathd/sphinx-builder:latest

RUN yum install -y epel-release http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm && \
    yum install -y make glibc-headers glibc-devel git ed rpm-build libmpc mpfr fakeroot alien && \
    yum clean all

COPY --from=compiler /gcc/gcc-install /usr/

CMD ["bash"]
