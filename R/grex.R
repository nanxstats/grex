#' Gene ID Mapping for Genotype-Tissue Expression (GTEx) Data
#'
#' Map Ensembl IDs to Entrez Gene ID, HGNC symbol, and UniProt ID,
#' with basic annotation information such as gene type.
#'
#' @param ensembl_id Character vector of Ensembl IDs
#'
#' @return This function returns a data frame with the
#' same number of rows as the length of input Ensembl IDs, containing:
#' \itemize{
#' \item \code{ensembl_id} - Input Ensembl ID
#' \item \code{entrez_id} - Entrez Gene ID
#' \item \code{hgnc_symbol} - HGNC gene symbol
#' \item \code{hgnc_name} - HGNC gene name
#' \item \code{cyto_loc} - Cytogenetic location
#' \item \code{uniprot_id} - UniProt ID
#' \item \code{gene_biotype} - Gene type
#' }
#' The elements that cannot be mapped will be \code{NA}.
#'
#' @export grex
#'
#' @examples
#' # Ensembl IDs in GTEx v6p gene count data
#' data("gtexv6p")
#' # select 100 IDs as example
#' id <- gtexv6p[101:200]
#' df <- grex(id)
#' # Rows that have a mapped Entrez ID
#' df[
#'   !is.na(df$"entrez_id"),
#'   c("ensembl_id", "entrez_id", "gene_biotype")
#' ]
grex <- function(ensembl_id) {
  id <- as.character(ensembl_id)

  # Ensembl ID sanity check
  if (any(grepl("\\.", id))) {
    stop('"." found in the IDs, please use cleanid() or your method to remove them first.', call. = FALSE)
  }

  # initialize matrix
  n <- length(id)
  m <- ncol(grex_db)
  mat <- matrix(NA, nrow = n, ncol = m)
  id_names <- colnames(grex_db)
  colnames(mat) <- id_names

  # fill matrix with mapped IDs
  mat[, "ensembl_id"] <- id
  mat[, 2L:m] <- as.matrix(grex_db[id, 2L:m])

  df <- as.data.frame(mat, stringsAsFactors = FALSE)
  df
}

#' Remove Version Numbers in Raw GTEx (GENCODE) Gene IDs
#'
#' Remove the `.version` part in raw GTEx (GENCODE) gene IDs to
#' produce Ensembl IDs.
#'
#' @param gtex_id Character vector of GTEx (GENCODE) gene IDs
#'
#' @return Character vector of Ensembl IDs
#'
#' @export cleanid
#'
#' @examples
#' gtex_id <- c("ENSG00000227232.4", "ENSG00000223972.4", "ENSG00000268020.2")
#' cleanid(gtex_id)
cleanid <- function(gtex_id) sapply(strsplit(gtex_id, "\\."), "[", 1L)
