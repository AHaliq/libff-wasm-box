CWD="$(pwd)"

sudo apt-get update
sudo apt-get -y install build-essential gcc-multilib lzip git python3-pip cmake pkg-config
mkdir -p ${HOME}/opt/src
cd ${HOME}/opt/src
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

#git clone --recurse-submodules -j8 https://github.com/AHaliq/libff.git
#cd libff
#mkdir build
#cd build
#emcmake cmake .. -DGMP_LIBRARY=${HOME}/opt/lib/libgmp.a -DGMP_INCLUDE_DIR=${HOME}/opt/src/gmp-6.2.1 -DOPENSSL_CRYPTO_LIBRARY=${HOME}/opt/lib/libcrypto.a -DOPENSSL_INCLUDE_DIR=${HOME}/opt/src/openssl-1.1.1d/include -DOPENSSL_SSL_LIBRARY=${HOME}/opt/lib/libssl.a -DSODIUM_LIBRARY=${HOME}/opt/lib/libsodium.a -DSODIUM_INCLUDE_DIR=${HOME}/opt/src/libsodium/src/libsodium/include
#make
#cp libff/libff.a ${HOME}/opt/lib/
#cd ..
#cd ..
# compile libff with emscripten

curl -L -O "https://boostorg.jfrog.io/artifactory/main/release/1.64.0/source/boost_1_64_0.tar.gz"
tar -xzvf boost_1_64_0.tar.gz
rm *.tar.gz
cd boost_1_64_0
./bootstrap.sh
./b2 toolset=emscripten link=static runtime-link=static --with-system --with-thread
cd ../
# install wasm boost with emscripten

git clone --recurse-submodules -j8 https://github.com/AHaliq/cryptoutils.git
cd cryptoutils
mkdir build
cd build
emcmake cmake .. -DCMAKE_INSTALL_PREFIX=${HOME}/opt -DGMP_LIBRARY=${HOME}/opt/lib/libgmp.a -DGMP_INCLUDE_DIR=${HOME}/opt/src/gmp-6.2.1 -DOPENSSL_CRYPTO_LIBRARY=${HOME}/opt/lib/libcrypto.a -DOPENSSL_INCLUDE_DIR=${HOME}/opt/src/openssl-1.1.1d/include -DOPENSSL_SSL_LIBRARY=${HOME}/opt/lib/libssl.a -DSODIUM_LIBRARY=${HOME}/opt/lib/libsodium.a -DSODIUM_INCLUDE_DIR=${HOME}/opt/src/libsodium/src/libsodium/include -DBoost_INCLUDE_DIR=${HOME}/opt/src/boost_1_64_0 -DBOOST_ROOT=${HOME}/opt/src/boost_1_64_0 -DBoost_SYSTEM_LIBRARY=${HOME}/opt/src/boost_1_64_0/stage/lib/libboost_system.bc
make install
cd ../../

echo "!!! SUCCESS !!!"