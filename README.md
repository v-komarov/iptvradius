## radius server для управление доступом к мультикасту пользователей IPTV 

Решение собрано на трех контейнерах:

- [mysql](mysql/README.md)
- [freeradius](freeradius/README.md)
- [oracli](oracli/README.md)

![docker ps](img/dockerps.png)


Пример успешной авторизации:

![tcpdump](img/tcpdump.png)

- **radtest.py** - скрипт тестирования radius сервера (с передачей Framed-IP-Address реквизита)