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
        # Run MultiQC
	multiqc "${json_reports.join(' ')}" --outdir .
        """
    }
