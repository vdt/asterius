#!/usr/bin/sh -e

export GHC_BRANCH=asterius

pacman -S --needed --noconfirm --noprogressbar \
    autoconf \
    automake \
    bsdtar \
    git \
    make \
    mingw-w64-x86_64-binutils \
    mingw-w64-x86_64-ca-certificates \
    mingw-w64-x86_64-curl \
    mingw-w64-x86_64-gcc \
    mingw-w64-x86_64-libtool \
    mingw-w64-x86_64-python2 \
    mingw-w64-x86_64-tools-git \
    mingw-w64-x86_64-xz \
    patch \
    p7zip \
    tar

stack --no-terminal --resolver nightly --skip-msys setup > /dev/null
stack --no-terminal --skip-msys install \
    alex \
    happy \
    hscolour
export PATH=$APPDATA/local/bin:$(stack path --compiler-bin --skip-msys):$PATH

git config --global url."https://github.com/ghc/packages-".insteadOf https://github.com/TerrorJack/packages/
git config --global url."https://github.com/ghc/haddock.git".insteadOf https://github.com/TerrorJack/haddock.git
git config --global url."https://github.com/ghc/nofib.git".insteadOf https://github.com/TerrorJack/nofib.git
git config --global url."https://github.com/ghc/hsc2hs.git".insteadOf https://github.com/TerrorJack/hsc2hs.git
git config --global url."https://github.com/ghc/libffi-tarballs.git".insteadOf https://github.com/TerrorJack/libffi-tarballs.git
git config --global url."https://github.com/ghc/gmp-tarballs.git".insteadOf https://github.com/TerrorJack/gmp-tarballs.git
git config --global url."https://github.com/ghc/arcanist-external-json-linter.git".insteadOf https://github.com/TerrorJack/arcanist-external-json-linter.git
git config --global url."https://github.com/ghc/hadrian.git".insteadOf https://github.com/TerrorJack/hadrian.git
git clone https://github.com/TerrorJack/ghc.git
cd ghc
git checkout $GHC_BRANCH
git submodule update --init --recursive

mv ../.appveyor/build.mk mk/
./boot
./configure --enable-tarballs-autodownload
make -j5
XZ_OPT=-0 make binary-dist

mkdir ghc-bindist
mv *.tar.xz ghc-bindist/
sha256sum -b ghc-bindist/* > ghc-bindist/sha256.txt
