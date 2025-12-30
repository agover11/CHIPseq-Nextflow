# RUNX1 ChIP-seq Analysis in Breast Cancer Cells

## Description
This project analyzes ChIP-seq data from Barutcu et al., 2016, to investigate how the transcription factor **RUNX1** affects gene expression and chromatin organization in MCF-7 breast cancer cells. The workflow integrates ChIP-seq and RNA-seq analysis to identify RUNX1 binding sites, assess reproducibility, and connect binding events with gene expression changes.

## Methods
### Data Input
- 2 biological replicates, each with paired IP (RUNX1 ChIP) and INPUT controls  
- Total: 4 FASTQ files  
### Quality Control
- **FastQC v0.12.1**: evaluate sequence quality  
- **Trimmomatic v0.39**: adapter and low-quality base trimming  
- **Bowtie2 v2.5.0**: alignment to hg38  
- **Samtools v1.17**: BAM sorting, indexing, alignment statistics  
- **MultiQC v1.25**: aggregated QC metrics  
### Coverage & Correlation
- **Deeptools v3.5.5 bamCoverage**: bigWig coverage tracks  
- **multiBigwigSummary**: calculate correlations between coverage tracks  
- Pearson correlation used to assess replicate similarity  
### Peak Calling & Annotation
- **HOMER v4.11**: tag directory creation and peak calling  
- Reproducible peaks defined by **Bedtools v2.31.1 intersect** (≥10% overlap)  
- ENCODE blacklist regions removed  
- Peaks annotated to nearest genomic features with HOMER annotatePeaks.pl  
### Downstream Analysis
- Integration with GEO RNA-seq dataset (GSE75070)  
- Differential expression filtering: **padj < 0.01**, **|log2FC| > 1**  
- Functional enrichment with **ENRICHR v3.4** (adjusted p-value < 0.05)  
- Visualization and analysis using **Python v3.10.19** and **R v4.4.3**  


## Deliverables
- Raw FASTQ files for IP and INPUT samples  
- Trimmed and aligned BAM files  
- bigWig coverage tracks  
- Reproducible peak BED files and annotations  
- Correlation plots and coverage profiles  
- Motif enrichment tables  
- Functional enrichment plots  
- Integrated ChIP-seq + RNA-seq analysis linking RUNX1 binding to gene expression  

## References
- Barutcu AR, et al. *RUNX1 contributes to higher-order chromatin organization and gene regulation in breast cancer cells*, 2016  
- ENRICHR: https://maayanlab.cloud/Enrichr/  
- UCSC Table Browser: https://genome.ucsc.edu/cgi-bin/hgTables  
