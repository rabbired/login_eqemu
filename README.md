# EQEmu login server for Docker

docker run -p 5998:5998/udp -p 5999:5999/udp --volumes-from [your_emudata_containers_name] -d rabbired/emulogin

# Requirements

docker run -p 3306:3306 -v [your_config_path]:/mnt/eqemu/emucfg -v /mnt/eqemu -e MYSQL_ROOT_PASSWORD=[you_password] -d rabbired/emudata

# Optional
--restart=always
Added automatic startup setting to [docker run] line.
