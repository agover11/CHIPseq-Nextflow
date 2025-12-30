# RUNX1 ChIP-seq Analysis in Breast Cancer Cells

## Description
This project analyzes ChIP-seq data from Barutcu et al., 2016, to investigate how the transcription factor **RUNX1** affects gene expression and chromatin organization in MCF-7 breast cancer cells. The workflow integrates ChIP-seq and RNA-seq analysis to identify RUNX1 binding sites, assess reproducibility, and link binding events to gene expression changes.

## Methods
1. **Data Input**  
   - 2 biological replicates with paired IP (RUNX1 ChIP) and INPUT control samples  
   - Total: 4 FASTQ files  
2. **Quality Control**  
   - FastQC v0.12.1 for sequence quality  
   - Trimmomatic v0.39 for adapter trimming and low-quality base removal  
   - Bowtie2 v2.5.0 for alignment to hg38  
   - Samtools v1.17 for BAM conversion, sorting, indexing, and alignment statistics  
   - MultiQC v1.25 to aggregate QC metrics  
3. **Coverage & Correlation Analysis**  
   - Deeptools v3.5.5 `bamCoverage` to generate bigWig coverage tracks  
   - Deeptools `multiBigwigSummary` for correlation between replicates  
   - Pearson correlation used for linear relationships across genomic bins  
4. **Peak Calling & Annotation**  
   - HOMER v4.11 for tag directory creation and peak calling (`makeTagDirectory` and `findPeaks`)  
   - Bedtools v2.31.1 to identify reproducible peaks (≥10% overlap)  
   - Remove peaks overlapping ENCODE blacklist regions  
   - Annotate peaks to nearest genomic features using HOMER `annotatePeaks.pl`  
5. **Integration & Functional Analysis**  
   - Combine ChIP-seq peaks with GEO RNA-seq data (GSE75070)  
   - Filter RNA-seq results: `padj < 0.01` and `|log2FC| > 1`  
   - Functional enrichment with ENRICHR v3.4 (adjusted p-value < 0.05)  
   - Visualization and further analysis using Python v3.10.19 and R v4.4.3  
6. **Visualization**  
   - Coverage plots across gene bodies and loci (e.g., MALAT1, NEAT1)  
   - Motif enrichment plots  
   - Correlation and Venn diagrams for peak reproducibility  
   - Functional enrichment plots for top pathways  
7. **Execution Environment**  
   - Nextflow pipelines run on BU Shared Computing Cluster (SCC)  
   - Singularity containers for all tools 

## Deliverables
- Raw FASTQ files for IP and INPUT samples  
- Trimmed and aligned BAM files  
- bigWig coverage tracks  
- Reproducible peak BED files and annotations  
- Coverage, correlation, and Venn diagram plots  
- Motif enrichment tables and plots  
- Functional enrichment analysis plots  
- Integrated ChIP-seq + RNA-seq results linking RUNX1 binding to gene expression  

## References
- Barutcu AR, et al. *RUNX1 contributes to higher-order chromatin organization and gene regulation in breast cancer cells*, 2016  
- ENRICHR: https://maayanlab.cloud/Enrichr/  
- UCSC Table Browser: https://genome.ucsc.edu/cgi-bin/hgTables  
