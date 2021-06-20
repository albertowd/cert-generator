# Ask for the GitLab instance host and token.
Write-Host @"

************************************************************************
* Welcome to the certificate generator!                                *
************************************************************************

The script must ask for a domain to generate a self-signed  certificate.
After the input, the certificate `.crt` and `.key` file will be 
generated in the `certs` folder with the domain as the file name.

************************************************************************

"@

$CERT_DOMAIN = Read-Host -Prompt "Which domain will be certified (ex.: *.docker.internal)?"

Write-Host @"

Target domain: ${CERT_DOMAIN}

************************************************************************

"@

if(!$CERT_DOMAIN) {
  Write-Host "Invalid host, exiting the script!"
  exit 1
}

Write-Host "Removing the wild card from the final file name..."
$CERT_FILE_NAME = $CERT_DOMAIN -Replace "\*", "wildcard"


# Removing old certificates that possibly is not valid anymore.
Write-Host "Removing old certificates..."
Remove-Item -Force "./certs/${CERT_FILE_NAME}.crt", "./certs/${CERT_FILE_NAME}.key"

# Generates the new certificate files.
Write-Host "Generating new certificate files..."
docker run --rm -it `
  -v "${PWD}/certs:/certs:rw" `
  alpine:latest `
  sh -c @"
    apk add --update openssl
    openssl req -new -newkey rsa:8192 -days 3650 -nodes -x509 \
    -subj \"/L=development/O=albertowd/CN=${CERT_DOMAIN}\" \
    -keyout \"/certs/${CERT_FILE_NAME}.key\" \
    -out \"/certs/${CERT_FILE_NAME}.crt\"
    openssl x509 -noout -subject -in \"/certs/${CERT_FILE_NAME}.crt\"
"@

# It`s time for a drink!
Write-Host @"

************************************************************************
* Generation completed, it`s time to copy and use it!                  *
************************************************************************

"@
