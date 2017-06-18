#!/bin/bash

die () {
    echo; echo -e "ERROR: $1"; echo; cd $curdir; exit 1
}

[ -z "$(which packer)" ] && die "Please install packer as describet at https://www.packer.io/docs/install/index.html"

packer build k8s-1.6-gpu-xenial.json
