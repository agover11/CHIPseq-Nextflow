#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path peaks 
    path genome  

    output:
    path "motifs" 

    script:
    """
    mkdir -p motifs

    findMotifsGenome.pl ${peaks} ${genome} motifs \
        -size 200 \
        -mask \
        -preparsedDir motifs/preparsed
    """

    stub:
    """
    mkdir motifs
    """
}


