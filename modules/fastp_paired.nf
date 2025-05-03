process fastp_paired {
        tag "$sample_id"
        container params.fastp_container
        label 'process_fastp'
        publishDir "results/fastp", mode: 'copy'

        input:
        tuple val(sample_id), path(read1), path(read2)

        output:
        tuple val(sample_id), path("${sample_id}_R1_trimmed.fastq.gz"), path("${sample_id}_R2_trimmed.fastq.gz"), path("${sample_id}_fastp.json")

        script:
        """
        fastp \\
            -p \\
            --detect_adapter_for_pe \\
            -i $read1 -I $read2 \\
            -o ${sample_id}_R1_trimmed.fastq.gz \\
            -O ${sample_id}_R2_trimmed.fastq.gz \\
            --cut_front \\
            --cut_tail \\
            --cut_window_size 4 \\
            --cut_mean_quality 20 \\
            --json ${sample_id}_fastp.json \\
            --html ${sample_id}_fastp.html \\
            --thread 24
        """
}
