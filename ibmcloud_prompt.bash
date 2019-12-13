# From Arch Wiki

txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

#fizzbuzz/c100-e-us-east-containers-cloud-ibm-com:30566/IAM#skrum@us.ibm.com
#current-context: nibz-k8s/bnpaoppd08v2df1qkgpg
# current-context: default/c100-e-us-south-containers-cloud-ibm-com:30252/IAM#skrum@us.ibm.com
#current-context: backend/c100-e-us-south-containers-cloud-ibm-com:30252/IAM#skrum@us.ibm.com
#current-context: default/c100-e-us-east-containers-cloud-ibm-com:30566/IAM#skrum@us.ibm.com
# 
#default[devadvo@us.ibm.com@us-south]nibz@huygens:~/devel/nibalizer/ibmcloud_ps1$ k
#kubectl config view --minify --output 'jsonpath={..server}'

#kubectl config view --minify --output 'jsonpath={..user}'





# Prompt snippet to show ibmcloud account status 
# Zsh version
__ibmcloud_ps1() {
    if [ ! -f ~/.bluemix/config.json ]; then
        return
    fi
    out=""
    if [ ! -z "${IBMCLOUD_PS1_SHOW_IAM}" ]; then
        if [ -z "$out" ]; then
            prefix=""
        else
            prefix=" "
        fi
        ibm_user=$(cat ~/.bluemix/config.json  | jq '.Account.Owner' | tr -d '"')
        region=$(cat ~/.bluemix/config.json  | jq '.Region' | tr -d '"')
        if [ ! -z "${IBMCLOUD_PS1_COLOR_NO}" ]; then
            out+="${ibm_user}@${region}"

        else
            out+="\[${bldpur}\]${ibm_user}\[${txtrst}\]@\[${bldylw}\]${region}\[${txtrst}\]"
        fi
    fi
    if [ ! -z "${IBMCLOUD_PS1_SHOW_KUBE}" ]; then
        if [ -z "$out" ]; then
            prefix=""
        else
            prefix=" "
        fi
        server=$(kubectl config view --minify --output 'jsonpath={..server}')
        if echo $server | grep 'containers.cloud.ibm.com' >/dev/null; then
            # Using IBM Kube
            kube_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
            if kubectl config view --minify --output 'jsonpath={..user}' | grep IAM >/dev/null; then
                # ROKS cluster
                kube_name='OpenShift'
            else
                # IKS cluster
                kube_name=$(kubectl config current-context | cut -d "/" -f 1)
            fi

        else
            # Not using IBM Kube, name=context
            kube_name=$(kubectl config current-context)
        fi
        if [ ! -z "${IBMCLOUD_PS1_COLOR_NO}" ]; then
            out+="${prefix}${kube_name} N: ${kube_namespace}"
        else
            out+="${prefix}\[${bldpur}\]${kube_name}\[${txtrst}\]:\[${bldylw}\]${kube_namespace}\[${txtrst}\]"
        fi
    fi
    echo "${out}"
}
