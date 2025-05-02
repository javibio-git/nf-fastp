// modules/merge_summaries.nf

process merge_summaries {
	tag "merge_summaries"
	label 'process_merge_summaries'
	publishDir "results/summary/", mode: 'copy'

	input:
	path(summary_csvs)
	
	output:
	path("all_samples_summary.csv")

	script:
	"""
	# Merge CSVs and sort by sample_id
	(head -n 1 ${summary_csvs[0]} && tail -n +2 -q ${summary_csvs}) \\
		| sort -t',' -k1,1 \\
		> all_samples_summary.csv

	"""
}

