sudo apt-get update && \
sudo apt-get install flex bison build-essential && \

printf "\n\nSet Variabili\n\n" && \
MLVPN_VERSION=2.3.5 && \
EV_VERSION=4.22 && \
LIBSODIUM_VERSION=1.0.8 && \
PCAP_VERSION=1.7.4 && \
cd && \
if [ -d "File_Temp_Mlvpn" ]; then rm -R File_Temp_Mlvpn ; fi  && \
mkdir File_Temp_Mlvpn && \

printf "\n\nScarico 4 Paccehtti\n\n" && \
cd  && \
wget http://dist.schmorp.de/libev/Attic/libev-${EV_VERSION}.tar.gz && \
wget https://github.com/jedisct1/libsodium/releases/download/1.0.8/libsodium-${LIBSODIUM_VERSION}.tar.gz && \
wget http://www.tcpdump.org/release/libpcap-${PCAP_VERSION}.tar.gz && \
wget https://github.com/zehome/MLVPN/releases/download/${MLVPN_VERSION}/mlvpn-${MLVPN_VERSION}.tar.gz && \
 

printf "\n\nEstraggo 4 Pacchetti\n\n" && \
cd && \
tar xzf libev-${EV_VERSION}.tar.gz && cp libev-${EV_VERSION}.tar.gz ~/File_Temp_Mlvpn && rm libev-${EV_VERSION}.tar.gz && \
tar xzf libsodium-${LIBSODIUM_VERSION}.tar.gz && cp libsodium-${LIBSODIUM_VERSION}.tar.gz ~/File_Temp_Mlvpn && rm libsodium-${LIBSODIUM_VERSION}.tar.gz && \
tar xzf libpcap-${PCAP_VERSION}.tar.gz && cp libpcap-${PCAP_VERSION}.tar.gz ~/File_Temp_Mlvpn && rm libpcap-${PCAP_VERSION}.tar.gz && \
tar xzf mlvpn-${MLVPN_VERSION}.tar.gz && cp mlvpn-${MLVPN_VERSION}.tar.gz ~/File_Temp_Mlvpn && rm mlvpn-${MLVPN_VERSION}.tar.gz && \
 
printf "\n\nInstallo libev\n\n" && \
cd && \
cd libev-${EV_VERSION} && ./configure --enable-static --disable-shared --prefix $HOME/libev/ && sudo make -j4 install && \

printf "\n\nInstallo libsodium\n\n" && \
cd && \
cd libsodium-${LIBSODIUM_VERSION} && ./configure --enable-static --disable-shared --prefix=$HOME/libsodium/ && sudo make -j4 install && \

printf "\n\nInstallo libpcap\n\n" && \
cd && \
cd libpcap-${PCAP_VERSION} && ./configure --disable-shared --prefix $HOME/libpcap/ && sudo make -j4 install && \

printf "\n\nInstallo mlvpn\n\n"  && \
cd && \
cd mlvpn-${MLVPN_VERSION} && libpcap_LIBS="-L${HOME}/libpcap/lib -lpcap" libpcap_CFLAGS="-I${HOME}/libpcap/include" libsodium_LIBS="-L${HOME}/libsodium/lib -lsodium" libsodium_CFLAGS=-I${HOME}/libsodium/include libev_LIBS="-L${HOME}/libev/lib -lev" libev_CFLAGS=-I${HOME}/libev/include ./configure --enable-filters LDFLAGS="-Wl,-Bdynamic" --prefix=${HOME}/mlvpn/ && sudo make install  && \


printf "\n\nElimino file\n" && \
cd && \
sudo rm -R libev-${EV_VERSION} && \
cd && \
sudo rm -R libsodium-${LIBSODIUM_VERSION} && \
cd && \
sudo rm -R libpcap-${PCAP_VERSION} && \
cd && \
sudo rm -R mlvpn-${MLVPN_VERSION} && \

printf "\n\nFine\n"
