#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(bigwig)
    path bed_file

    output:
    tuple val(sample_id), path("${sample_id}_matrix.gz")

    script:
    """
    computeMatrix scale-regions \
        -S ${bigwig} \
        -R ${params.ucsc_genes} \
        -a ${params.window} -b ${params.window} \
        --skipZeros \
        -o ${sample_id}_matrix.gz
    """

    stub:
    """
    touch ${sample_id}_matrix.gz
    """
}