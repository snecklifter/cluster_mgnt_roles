#!/bin/bash

PWD=`pwd`
source environment

echo "############################################"
echo "# Setting up Registry Mirror"
echo "#"

# Requires httpd-tools and openssl
if ! command -v htpasswd &> /dev/null
then
    echo "htpasswd could not be found, please install httpd-tools"
    exit
fi

if ! command -v openssl &> /dev/null
then
    echo "openssl could not be found, please install openssl"
    exit
fi

mkdir -p $REGISTRY_MIRROR_PATH/{auth,certs,data}
#chmod -R 777 $REGISTRY_MIRROR_PATH

# Create the registry self-signed certificate
cd $REGISTRY_MIRROR_PATH/certs
openssl req \
    -newkey rsa:2048 -nodes \
    -keyout domain.key \
    -x509 -days 36500 -out domain.crt \
    -subj "/C=$CERT_COUNTRY/ST=$CERT_STATE/L=$CERT_LOCATION/O=$CERT_ORGANIZATION/OU=$CERT_ORGANIZATION_UNIT/CN=$CERT_COMMON_NAME/emailAddress=$CERT_EMAIL" \
    -addext "subjectAltName=DNS:$CERT_COMMON_NAME"

# Make certificate trusted by the node hosting the regsitry
cp domain.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust

# Generate username and password for Basic authentication
htpasswd -bBc $REGISTRY_MIRROR_PATH/auth/htpasswd $HTTP_AUTH_USERNAME $HTTP_AUTH_PASSWORD

# Add port 5000 to the internal and public zone
firewall-cmd --add-port=5000/tcp --zone=internal --permanent
firewall-cmd --add-port=5000/tcp --zone=public   --permanent
firewall-cmd --reload

# create pull-secret basic authentication
AUTH=`echo -n $HTTP_AUTH_USERNAME:$HTTP_AUTH_PASSWORD | base64 -w0`

echo "#"
echo "# use the following pull-secret located at $REGISTRY_MIRROR_PATH/auth"
echo "#"

cd $REGISTRY_MIRROR_PATH/auth
cat << SECRET | tee pull-secret.json
{
"auths": {
    "$CERT_COMMON_NAME:5000": {
    "auth": "$AUTH",
    "email": "$CERT_EMAIL"
    }
  }
}
SECRET

echo "#"
echo "############################################"
