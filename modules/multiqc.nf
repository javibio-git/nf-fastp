params.multiqc_container = "docker://quay.io/biocontainers/multiqc:1.14--pyhdfd78af_0"

process multiqc {
    tag "multiqc"
    container params.multiqc_container

    input:
    path (json_files)

    output:
    path "multiqc_report.html"
    path "multiqc_data"

    script:
    """
    multiqc . -o ./
    """
}
