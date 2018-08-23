# EQEmu login server for Docker

docker run -p 5998:5998 -p 5999:5999 -v [yourr_config]:/mnt/login/login.ini -d rabbired/login_eqemu

# Requirements

docker run --restart=always --name [name] -v [you_data]:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=[root_pass] -d mariadb:latest

# Optional

--restart=always
Added automatic startup setting to [docker run] line.

-v /etc/timezone:/etc/timezone -v /etc/localtime:/etc/localtime
