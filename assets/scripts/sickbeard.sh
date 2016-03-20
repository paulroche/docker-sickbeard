#!/bin/bash

# Display settings on standard out.

USER="sickbeard"

echo "SickBeard settings"
echo "=================="
echo
echo "  User:       ${USER}"
echo "  UID:        ${SICKBEARD_UID:=666}"
echo "  GID:        ${SICKBEARD_GID:=666}"
echo
echo "  Config:     ${CONFIG:=/data/sickbeard/config.ini}"
echo

# Change UID / GID of SickBeard user.
printf "Updating sickbeard user... "
SBEARD=$(id -u sickbeard &> /dev/null)
if [ $? -eq 0 ]; then
  if [ ${SBEARD} != ${SICKBEARD_UID} ]; then
    groupmod -u ${SICKBEARD_GID} ${USER}
    usermod -u ${SICKBEARD_UID} ${USER}
  fi
else
  groupadd -r -g ${SICKBEARD_GID} ${USER}
  useradd -r -u ${SICKBEARD_UID} -g ${SICKBEARD_GID} -d /sickbeard ${USER}
fi
echo "[DONE]"

if [ ! -f ${CONFIG} ]; then
  echo "[ERROR] Unable to find ${CONFIG}"
fi

# Update SickBeard
# git runs as root,  fix permissions after
git -C /sickbeard pull

# Set directory permissions.
printf "Set permissions... "
chmod 2755 /sickbeard
chown -R ${USER}: /sickbeard
chown ${USER}: $(dirname ${CONFIG})
echo "[DONE]"


# Finally, start SickBeard.
echo "Starting SickBeard..."
exec su -pc "/sickbeard/SickBeard.py --nolaunch --datadir=$(dirname ${CONFIG}) --config=${CONFIG}" ${USER}
