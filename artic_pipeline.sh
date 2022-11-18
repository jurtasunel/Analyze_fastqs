#!bin/bash

### Artic instalation: https://artic.network/ncov-2019/ncov2019-bioinformatics-sop.html
### Primer shcemes: https://github.com/phac-nml/primer-schemes
### Primer schemes documentation: https://psy-fer.github.io/interARTIC/primers/
### Artic version of muscle: https://ubuntu.pkgs.org/20.04/ubuntu-universe-amd64/muscle_3.8.1551-2build1_amd64.deb.html
#### Muscle conda error: https://github.com/artic-network/artic-ncov2019/issues/93
#### Artic common issues: https://github.com/artic-network/artic-ncov2019/issues

#### This script requires the artic environment to be activated with "source activate artic-ncov2019".

# Get the required variables. Example:
barcode_path="/home/josemari/Desktop/Jose/fix_fastqs/Eric_fastqs/"
barcode="barcode06"
prefix="Eric"

# Quality check for one barcode with artic and concatenate all fasqs in one single file.
echo "Running artic guppyplex for ${barcode_path}${barcode}"
artic guppyplex --min-length 300 --max-length 1400 --directory ${barcode_path}${barcode} --prefix ${prefix}

# Run medaka with artic primersto produce consensus sequence.
echo "Running artic medaka for ${barcode_path}${barcode}"
artic minion --medaka --medaka-model r941_min_high_g360 --normalise 200 --threads 8 --scheme-directory ~/artic-ncov2019/primer_schemes/midnight/ --read-file ${prefix}_${barcode}.fastq nCoV-2019/V1 ${prefix}_${barcode}
