# Retrieve, extract, and build grex mapping table
#
# This script works under the `grex` package directory
#
# Get the latest `org.Hs.eg.db` version from:
# https://bioconductor.org/packages/devel/data/annotation/html/org.Hs.eg.db.html

ver <- "3.6.0"
system(paste0(
  "curl https://bioconductor.org/packages/devel/data/annotation/src/contrib/org.Hs.eg.db_",
  ver, ".tar.gz --output ~/org.Hs.eg.db.tar.gz"
))
system(paste0("tar -xvf ~/org.Hs.eg.db.tar.gz -C ~/"))

# connect to the SQLite db
library("DBI")
library("RSQLite")
con <- dbConnect(RSQLite::SQLite(), "~/org.Hs.eg.db/inst/extdata/org.Hs.eg.sqlite")

# load useful tables
dbListTables(con)
# a mapping table combining ensembl + ncbi
ensembl <- dbReadTable(con, "ensembl")
genes <- dbReadTable(con, "genes")
gene_info <- dbReadTable(con, "gene_info")
cytogenetic_locations <- dbReadTable(con, "cytogenetic_locations")
uniprot <- dbReadTable(con, "uniprot")

# remove duplication in id to ensembl to primary id mappings
# by keeping each ensembl id's first primary id appears in the table
ensembl <- ensembl[!duplicated(ensembl$"ensembl_id"), ]
rownames(ensembl) <- as.character(ensembl$"ensembl_id")

rownames(genes) <- as.character(genes$"X_id")
rownames(gene_info) <- as.character(gene_info$"X_id")

# remove duplication in id to cytogenetic location mappings
# by keeping each id's first location data appears in the table
cytogenetic_locations <- cytogenetic_locations[!duplicated(cytogenetic_locations$"X_id"), ]
rownames(cytogenetic_locations) <- as.character(cytogenetic_locations$"X_id")

# remove duplication in id to uniprot mappings
# by keeping each id's first uniprot data appears in the table
uniprot <- uniprot[!duplicated(uniprot$"X_id"), ]
rownames(uniprot) <- as.character(uniprot$"X_id")

# build grex db
grex_db <- ensembl
key <- as.character(grex_db$"X_id")
grex_db$"entrez_id" <- genes[key, "gene_id"]
grex_db$"hgnc_symbol" <- gene_info[key, "symbol"]
grex_db$"hgnc_name" <- gene_info[key, "gene_name"]
grex_db$"cyto_loc" <- cytogenetic_locations[key, "cytogenetic_location"]
grex_db$"uniprot_id" <- uniprot[key, "uniprot_id"]

# remove previous primary key
grex_db$"X_id" <- NULL

# disconnect from db
dbDisconnect(con)

# add gene type to mapping table
library("biomaRt")
ensembl_mart <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")

ensembl_ids <- grex_db$"ensembl_id"

gene_type_table <- getBM(
  attributes = c("ensembl_gene_id", "gene_biotype"),
  filters = "ensembl_gene_id",
  values = ensembl_ids, mart = ensembl_mart
)

row.names(gene_type_table) <- gene_type_table$"ensembl_gene_id"
grex_db$"gene_biotype" <- gene_type_table[grex_db$"ensembl_id", "gene_biotype"]

# clean up workspace
rm(list = c(
  "ver", "con", "key", "cytogenetic_locations", "ensembl", "gene_info",
  "genes", "uniprot", "ensembl_mart", "ensembl_ids", "gene_type_table"
))

# save grex db to package directory
save(grex_db, file = "R/sysdata.rda", compress = "xz")
