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
            -i $read1 \\
            -o ${sample_id}_trimmed.fastq.gz \\
            --json ${sample_id}_fastp.json \\
            -h ${sample_id}_fastp.html
        """
    }
