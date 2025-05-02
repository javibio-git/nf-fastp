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
	
	# Convert input string to Bash array
	declare -a files=(${summary_files})

	# Sort file names and assign first one to header_file
	sorted_files=(\$(printf '%s\\n' \"\${files[@]}\" | sort))
	header_file=\${sorted_files[0]}

	echo "Files to merge:" > merge_debug.log
	printf '%s\\n' \"\${sorted_files[@]}\" >> merge_debug.log
	head -n 1 \$header_file >> merge_debug.log

	# Merge: keep header from first file, skip header from the rest
	(head -n 1 \$header_file && tail -n +2 -q \"\${sorted_files[@]}\") \\
		| sort -t',' -k1,1 > all_samples_summary.csv
		
	"""
}

