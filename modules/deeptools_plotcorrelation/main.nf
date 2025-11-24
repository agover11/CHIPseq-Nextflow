#!/usr/bin/env nextflow

process PLOTCORRELATION {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path(npz)

    output:
    path("correlation_plot.png"), emit: heatmap

    script:
    """
    plotCorrelation -in $npz \
        --corMethod ${params.corrtype} \
        --whatToPlot heatmap \
        --plotNumbers \
        --plotTitle "Sample Correlation Heatmap" \
        --plotFile correlation_plot.png \
        --removeOutliers \
        --colorMap bwr
    """

    stub:
    """
    touch correlation_plot.png
    """
}






