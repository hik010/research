#! /bin/bash
#SBATCH -o ./out/%A.%x.%a.out # STDOUT
#SBATCH -e ./err/%A.%x.%a.err # STDERR
#SBATCH --mem=20G
#SBATCH --array=1-353%55

##############################################################################################
#
#
#   Name: phewas.sh
#
#   Description: Used to run pheWAS on UKBB data. 
#
#   Usage: sbatch phewas.sh
#
#   MUST FILL IN: snps dosageFile sampleFile out
#
#   Output: [snp].csv files for each snp & .jpeg for snps with significant hits & results.tsv file for the  list of significant hits for all snps
#
#   By: Hyo Kim
#
#   Last updated: 6/25/2020
#
##############################################################################################

#list of rsids, space deliminated (make sure to adjust the adjust the array numbers)
snps=()

snp=${snps[$SLURM_ARRAY_TASK_ID - 1]}
#output files made from snp_retriever_UKB_bgen_dosage.v4.sh script
    #ex: /cellar/users/hik010/Data/f30MINE/ukbpheWAS/UKBB_hannah_subset.dosage.gz
dosageFile=
sampleFile=
#output directory
out=

echo "Running snp: $snp"

#extracting specific rsid dosage from the large dosageFile into extracted_$snp 
zgrep -w $snp $dosageFile > $out/extracted_$snp 

date
hostname

#making .geno file contating IID and rsid dosage to be used for phewas.r 
python /cellar/users/hik010/Data/pheWAS/dosageFormatting.py --dosage $out/extracted_$snp --snp $snp --out $out --sample $sampleFile
#making .jpeg and .csv file contatining pheWAS results
Rscript /cellar/users/hik010/Data/pheWAS/phewas.r --geno $out/$snp.geno -o $out

rm $out/extracted_$snp
rm $out/$snp.geno

date

