/// `main.nf` ///

nextflow.enable.dsl=2

// PARAMETERS
params.samplesheet = "./samplesheet.csv"   // Path to the input samplesheet
params.outdir      = "./results"	   // Base output directory
params.threads     = 8			   // Number of threads to use for fastp 


// Include subworkflow and processes (must be top-level in DSL2)
include { fastp           } from './subworkflows/fastp.nf'
include { summary         } from './modules/summary.nf'
include { multiqc         } from './modules/multiqc.nf'
include { merge_summaries } from './modules/merge_summaries.nf'


// Load sample sheet, determine paired vs single, and emit clean channels
def branched = Channel
    .fromPath(params.samplesheet)
    .splitCsv(header: true)
    .map { row ->
        if (!row.fastq_1)
            exit 1, "Missing 'fastq_1' entry for sample: ${row.sample_id}"

        def sample = row.sample_id
        def r1 = file(row.fastq_1)
        def r2 = row.fastq_2 ? file(row.fastq_2) : null

        r2 ? tuple('paired', sample, r1, r2) : tuple('single', sample, r1)
    }
    .branch {
        paired: it[0] == 'paired'
        single: it[0] == 'single'
    }

branched.paired
    .map { t -> tuple(t[1], t[2], t[3]) }
    .set { paired_reads }

branched.single
    .map { t -> tuple(t[1], t[2]) }
    .set { single_reads }


workflow {
	// Run fastp, internally handling paired-end and single-end branches
	fastp(paired_reads, single_reads)
	
	// Access the 'trimmed' output channel from the 'fastp' subworkflow
	def fastp_json = fastp.out.trimmed.map { sample_id, files ->
		def json_report = files.find { it.name.endsWith('_fastp.json') }
		if (json_report) {
			json_report
		} else {
			null // Emit null if no JSON report is found for a sample
		}
	}.filter { it != null } // Filter out the null values

	// Collect all JSON reports into a single list for MultiQC
	fastp_json.collect().set { all_jsons }

	// Run MultiQC once for all samples
	multiqc(all_jsons).set { multiqc_report }

	// Run summary (per sample)
	summary(fastp.out.trimmed).set { summary_files } // Assuming my module can handle the list of FASTQ files 

	// Merge all per-sample summaries into one
	merge_summaries(summary_files).set { final_summary }

	workflow.onComplete {
		println "\n========================="
		println "Pipeline execution finished!"
		println "Results organized under 'results/' folder:"
		println " - Trimmed FASTQ:	results/fastp/"
		println " - Sample summaries:	results/summary/"
		println " - Merged summary:	results/summary/all_samples_summary.csv"
		println " -MultiQC report: 	results/multiqc/multiqc_report.html"
		println "=========================\n"
	}
}
