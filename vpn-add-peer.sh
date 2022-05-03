#!/bin/bash
mkdir -p wg-meshconf
cd wg-meshconf; exec wg-meshconf addpeer "$@"
