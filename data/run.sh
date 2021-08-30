CWD="$(pwd)"

sudo apt-get update
sudo apt-get -y install build-essential gcc-multilib lzip git python3-pip cmake
mkdir -p ~/opt/src
cd ~/opt/src
# install deps

git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
cd ..
# install emscripten

curl https://gmplib.org/download/gmp/gmp-6.2.1.tar.lz --output gmp-6.2.1.tar.lz
lzip -d gmp-6.2.1.tar.lz
tar xf gmp-6.2.1.tar
cd gmp-6.2.1
emconfigure ./configure --disable-assembly --host none --enable-cxx --prefix=${HOME}/opt
make
make install
cd ..
# install wasm gmp with emsripten

source $CWD/mk-openssl-webassembly.sh
# install wasm openssl with emscripten

git clone https://github.com/jedisct1/libsodium.git
cd libsodium
git checkout 95673e
emconfigure ./configure --prefix=${HOME}/opt
make
make install
cd ..
# install wasm libsodium with emscripten

git clone --recurse-submodules -j8 https://github.com/AHaliq/libff.git
cd libff
mkdir build
cd build
emcmake cmake .. -DGMP_LIBRARY=~/opt/lib/libgmp.a -DGMP_INCLUDE_DIR=~/opt/src/gmp-6.2.1 -DOPENSSL_CRYPTO_LIBRARY=~/opt/lib/libcrypto.a -DOPENSSL_INCLUDE_DIR=~/opt/src/openssl-1.1.1d/include -DOPENSSL_SSL_LIBRARY=~/opt/lib/libssl.a -DSODIUM_LIBRARY=~/opt/lib/libsodium.a -DSODIUM_INCLUDE_DIR=~/opt/src/libsodium/src/libsodium/include
# compile libff with emscripten