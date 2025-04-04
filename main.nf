nextflow.enable.dsl=2

workflow {
    samples = Channel.fromPath(params.samplesheet)
        .splitCsv(header: true)
        .map { row -> tuple(row.sample_id, row.species, row.population, file(row.fastq_1), row.fastq_2 ? file(row.fastq_2) : null) }

    trimmed_pe = samples.filter { it[4] != null } | fastp
    trimmed_se = samples.filter { it[4] == null } | fastp_single

    all_trimmed = trimmed_pe.mix(trimmed_se)

    summary_entries = all_trimmed.map { sample_id, species, population, r1, r2 = null, json, html ->
        def sample_dir = file("results/${species}/${population}/${sample_id}")
        sample_dir.mkdirs()

        def r1_out = "${sample_dir}/${r1.name}"
        def r2_out = r2 ? "${sample_dir}/${r2.name}" : ""
        def json_out = "${sample_dir}/${json.name}"
        def html_out = "${sample_dir}/${html.name}"

        r1.move(r1_out)
        if (r2) r2.move(r2_out)
        json.move(json_out)
        html.move(html_out)

        tuple(sample_id, species, population, r1_out, r2_out, json_out, html_out)
    }

    generate_summary(summary_entries)

    all_trimmed.map { it[5] } | multiqc
}