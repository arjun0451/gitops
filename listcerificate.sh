#!/bin/bash

# Path to the trusted CA file
trust_file="/etc/ssl/certs/ca-certificates.crt"

# List certificates and their validity
openssl crl2pkcs7 -nocrl -certfile "$trust_file" | openssl pkcs7 -print_certs -noout | awk -v OFS='\t' 'BEGIN {print "Subject", "Issuer", "Validity Start", "Validity End"} {print $1, $2, $3, $4}'