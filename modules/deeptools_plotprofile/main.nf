#!/usr/bin/env nextflow

process PLOTPROFILE {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    
    input:
    tuple val(sample_id), path(matrix_file)

    output:
    path "${sample_id}_signal_coverage.png"

    script:
    """
    plotProfile -m ${matrix_file} \
        --outFileName ${sample_id}_signal_coverage.png \
        --plotTitle "Read Coverage Across Gene Body (${sample_id})" \
        --perGroup
    """

    stub:
    """
    touch ${sample_id}_signal_coverage.png
    """
}