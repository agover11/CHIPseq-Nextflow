#!/usr/bin/env nextflow

process ANNOTATE {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path filtered_peaks 
    path genome 
    path gtf

    output:
    path("annotated_peaks.txt"), emit: annotated

    script:
    """
    annotatePeaks.pl $filtered_peaks $genome \
        -gtf $gtf > annotated_peaks.txt
    """

    stub:
    """
    touch annotated_peaks.txt
    """
}
