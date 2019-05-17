# Extract and cleanup GTEx gene name data

library("readr")

# GTEx v6 ----------------------------------------------------------------------

# gct file path
gct_path <- "https://storage.googleapis.com/gtex_analysis_v6/rna_seq_data/GTEx_Analysis_v6_RNA-seq_RNA-SeQCv1.1.8_gene_reads.gct.gz"

# read gene count matrix
x <- read_tsv(gct_path, skip = 2, col_types = cols_only(Name = "c"))

# # gene count sanity check if the gct file lives locally and uncompressed
# identical(as.integer(scan(gct_path, what = "complex", nlines = 2)[2]), nrow(x))

# convert to vector
gtexv6 <- grex::cleanid(x$"Name")

# save as package data
save(gtexv6, file = "data/gtexv6.rda", compress = "xz")

# GTEx v6p ---------------------------------------------------------------------

# gct file path
gct_path <- "https://storage.googleapis.com/gtex_analysis_v6p/rna_seq_data/GTEx_Analysis_v6p_RNA-seq_RNA-SeQCv1.1.8_gene_reads.gct.gz"

# read gene count matrix
x <- read_tsv(gct_path, skip = 2, col_types = cols_only(Name = "c"))

# # gene count sanity check if the gct file lives locally and uncompressed
# identical(as.integer(scan(gct_path, what = "complex", nlines = 2)[2]), nrow(x))

# convert to vector
gtexv6p <- grex::cleanid(x$"Name")

# save as package data
save(gtexv6p, file = "data/gtexv6p.rda", compress = "xz")

# GTEx v7 ----------------------------------------------------------------------

# gct file path
gct_path <- "https://storage.googleapis.com/gtex_analysis_v7/rna_seq_data/GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_reads.gct.gz"

# read gene count matrix
x <- read_tsv(gct_path, skip = 2, col_types = cols_only(Name = "c"))

# # gene count sanity check if the gct file lives locally and uncompressed
# identical(as.integer(scan(gct_path, what = "complex", nlines = 2)[2]), nrow(x))

# convert to vector
gtexv7 <- grex::cleanid(x$"Name")

# save as package data
save(gtexv7, file = "data/gtexv7.rda", compress = "xz")
