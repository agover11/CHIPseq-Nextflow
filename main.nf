// Include your modules here
include { FASTQC } from './modules/fastqc'
include { TRIM } from './modules/trimmomatic'
include { BOWTIE2_BUILD } from './modules/bowtie2_build'
include { BOWTIE2_ALIGN } from './modules/bowtie2_align'
include { SAMTOOLS_SORT } from './modules/samtools_sort'
include { SAMTOOLS_IDX } from './modules/samtools_idx'
include { SAMTOOLS_FLAGSTAT } from './modules/samtools_flagstat'
include { MULTIQC } from './modules/multiqc'
include { BAMCOVERAGE } from './modules/deeptools_bamcoverage'
include { MULTIBWSUMMARY } from './modules/deeptools_multibwsummary'
include { PLOTCORRELATION } from './modules/deeptools_plotcorrelation'
include { TAGDIR } from './modules/homer_maketagdir'
include { FINDPEAKS } from './modules/homer_findpeaks'
include { POS2BED } from './modules/homer_pos2bed'
include { BEDTOOLS_INTERSECT } from './modules/bedtools_intersect'
include { BEDTOOLS_REMOVE } from './modules/bedtools_remove'
include { ANNOTATE } from './modules/homer_annotatepeaks'
include { COMPUTEMATRIX } from './modules/deeptools_computematrix'
include { PLOTPROFILE } from './modules/deeptools_plotprofile'
include { FIND_MOTIFS_GENOME } from './modules/homer_findmotifsgenome'

workflow {
    //Here we construct the initial channels we need
    
    Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { read_ch }

    FASTQC(read_ch)

    TRIM(read_ch) 

    // Create an index of the assembly
    BOWTIE2_BUILD(params.genome)

    // Align the reads to the assembly
    BOWTIE2_ALIGN(TRIM.out.trimmed, BOWTIE2_BUILD.out.index)

    SAMTOOLS_SORT(BOWTIE2_ALIGN.out.bam)

    SAMTOOLS_IDX( SAMTOOLS_SORT.out.sorted)

    SAMTOOLS_FLAGSTAT ( BOWTIE2_ALIGN.out.bam )

    multiqc_ch = FASTQC.out.zip
        .map { sample, file -> file }
        .mix(TRIM.out.log.map { sample, file -> file })
        .mix(SAMTOOLS_FLAGSTAT.out.flagstat.map { sample, file -> file })
        .collect()

    // Run MultiQC on everything once
    MULTIQC(multiqc_ch)

    // BAMCOVERAGE emits: tuple(val(sample_id), path(bw))
    BAMCOVERAGE(SAMTOOLS_IDX.out.bam_index)

    // Extract only paths and collect into a list
    BAMCOVERAGE.out.bw
        .map { sample_id, bw_file -> bw_file }   // extract only the BigWig paths
        .collect()
        .set { bw_files_ch }

    // MULTIBWSUMMARY expects a list of paths
    MULTIBWSUMMARY(bw_files_ch)

    // PLOTCORRELATION expects the .npz output from MULTIBWSUMMARY
    PLOTCORRELATION(MULTIBWSUMMARY.out.npz)

    TAGDIR(BOWTIE2_ALIGN.out.bam)

    TAGDIR.out
    | map { name, path -> tuple(name.split('_')[1], [(path.baseName.split('_')[0]): path]) }
    | groupTuple(by: 0)
    | map { rep, maps -> tuple(rep, maps[0] + maps[1])}
    | map { rep, samples -> tuple(rep, samples.IP, samples.INPUT)}
    | set { paired_ch }


    // Send to FINDPEAKS
    FINDPEAKS(paired_ch)

    POS2BED(FINDPEAKS.out.peaks_txt)

    // Collect all BED files into a list
    POS2BED.out.bed
        .collect()
        .map { beds ->
            // Make sure we have exactly 2 replicates
            tuple(beds[0], beds[1])
        }
        .set { bed_pair_ch }

    // Call BEDTOOLS_INTERSECT
    BEDTOOLS_INTERSECT(bed_pair_ch)

    BEDTOOLS_REMOVE(BEDTOOLS_INTERSECT.out.repr_peaks, params.blacklist)

    ANNOTATE(BEDTOOLS_REMOVE.out.filtered_peaks, params.genome, params.gtf)

    ip_samples = BAMCOVERAGE.out.bw.filter { sample_id, bw ->
    !sample_id.toLowerCase().contains('input')
    }

    COMPUTEMATRIX(ip_samples, params.ucsc_genes)

    PLOTPROFILE(COMPUTEMATRIX.out)

    FIND_MOTIFS_GENOME(BEDTOOLS_REMOVE.out.filtered_peaks, params.genome)
    }