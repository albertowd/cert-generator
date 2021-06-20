#!/bin/sh

# Ask for the GitLab instance host and token.
cat <<EOS

************************************************************************
* Welcome to the certificate generator!                                *
************************************************************************

The script must ask for a domain to generate a self-signed  certificate.
After the input, the certificate \`.crt\` and \`.key\` file will be 
generated in the \`certs\` folder with the domain as the file name.

************************************************************************

EOS

echo "Which domain will be certified (ex.: *.docker.internal)?"
read CERT_DOMAIN

cat <<EOS

Target domain: ${CERT_DOMAIN}

************************************************************************

EOS

if [ -z "${CERT_DOMAIN}" ]; then
  echo "Invalid host, exiting the script!"
  exit 1
fi

echo "Removing the wild card from the final file name..."
CERT_FILE_NAME=$(echo "${CERT_DOMAIN}" | sed "s/[*]/wildcard/g")
echo "${CERT_FILE_NAME}"


# Removing old certificates that possibly is not valid anymore.
echo "Removing old certificates..."
rm -r "./certs/${CERT_FILE_NAME}.crt" || true
rm -r "./certs/${CERT_FILE_NAME}.key" || true

# Generates the new certificate files.
echo "Generating new certificate files..."
openssl req -new -newkey rsa:8192 -days 3650 -nodes -x509 \
    -subj "/L=development/O=albertowd/CN=${CERT_DOMAIN}" \
    -keyout "./certs/${CERT_FILE_NAME}.key" \
    -out "./certs/${CERT_FILE_NAME}.crt"

openssl x509 -noout -subject -in "/certs/${CERT_FILE_NAME}.crt"

# It`s time for a drink!
cat <<EOS

************************************************************************
* Generation completed, it\`s time to copy and use it!                  *
************************************************************************

EOS
