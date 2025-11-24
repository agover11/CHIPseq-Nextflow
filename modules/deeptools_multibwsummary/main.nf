#!/usr/bin/env nextflow

process MULTIBWSUMMARY {
    label 'process_high'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path bw_files  

    output:
    path("bw_all.npz"), emit: npz

    script:
    """
    multiBigwigSummary bins -b ${bw_files.join(' ')} -o bw_all.npz --binSize 1000 --outRawCounts bw_all_raw_counts.tab
    """

    stub:
    """
    touch bw_all.npz $task.cpus
    """
}