// modules/summary.nf

process summary {
	tag "$sample_id"
	container params.jq_container
	label 'process_summary'
	publishDir "results/summary", mode: 'copy'

	input:
	tuple val(sample_id), path(fastq_files)

	output:
	path("${sample_id}_summary.csv")

	script:
	"""
	echo "sample_id,total_reads" > ${sample_id}_summary.csv
	jq -r '[.summary.before_filtering.total_reads] | @csv' ${fastq_files.find { it.name.endsWith('_fastp.json') }} \\
		| sed 's/^/"$sample_id",/' >> ${sample_id}_summary.csv	
	
	"""
}
 
