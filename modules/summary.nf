// modules/summary.nf

process summary {
	tag "$sample_id"
	publishDir "results/summary", mode: 'copy'

	input:
	tuple val(sample_id), path(fastq_files)

	output:
	path("${sample_id}_summary.csv")

	script:
	"""
	total_reads=\$(zcat ${fastq_files} | wc -l)
	total_reads=\$((total_reads / 4))
	
	echo "sample_id,total_reads" > ${sample_id}_summary.csv
	echo "${sample_id},\$total_reads" >> ${sample_id}_summary.csv
	"""
}
 
