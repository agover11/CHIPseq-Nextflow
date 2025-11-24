#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple path(replicate1_bed), path(replicate2_bed)

    output:
    path("repr_peaks.bed"), emit: repr_peaks

    script:
    """
    bedtools intersect -a $replicate1_bed -b $replicate2_bed -f 0.1 > repr_peaks.bed
    """

    stub:
    """
    touch repr_peaks.bed
    """
}