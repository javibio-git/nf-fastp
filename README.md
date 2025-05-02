# nf-fastp

A lightweight and flexible Nextflow pipeline for trimming single-end and paired-end FASTQ files using Fastp, with automatic MultiQC report generation and metadata handling via a sample sheet.

## Features

- 🧬 Accepts both SE and PE reads
- 🚀 Runs with Singularity on SLURM HPC
- 📊 MultiQC summary report
- 📝 Output summary CSV for downstream use

## Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/your-username/nf-fastp.git

```

### 2. Create a sample sheet

Create a CSV file named `samplesheet.csv` in the root directory of the repository. The sample sheet should contain the following columns:

```bash
sample_id,species,fastq_1,fastq_2
S1,human,/absolute/path/S1_R1.fastq.gz,/absolute/path/S1_R2.fastq.gz
S2,mouse,/absolute/path/S2_R1.fastq.gz,
```
### 3. Run the pipeline

```bash
nextflow run nf-fastp/ \
	--samplesheet ./samplesheet.csv \
	--outdir ./results \
	-profile slurm \
	-resume \
	-with-report execution_report.html

```
### 4. View the results
A `MultiQC` report is generated for the `fastp` runs. Inspect the `multiqc_report.html` file for `fastp` stats. This file is located in `./results/multiqc/`

### 5. Check the output summary
Summary files in `csv` format are generated for each sample and a single `all_samples_summary.csv` is also created. These files contain `sample_di` and `total_reads` columns.
