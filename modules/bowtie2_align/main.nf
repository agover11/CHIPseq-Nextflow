#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample_id), path(trimmed)
    tuple val(index_name), path(index_dir)

    output:
    tuple val(sample_id), path("${sample_id}.bam"), emit: bam

    script:
    """
    bowtie2 -p ${task.cpus} \
    -x ${index_dir}/${index_name} \
    -U ${trimmed} \
    | samtools view -bS - > ${sample_id}.bam
    """

    //stub:
    //"""
    //touch ${sample_id}.bam
   // """
}