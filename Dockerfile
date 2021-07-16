FROM ubuntu:18.04 AS build

RUN mkdir /home/eqemu && mkdir /home/eqemu/server && mkdir /home/eqemu/server/logs

WORKDIR /home/eqemu

RUN apt-get -y update && \
apt-get install -yqq libstdc++6 build-essential gcc-5 g++-5 libtool cmake curl debconf-utils git git-core \
libio-stringy-perl liblua5.1 liblua5.1-dev libluabind-dev libmysql++ libperl-dev libperl5i-perl libsodium-dev \
libmysqlclient-dev lua5.1 minizip make mariadb-client unzip uuid-dev zlibc wget libssl-dev

RUN wget http://ftp.us.debian.org/debian/pool/main/libs/libsodium/libsodium-dev_1.0.11-2_amd64.deb -O ./libsodium-dev.deb && \
wget http://ftp.us.debian.org/debian/pool/main/libs/libsodium/libsodium18_1.0.11-2_amd64.deb -O ./libsodium18.deb && \
dpkg -i ./libsodium*.deb && \
mv ./libsodium*.deb ./server/

RUN git clone --depth 1 https://github.com/EQEmu/Server.git &&\
mkdir /home/eqemu/Server/build

WORKDIR /home/eqemu/Server/build

RUN cmake -DEQEMU_ENABLE_BOTS=OFF -DEQEMU_BUILD_LOGIN=ON -DEQEMU_BUILD_LUA=ON -G "Unix Makefiles" .. && make loginserver -j2

RUN cp -rf /home/eqemu/Server/build/bin/* /home/eqemu/server && \
cp -rf /home/eqemu/Server/loginserver/login_util/* /home/eqemu/server

FROM ubuntu:18.04

MAINTAINER RedZ "rabbired@outlook.com"

COPY --from=build /home/eqemu/server /mnt/login

WORKDIR /mnt/login

RUN apt-get update && \
apt-get install -y -qq mariadb-client libconfig-inifiles-perl liblua5.1 \
libmysql++ libperl5i-perl lua5.1 zlibc wget unzip && \
dpkg -i ./libsodium*.deb && \
rm -rf ./libsodium*.deb && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

EXPOSE 5998 5999

COPY login.pl ./

CMD ["perl","./login.pl"]
