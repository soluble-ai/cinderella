#!/bin/bash

cd $(dirname ${BASH_SOURCE[0]})

./create-k3s-user.sh
./configure-user.sh
