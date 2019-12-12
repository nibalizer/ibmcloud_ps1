
# Prompt snippet to show ibmcloud account status 
# Zsh version
__ibmcloud_ps1() {
    if [ -f ~/.bluemix/config.json ]; then
        ibm_user=$(cat ~/.bluemix/config.json  | jq '.Account.Owner' | tr -d '"')
        region=$(cat ~/.bluemix/config.json  | jq '.Region' | tr -d '"')
        if [ ! -z "${IBMCLOUD_PS1_COLOR_NO}" ]; then
            echo "${ibm_user}@${region}"
        else
            echo "%F{magenta}${ibm_user}%F{white}@%F{yellow}${region}%f"
        fi
    fi
}
