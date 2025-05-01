// modules/multiqc.nf

    process multiqc {
        tag "multiqc"
        container params.multiqc_container
        label 'process_multiqc'
        publishDir "results/multiqc", mode: 'copy'

        input:
        path(json_reports)

        output:
        path("multiqc_report.html")

        script:
        """
        # Run MultiQC on the directory containing the input files
	multiqc . --outdir .
        """
    }
