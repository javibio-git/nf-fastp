
include { fastp_single } from '../modules/fastp_single.nf'
include { fastp_paired } from '../modules/fastp_paired.nf'


workflow fastp {
    take:
    paired_reads
    single_reads

    main:
    paired_reads  | fastp_paired
    single_reads  | fastp_single

    emit:
    trimmed = fastp_paired.out.map{ t -> tuple(t[0], [t[1], t[2], t[3]]) }.mix(fastp_single.out.map{ t -> tuple(t[0], [t[1], t[2]]) })


}

