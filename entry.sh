mkdir -p "${STEAMAPPDIR}" || true  

bash "${STEAMCMDDIR}/steamcmd.sh" +login anonymous \
				+force_install_dir "${STEAMAPPDIR}" \
				+app_update "${STEAMAPPID}" \
				+quit

# We assume that if the config is missing, that this is a fresh container
if [ ! -f "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg" ];
	then
		# Download & extract the config
		wget -qO- "${DLURL}/master/etc/cfg.tar.gz" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"
		
		# Download metamod
		LATESTMM=$(wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/mmsource-latest-linux)
		wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/"${LATESTMM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"	

		# Download sourcemod
		LATESTSM=$(wget -qO- https://sm.alliedmods.net/smdrop/"${SOURCEMOD_VERSION}"/sourcemod-latest-linux)
		wget -qO- https://sm.alliedmods.net/smdrop/"${SOURCEMOD_VERSION}"/"${LATESTSM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"

		# Download get5
		wget -O latest-get5.zip https://ci.splewis.net/job/get5/514/artifact/builds/get5/get5-514.zip
		unzip latest-get5.zip -d "${STEAMAPPDIR}/${STEAMAPP}/"
	else
		# Alter values in Get5 config to be configured for scrim
		sed -i -e 's/get5_check_auths "1"/get5_check_auths "0"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/get5.cfg"
		sed -i -e 's/get5_kick_when_no_match_loaded "1"/get5_kick_when_no_match_loaded "0"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/get5.cfg"
fi

# Replace current server.cfg with template file
cp -r custom_server_template.cfg "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"

# Believe it or not, if you don't do this srcds_run shits itself
cd ${STEAMAPPDIR}

bash "${STEAMAPPDIR}/srcds_run" -game "${STEAMAPP}" -console -autoupdate \
			-steam_dir "${STEAMCMDDIR}" \
			-steamcmd_script "${HOMEDIR}/${STEAMAPP}_update.txt" \
			-usercon \
			+fps_max "300" \
			-tickrate "128" \
			-port "${SRCDS_PORT}" \
			+tv_port "${SRCDS_TV_PORT}" \
			+clientport "${SRCDS_CLIENT_PORT}" \
			-maxplayers_override "14" \
			+game_type "0" \
			+game_mode "1" \
			+mapgroup "mg_active" \
			+map "de_inferno" \
			+sv_region "3" \
			+net_public_adr "0" \
			-ip "0" \
			+host_workshop_collection "0" \
			+workshop_start_map "0" \
			-authkey "" \
			+sv_setsteamaccount "${SRCDS_TOKEN}"