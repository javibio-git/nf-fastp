params.fastp_container = "quay.io/biocontainers/fastp:0.20.1--h8b12597_0"

process fastp {
    tag "${sample_id}"
    container params.fastp_container

    input:
    tuple val(sample_id), val(species), val(population), path(read1), val(read2)

    output:
    tuple val(sample_id), val(species), val(population), path("${sample_id}_trimmed_1.fastq.gz"), path("${sample_id}_trimmed_2.fastq.gz"),
          path("${sample_id}_fastp.json"), path("${sample_id}_fastp.html")

    when:
    read2 != null

    script:
    """
    fastp -i ${read1} -I ${read2} \
          -o ${sample_id}_trimmed_1.fastq.gz \
          -O ${sample_id}_trimmed_2.fastq.gz \
          --json ${sample_id}_fastp.json \
          --html ${sample_id}_fastp.html
    """
}

process fastp_single {
    tag "${sample_id}"
    container params.fastp_container

    input:
    tuple val(sample_id), val(species), val(population), path(read1), val(read2)

    output:
    tuple val(sample_id), val(species), val(population), path("${sample_id}_trimmed.fastq.gz"),
          path("${sample_id}_fastp.json"), path("${sample_id}_fastp.html")

    when:
    read2 == null

    script:
    """
    fastp -i ${read1} -o ${sample_id}_trimmed.fastq.gz \
          --json ${sample_id}_fastp.json \
          --html ${sample_id}_fastp.html
    """
}
