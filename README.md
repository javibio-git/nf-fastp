# nf-fastp-template

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
  --singularity \
  -profile slurm
```
### 4. View the results
After the pipeline completes, you will find the trimmed FASTQ files organized by species and population in the specified output directory. A MultiQC report will also be generated.

### 5. Check the output summary
The output summary CSV file will be located in the output directory and will contain information about the processed samples, including their IDs, species, populations, and paths to the trimmed FASTQ files.