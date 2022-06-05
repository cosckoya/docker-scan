FROM debian:11 as base

LABEL description = "Toolbox"
LABEL maintainer = "cosckoya@mail.me"

# Install Base Packages
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq \
  && apt-get install -qq -y --no-install-recommends \
    ca-certificates apt-transport-https lsb-release gnupg \
    wget curl iputils-ping nmap unzip \
    default-mysql-client postgresql-client \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

## AZURE TOOLS
FROM base as azure

RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

RUN apt-get update -qq \
  && apt-get install -qq -y --no-install-recommends \
    azure-cli \
  && rm -rf /var/lib/apt/lists/*

## GOOGLE TOOLS
FROM base as google

RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

#RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /etc/apt/trusted.gpg.d/apt-key.gpg > /dev/null

RUN apt-get update -qq \
  && apt-get install -qq -y --no-install-recommends \
    google-cloud-sdk \
  && rm -rf /var/lib/apt/lists/*

## AWS TOOLS
FROM base as aws

RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip -qq awscliv2.zip \
  && ./aws/install -i /usr/local/aws-cli -b /usr/local/bin --update \
  && rm -rf ./aws awscliv2.zip
