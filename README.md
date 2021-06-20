# cert-generator

A simple way to make auto signed development certificates.

Project to generate a simple self-signed certificate for a domain. It asks for the target domain and makes a new certificate and key files from an alpine:latest docker image on the fly.

## Table of contents
  * [Download](##-Download)
  * [Requirements](##-Requirements)
    * [Linux](###-Linux)
    * [Windows](###-Windows)
  * [Generation](##-Generation)
  * [Disclaimer](##-Disclaimer)

## Download

There are seven pre-defined domain certificates in the project to use locally on the developers machine:

  * [*](https://localhost)
  * [localhost](https://localhost)
  * [*.localhost](https://localhost)
  * [host.docker.internal](https://host.docker.internal)
  * [*.docker.internal](https://docker.internal)
  * [*.internal](https://internal)
  * [*.local](https://local) (rsa512)

The above certificate files should be enough to use out-of-the-box certifications while developing on a local machine. Just copy them as needed to the container or the application folder. 

## Requirements

### Linux

A Linux script is way more straight forward and uses the system openssl to generate the certificate files. So the only requirement is the actual `openssl` tool to be already installed and with access permission configured.

```sh
sh generate-cert-docker.sh
```

or

```sh
sh generate-cert-native.sh
```

### Windows

The script uses a PowerShell V2 terminal to be executed, so it must be on a Windows 8+ host system with a Docker service started to generate the files as the script uses an alpine:latest image to run a `openssl` command.

```ps1
.\generate-cert-docker.ps1
```

Output example:

```

~~~

************************************************************************
* Welcome to the certificate generator!                                *
************************************************************************

The script must ask for a domain to generate a self-signed  certificate.
After the input, the certificate .crt and .pem file will be
generated in the certs folder with the domain as the file name.

************************************************************************

Which domain will be certified (ex.: *.docker.internal)?: host.docker.internal

* Target domain: host.docker.internal

************************************************************************

Removing the wild card from the final file name...
Removing old certificates...
Generating new certificate files...
fetch https://dl-cdn.alpinelinux.org/alpine/v3.13/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.13/community/x86_64/APKINDEX.tar.gz
(1/1) Installing openssl (1.1.1i-r0)
Executing busybox-1.32.1-r0.trigger
OK: 6 MiB in 15 packages
Generating a RSA private key
....+++
......................+++
writing new private key to '/certs/host.docker.internal.pem'
-----
subject=O = development, OU = albertowd, CN = host.docker.internal

************************************************************************
* Generation completed, its time to copy and use it!                  *
************************************************************************

~~~

The output files should pop-up in the explorer window or be listed with a `ls` like command on the `certs` folder.

## Disclaimer

As a normal self-signed certification, the files should be used only for internal development, stagging or backend production services.

**NEVER USE THIS CERTIFICATES FOR END-USER/THIRD-PARTY-SERVICES COMMUNICATION (API or WEB INTERFACES)!!!!**
