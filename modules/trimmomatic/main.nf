#!/usr/bin/env nextflow

process TRIM {

    label 'process_low'
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("*_trimmed.fastq.gz"), emit: trimmed
    tuple val(sample_id), path("*_trim.log"), emit: log

    script:
    """
    trimmomatic SE -threads ${task.cpus} \\
        ${reads} \\
        ${sample_id}_trimmed.fastq.gz \\
        ILLUMINACLIP:${params.adapter_fa}:2:30:10 \\
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 \\
        &> ${sample_id}_trim.log
    """

    stub:
    """
    touch ${sample_id}_stub_trim.log
    touch ${sample_id}_stub_trimmed.fastq.gz
    """
}
