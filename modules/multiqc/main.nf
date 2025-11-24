#!/usr/bin/env nextflow

process MULTIQC {

    label 'process_medium'
    publishDir 'results', mode: 'copy'
    container 'ghcr.io/bf528/multiqc:latest'

    input:
    path ('*')

    output:
    path 'multiqc_report.html'

    script:
    """
    multiqc -f . 
    """

    stub:
    """
    touch multiqc_report.html
    """
}