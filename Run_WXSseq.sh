# Run_WXSseq.sh
## WXSseq  - Whole eXome Sequencing pipeline

## BWA mapping of Illumina paired reads to reference genome - hg38.fa
bwa mem -t 16 hg38.fa Indian_R1.fq.gz Indian_R2.fq.gz >Indian.sam

## Illumina-based SAM to BAM conversion
samtools view -hSbo Indian.bam  Indian.sam

## Ilumina-based BAM file sorting
samtools sort -@ 16 -m 4G Indian.bam -o Indian.sorted.bam

## Illumina-based BAM file indexing
samtools index Indian.sorted.bam

## VCFcalling from Indian.sorted.bam
bcftools mpileup -Ovu -f hg38.fa Indian.sorted.bam | bcftools call --ploidy 1 -vm -Ov > Indian_variants.vcf

## zip VCF
bgzip -l 9 Indian_variants.vcf
