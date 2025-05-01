process fastp {
    tag "${sample_id}"

    input:
    tuple val(sample_id), val(species), val(population), path(read1), val(read2)

    output:
    tuple val(sample_id), val(species), val(population), path("${sample_id}_trimmed_1.fastq.gz"), path("${sample_id}_trimmed_2.fastq.gz"),
          path("${sample_id}_fastp.json"), path("${sample_id}_fastp.html")

    when:
    read2 != null

    container:
    "quay.io/biocontainers/fastp:0.20.1--h8b12597_0"

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

    input:
    tuple val(sample_id), val(species), val(population), path(read1), val(read2)

    output:
    tuple val(sample_id), val(species), val(population), path("${sample_id}_trimmed.fastq.gz"),
          path("${sample_id}_fastp.json"), path("${sample_id}_fastp.html")

    when:
    read2 == null

    container:
    "quay.io/biocontainers/fastp:0.20.1--h8b12597_0"

    script:
    """
    fastp -i ${read1} -o ${sample_id}_trimmed.fastq.gz \
          --json ${sample_id}_fastp.json \
          --html ${sample_id}_fastp.html
    """
}

process multiqc {
    tag "multiqc"

    input:
    path "*.json"

    output:
    path "results/multiqc/multiqc_report.html"
    path "results/multiqc/multiqc_data"

    container:
    "quay.io/biocontainers/multiqc:1.14--pyhdfd78af_0"

    script:
    """
    mkdir -p results/multiqc
    multiqc . -o results/multiqc
    """
}

process generate_summary {
    tag "summary"

    input:
    val(samples)

    output:
    path("results/summary.csv")

    script:
    """
    echo "sample_id,species,population,read1,read2,json,html" > results/summary.csv
    ${samples.collect { s -> "echo '${s.join(",")}' >> results/summary.csv" }.join("\n")}
    """
} 