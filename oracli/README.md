## Ретранслятор данных абонентов из базы данных AP (oracle) в mysql (freeradius)

Каждые пять минут опрашивается база данных биллинга Onyma , - данные
пользователей записываются в таблицу radbilling (mysql)

- **build.sh** - скрипт сборки образа
- **instantclient-basic-linux.x64-11.2.0.4.0.zip** - oracle клиент
- **iptv_to_rad.py** - основной скрипт
- **myloop.sh** - организация цикла для **iptv_to_rad.py**
- **runoracli.sh** - скрипт создания контейнера
- **oracli.service** - служба systemd
