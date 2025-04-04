nextflow.enable.dsl=2

include { fastp; fastp_single } from './modules/fastp.nf'
include { multiqc } from './modules/multiqc.nf'
include { generate_summary } from './modules/generate_summary.nf'

workflow {
    samples = Channel.fromPath(params.samplesheet)
        .splitCsv(header: true)
        .map { row -> tuple(row.sample_id, row.species, row.population, file(row.fastq_1), row.fastq_2 ? file(row.fastq_2) : null) }

    trimmed_pe = samples.filter { it[4] != null } | fastp
    trimmed_se = samples.filter { it[4] == null } | fastp_single

    all_trimmed = trimmed_pe.mix(trimmed_se)

    summary_entries = all_trimmed.map { sample_id, species, population, r1, r2 = null, json, html ->
        def sample_dir = "results/${species}/${population}/${sample_id}"

        def r1_out = file("${sample_dir}/${r1.getBaseName()}")
        def r2_out = r2 ? file("${sample_dir}/${r2.getBaseName()}") : ""
        def json_out = file("${sample_dir}/${json.getBaseName()}")
        def html_out = file("${sample_dir}/${html.getBaseName()}")

        r1.copyTo(r1_out)
        if (r2) r2.copyTo(r2_out)
        json.copyTo(json_out)
        html.copyTo(html_out)

        tuple(sample_id, species, population, r1_out, r2_out, json_out, html_out)
    }

    generate_summary(summary_entries)

    // all_trimmed.map { it[5] } | multiqc
}
