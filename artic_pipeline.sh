#!bin/bash

### Artic instalation: https://artic.network/ncov-2019/ncov2019-bioinformatics-sop.html
### Primer shcemes: https://github.com/phac-nml/primer-schemes
### Primer schemes documentation: https://psy-fer.github.io/interARTIC/primers/
### Artic version of muscle: https://ubuntu.pkgs.org/20.04/ubuntu-universe-amd64/muscle_3.8.1551-2build1_amd64.deb.html
#### Muscle conda error: https://github.com/artic-network/artic-ncov2019/issues/93
#### Artic common issues: https://github.com/artic-network/artic-ncov2019/issues

# Quality check for one barcode with artic
artic guppyplex --min-length 300 --max-length 1400 --directory /home/josemari/Desktop/Jose/fix_fastqs/Laura_fastQs/barcode29 --prefix Laura

# medaka command with artic primers
artic minion --medaka --medaka-model r941_min_high_g360 --normalise 200 --threads 8 --scheme-directory ~/artic-ncov2019/primer_schemes/midnight/ --read-file Laura_barcode29.fastq nCoV-2019/V1 Laura_barcode29

# Command with arguments for loop
artic minion --medaka --medaka-model r941_min_high_g360 --normalise 400 --threads 5 --scheme-directory ~/artic-ncov2019/primer_schemes/midnight/ --read-file ${PREFIX_RUN}_${BARCODE}.fastq nCoV-2019/V1 ${PREFIX_RUN}_${BARCODE}




