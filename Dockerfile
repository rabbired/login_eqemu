FROM debian:9 AS build

RUN mkdir /home/eqemu && mkdir /home/eqemu/server && mkdir /home/eqemu/server/logs

WORKDIR /home/eqemu

#RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
RUN	apt-get -y update && \
	apt-get -y -qq install bash build-essential cmake cpp curl debconf-utils \
	g++ gcc git git-core libio-stringy-perl liblua5.1 liblua5.1-dev libluabind-dev \
	libmysql++ libperl-dev libperl5i-perl libwtdbomysql-dev minizip lua5.1 make \
	mariadb-client unzip uuid-dev wget zlibc libsodium-dev libsodium18 libjson-perl libssl-dev

RUN wget http://ftp.us.debian.org/debian/pool/main/libs/libsodium/libsodium-dev_1.0.11-1~bpo8+1_amd64.deb -O ./libsodium-dev.deb && \
	wget http://ftp.us.debian.org/debian/pool/main/libs/libsodium/libsodium18_1.0.11-1~bpo8+1_amd64.deb -O ./libsodium18.deb && \
	dpkg -i ./libsodium*.deb && mv ./libsodium*.deb ./server/

RUN git clone --depth 1 https://github.com/EQEmu/Server.git &&\
#RUN git clone --depth 1 https://gitee.com/rabbired/EQEmuServer.git Server && \
	mkdir /home/eqemu/Server/build

WORKDIR /home/eqemu/Server/build

RUN cmake -DEQEMU_ENABLE_BOTS=OFF -DEQEMU_BUILD_LOGIN=ON -DEQEMU_BUILD_LUA=ON -G "Unix Makefiles" .. && make loginserver -j2

RUN cp -rf /home/eqemu/Server/build/bin/* /home/eqemu/server && \
        cp -rf /home/eqemu/Server/loginserver/login_util/* /home/eqemu/server

FROM debian:9

MAINTAINER RedZ "rabbired@outlook.com"

COPY --from=build /home/eqemu/server /mnt/login

WORKDIR /mnt/login

#RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
RUN	apt-get update && apt-get install -y \
	mariadb-client libio-stringy-perl liblua5.1-dev wget libjson-perl && \
	dpkg -i ./libsodium*.deb && rm -rf ./libsodium*.deb && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 5998 5999

COPY login.pl /mnt/login

CMD ["perl","/mnt/login/login.pl"]
