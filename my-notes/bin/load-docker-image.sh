#!/bin/bash

echo "Load docker image:"
sha512sum -c Docker-Image_hsa_ees-lab_220328.tgz.sha512sum && \
docker load -i Docker-Image_hsa_ees-lab_220328.tgz
echo "Done."
