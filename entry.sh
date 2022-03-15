mkdir -p "${STEAMAPPDIR}" || true  

bash "${STEAMCMDDIR}/steamcmd.sh" +login anonymous \
				+force_install_dir "${STEAMAPPDIR}" \
				+app_update "${STEAMAPPID}" \
				+quit

# We assume that if the Get5 config is missing, that this is a fresh container
if [ ! -f "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/get5.cfg" ];
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
		wget -O latest-get5.zip https://github.com/splewis/get5/releases/download/0.7.2/get5_0.7.2.zip
		unzip latest-get5.zip -d "${STEAMAPPDIR}/${STEAMAPP}/"
		cp -r "${STEAMAPPDIR}/${STEAMAPP}/get5"/* "${STEAMAPPDIR}/${STEAMAPP}/"
		chmod -R 777 "${STEAMAPPDIR}/${STEAMAPP}/"
		rm -rf latest-get5.zip "${STEAMAPPDIR}/${STEAMAPP}/get5/"

		# Replace current server.cfg with template file
		cp -r custom_server_template.cfg "${STEAMAPPDIR}/${STEAMAPP}/cfg/server.cfg"
		cp -r structured_match_config.cfg "${STEAMAPPDIR}/${STEAMAPP}/cfg/match.cfg"
		cp -r scrim_match_config.cfg "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod/configs/get5/scrim_template.cfg"
		cp -a get5_configs/. "${STEAMAPPDIR}/${STEAMAPP}/cfg/get5/"
fi

if [ $SCRIM == 'true' ]
then
    echo "Configuring server for SCRIM setup"
	# Alter values in Get5 config to be configured for scrim
	sed -i -e 's/get5_check_auths "1"/get5_check_auths "0"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/get5.cfg"
	sed -i -e 's/get5_kick_when_no_match_loaded "1"/get5_kick_when_no_match_loaded "0"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/get5.cfg"
else
    echo "Configuring server for STRUCTURED setup"
	# Alter values in Get5 config to be configured for structured match config
	sed -i -e 's/get5_check_auths "0"/get5_check_auths "1"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/get5.cfg"
	sed -i -e 's/get5_kick_when_no_match_loaded "0"/get5_kick_when_no_match_loaded "1"/g' "${STEAMAPPDIR}/${STEAMAPP}/cfg/sourcemod/get5.cfg"
fi

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
			+sv_game_mode_flags "${MATCH_LENGTH}" \
			+mapgroup "mg_active" \
			+map "de_mirage" \
			+sv_region "3" \
			+net_public_adr "0" \
			-ip "0" \
			+host_workshop_collection "0" \
			+workshop_start_map "0" \
			-authkey "" \
			+sv_setsteamaccount "${SRCDS_TOKEN}"
