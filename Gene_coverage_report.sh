#!/bin/bash

#if needed the script can be easily put into a loop so that it can read multiple sambamba_output at one.
##Before starting make sure the file is tab delimited - remove any spaces and ";" to improve readability (it is my personal taste)
sed -i $'s|;|\t|g' NGS148_34_139558_CB_CMCMD_S33_R1_001.sambamba_output.txt
sed -i $'s|\s|\t|g' NGS148_34_139558_CB_CMCMD_S33_R1_001.sambamba_output.txt
 
##Sum the percentage30 column for each gene and report the number of exons per gene
perl -lane '$sum{$F[6]} += $F[11]; $sum2{$F[6]}++; END { print "$_ $sum{$_} $sum2{$_}"  for sort grep length, keys %sum }' NGS148_34_139558_CB_CMCMD_S33_R1_001.sambamba_output.txt > tmp

##Calculate the average of percentage30 column
awk '{print $1,$3,$2/$3}' tmp > tmp1
## GeneSymbol was in the header form the NGS148_34_139558_CB_CMCMD_S33_R1_001.sambamba_output.txt file so I need to remove it!
sed -i '/GeneSymbol/d' ./tmp1 

##Generate the report
echo '#Gene NumerOfexomes %covered' > head
cat head tmp1 > Percentace_coverage_per_gene.txt
sed -i $'s|\s|\t|g' Percentace_coverage_per_gene.txt

##Flag genes with percentage30 < 100%
awk '{if($3 <100) print $0;}' Percentace_coverage_per_gene.txt > Flagged_coverageGenes_less100%.txt

rm tmp tmp1 head
