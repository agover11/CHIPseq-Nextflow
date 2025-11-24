#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path peaks_bed
    path blacklist_bed  

    output:
    path("repr_peaks_filtered.bed"), emit: filtered_peaks

    script:
    """
    bedtools intersect -v -a $peaks_bed -b $blacklist_bed > repr_peaks_filtered.bed
    """ 

    stub:
    """
    touch repr_peaks_filtered.bed
    """
}