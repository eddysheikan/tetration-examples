#!/bin/bash

# GENERIC GET (sensors)
#
# Author: Edwin Gonzalez Urzua (eddysheikan@GitHub)
#
# This program performs an HTTP GET Request to obtain information
# about sensors. The HTTP request is done manually via cURL

# Defining the values for the headers
HOST="https://tetrationcluster.cisco.com"
URI="/openapi/v1/applications"

# This is the API KEY
ID="000000000000000000000000000000000000" 

# This is the API Secret from the Cluster
API_SECRET="00000000000000000000000000000000000000"

# Content-Type is JSON, as we expect to handle both req and resp this way
CONTENT_TYPE="application/json"

# Time should be given as UTC in the format YYYY-MM-DDTHH:mm:ss+0000
TIMESTAMP=$(TZ=GMT date "+%FT%T+0000")

# Optional - User-Agent (what kind of client is this)
USER_AGENT="Cisco Tetration via CURL"

# This header is used for POST/PUT. Mainly and to get the SHA256 digest
# In this case, it is not required for GET.
X_TETRATION_CKSUM=""

# HTTP Request
REQUEST="GET"

# cURL options:
# -X defines the type of the request (GET, POST, PUT...)
# -k allows curl to proceed and operate even for server connections otherwise considered insecure
# -v indicates verbose. Prints the whole headers info from the request
# -H defines the specific headers.
# Authorization header comes from SHA256 HMAC Digest from the headers info.
# Note the format: (request)\n(resource)\n....

curl -X "$REQUEST" -k -v -H "User-Agent: $USER_AGENT" -H "Id: $ID" -H "X-Tetraiton-Cksum: $X_TETRATION_CKSUM" -H "Content-Type: $CONTENT_TYPE" -H "Authorization: $(echo -en "$REQUEST\n$URI\n$X_TETRATION_CKSUM\n$CONTENT_TYPE\n$TIMESTAMP\n" | openssl sha256 -binary -hmac $API_SECRET | openssl base64 -A)" -H "Timestamp: $TIMESTAMP" "$HOST$URI"