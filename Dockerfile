#####################################################################
# Dockerfile that builds a CSGO Gameserver - modified from original #
#####################################################################
FROM cm2network/steamcmd:root

ENV STEAMAPPID 740
ENV STEAMAPP csgo
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"

# Copy across template config and entry script
COPY entry.sh ${HOMEDIR}/entry.sh
COPY custom_server_template.cfg ${HOMEDIR}/custom_server_template.cfg
COPY match.cfg ${HOMEDIR}/match.cfg

# Create autoupdate config
# Add entry script & ESL config
# Remove packages and tidy up
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.20.1-1.1 \
		ca-certificates=20190110 \
		lib32z1=1:1.2.11.dfsg-1 \
		unzip \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'login anonymous'; \
		echo 'force_install_dir '"${STEAMAPPDIR}"''; \
		echo 'app_update '"${STEAMAPPID}"''; \
		echo 'quit'; \
	   } > "${HOMEDIR}/${STEAMAPP}_update.txt" \
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${HOMEDIR}/custom_server_template.cfg" "${HOMEDIR}/match.cfg" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt" \
	&& rm -rf /var/lib/apt/lists/* 
	
ENV SRCDS_PORT=27015 \
	SRCDS_TV_PORT=27020 \
	SRCDS_CLIENT_PORT=27005 \
	SRCDS_TOKEN=0 \
	METAMOD_VERSION=1.10 \
	SOURCEMOD_VERSION=1.10

# Expose ports
EXPOSE 27015/tcp \
	27015/udp \
	27020/udp

USER ${USER}

VOLUME ${STEAMAPPDIR}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

