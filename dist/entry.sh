#!/bin/sh

/usr/sbin/crond
exec /src/domoticz/domoticz -dbase /config/domoticz.db -log /config/domoticz.log -www 8080

