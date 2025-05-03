process fastp_single {
        tag "$sample_id"
        container params.fastp_container
        label 'process_fastp'
        publishDir "results/fastp", mode: 'copy'

        input:
        tuple val(sample_id), path(read1)

        output:
        tuple val(sample_id), path("${sample_id}_trimmed.fastq.gz"), path("${sample_id}_fastp.json")

        script:
        """
        fastp \\
            -p \\
            -i $read1 \\
            -o ${sample_id}_trimmed.fastq.gz \\
            --cut_front \\
            --cut_tail \\
            --cut_window_size 4 \\
            --cut_mean_quality 20 \\
            --json ${sample_id}_fastp.json \\
            --html ${sample_id}_fastp.html \\
            --thread 24
        """
    }
