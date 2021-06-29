#!/bin/bash
echo $PWD

echo ${{1}} 

OUTPUT_FILE={OUTPUT_FILE} 
OUTPUTDIR={OUTPUTDIR}


# do we need the CMSSW_10_2_22.tar.gz?

cat>Job_${{1}}.sh<<EOF
#!/bin/bash
tar -xf CMSSW_10_2_22.tar.gz
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc7_amd64_gcc820 
cd CMSSW_10_2_22/src
scramv1 b ProjectRename
cmsenv
export SCRAM_ARCH="slc7_amd64_gcc820";
scramv1 b
cd -
sh gKK_gVV_production.sh -p pileup_files.txt -s {process} -o $PWD -a \${{1}} -n {nEvents} -g {gridpack} -f ${{OUTPUT_FILE}} -e \${{2}}\${{3}} -c 
EOF

chmod 775 Job_${{1}}.sh


cat>condor_${{1}}.jdl<<EOF
universe = vanilla
Executable = Job_${{1}}.sh
Arguments = ${{1}} \$(Cluster) \$(Process)
Requirements = OpSys == "LINUX" && (Arch != "DUMMY" )
request_disk = 10000000
request_memory = 6000
Should_Transfer_Files = YES
WhenToTransferOutput = ON_EXIT
transfer_input_files = Job_${{1}}.sh, gKK_gVV_production.sh, pileup_files.txt, CMSSW_10_2_22.tar.gz , x509up_u100637 
transfer_output_remaps = "${{OUTPUT_FILE}} = ${{OUTPUTDIR}}/File_\$(Cluster)_\$(Process)_${{1}}_${{OUTPUT_FILE}}"
notification = Never
Output = CondorJobs/STDOUT_\$(Cluster)\$(Process)${{1}}.stdout
Error = CondorJobs/STDERR_\$(Cluster)\$(Process)${{1}}.stderr
Log = CondorJobs/LOG_\$(Cluster)\$(Process)${{1}}.log
x509userproxy = x509up_u100637
+MaxRuntime           = 86400
Queue {queue_number}
EOF



if [ "${{2}}" = "run" ]; then
   condor_submit condor_${{1}}.jdl
   echo "submit condor job"
else
   echo 'dry run'
fi
