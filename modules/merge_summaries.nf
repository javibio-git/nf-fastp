// modules/merge_summaries.nf

process merge_summaries {
	tag "merge_summaries"
	label 'process_merge_summaries'
	publishDir "results/summary/", mode: 'copy'

	input:
	path summary_files
	
	output:
	path("all_samples_summary.csv")

	script:
	"""
	# Merge all CSVs, then fix header at the end
	cat ${summary_files} > merged_unsorted.csv

	# Extract header and body separately
	head -n 1 ${summary_files[0]} > all_samples_summary.csv
	grep -v -F -x -f all_samples_summary.csv merged_unsorted.csv \\
		| sort -t',' -k1,1 >> all_samples_summary.csv
		
	"""
}

