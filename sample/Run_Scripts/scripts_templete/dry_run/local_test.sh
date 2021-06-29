# echo 365365 | voms-proxy-init -voms cms -valid 192:00
# dasgoclient -query="file dataset=/Neutrino_E-10_gun/RunIISummer17PrePremix-PUAutumn18_102X_upgrade2018_realistic_v15-v1/GEN-SIM-DIGI-RAW" > pileup_files.txt
# dryrun 

sh gKK_gVV_production.sh -p pileup_files.txt -s gKK_gVV -c -o $PWD/{OUT_DIR} -a 1 -n 10 -g {gridpack} -e 1 -l