max={max}

([ -s CMSSW_10_2_22.tar.gz ] || sh setup.sh) || exit
cp /tmp/x509up_u100637 .
mkdir -p CondorJobs

# check the pile-up files before submit 
PILEUP_FILES=pileup_files.txt

if [ -f "$PILEUP_FILES" ]; then
    echo "$PILEUP_FILES exist"
else 
    echo "$PILEUP_FILES does not exist!"
    exit 1
fi

PILEUP_INPUT=$(shuf -n 2 $PILEUP_FILES | tr '\n' ',')
PILEUP_INPUT=${{PILEUP_INPUT::-1}}

if [[ "$PILEUP_INPUT" = *?.root ]]; then
    echo "Pileup input looks OK"
else
    echo "Something unexpected happened with the pileup input!"
    exit 1
fi


for i in `seq 1 $max`
do
    bash {scripts} $i {run}
done
