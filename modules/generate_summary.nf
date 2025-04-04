process generate_summary {
    tag "summary"

    input:
    val(samples)

    output:
    path("summary.csv")

    script:
    """
    mkdir -p results
    echo "sample_id,species,population,read1,read2,json,html" > summary.csv
    ${samples.collect { s -> "echo '${s.join(",")}' >> summary.csv" }.join("\n")}
    """
}
 
