#!/bin/bash

echo "=>" Ensuring Wine Office Installed Image exists
if ./build_office_image.sh; then
    echo " ->" Wine Office built
else
    echo " ->" Wine Office build failed
    exit 1
fi

echo "=>" Building Python Office Installer Image
if docker build --target wine32_office_python -t wine_office/office_python -f Dockerfile . ; then
    echo " ->" Python Office Installer Image built
else
    echo " ->" Python Office Installer Image build failed
    exit 1
fi

