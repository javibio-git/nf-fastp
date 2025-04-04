# nf-fastp

A lightweight and flexible Nextflow pipeline for trimming single-end and paired-end FASTQ files using Fastp, with automatic MultiQC report generation and metadata handling via a sample sheet.

## Features

- 🧬 Accepts both SE and PE reads
- 🔗 Organized outputs by species, population, and sample
- 🚀 Runs with Singularity on SLURM HPC
- 📊 MultiQC summary report
- 📝 Output summary CSV for downstream use

## Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/your-username/nf-fastp.git
cd nf-fastp
```

### 2. Create a sample sheet

Create a CSV file named `samplesheet.csv` in the root directory of the repository. The sample sheet should contain the following columns:

```bash
sample_id,species,population,fastq_1,fastq_2
S1,human,POP1,/absolute/path/S1_R1.fastq.gz,/absolute/path/S1_R2.fastq.gz
S2,mouse,POP2,/absolute/path/S2_R1.fastq.gz,
```
### 3. Run the pipeline

```bash
nextflow run main.nf \
  --samplesheet samplesheet.csv \
  --outdir /path/to/output/dir \
```
### 4. View the results
This version works and run Fastp for all files in the `samplesheet.csv`. **Need to decide if leave the population column since it will create repetitive directories if it is just one sample for each population**

### 5. Check the output summary
This version does not generate an output summary. The multiqc module does not work for fastp. **But fastp generates its own report. Also, work is needed in naming the files the right way: `.html` and `.fastq.gz` files.
