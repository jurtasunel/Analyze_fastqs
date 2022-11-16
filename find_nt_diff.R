### This script aligns two fasta files with a reference and produces a csv with the positions that are different between two sequences.
### The rownames are the positions of the nucleotide references on the reference fasta file.
### The script is designed to use a medaka consensus sequence as seq2 and episeq consensus as seq3.

# Libraries:
library(seqinr)

# Functions:
# Get a nucleotide sequence and a vector of positions from an aligned fasta, and returns a vector with unaligned positions. Each nucleotide of the sequence must be a separated string.
unalign_positions <- function(nt_sequence, vector_of_positions){
  unaligned_positions <- c()
  for (i in vector_of_positions){
    seq <- nt_sequence[1:i]
    current_position <- length(which(seq != "-"))
    unaligned_positions <- c(unaligned_positions, current_position)
  }
  
  return(unaligned_positions)
}

# Load sequences.
reference_path = "path/to/reference.fasta"
reference <- read.fasta(reference_path, as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)
my_consensus_path = "path/to/medaka_consensus.fasta"
my_consensus <- read.fasta(my_consensus_path, as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)
episeq_consensus_path = "path/to/episeq_consensus.fasta"
episeq_consensus <- read.fasta(episeq_consensus_path, as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)
# Make the mafft command.
mafft_command = "mafft --auto --reorder fasta_to_align.fasta > mafft_aligned.fasta"

# Get the names and sequences of each fasta on different variables. Seqences must be a list to match the requried input of write.fasta.
sequences <- list(reference[[names(reference)]], my_consensus[[names(my_consensus)]], episeq_consensus[[names(episeq_consensus)]])
seqnames <- c(names(reference), names(my_consensus), names(episeq_consensus))
# Write out the fasta file to align.
fasta_to_align <- write.fasta(sequences = sequences, names = seqnames, file.out = "fasta_to_align.fasta")

# Run mafft.
system(mafft_command)

# Read in the aligned fasta file.
aligned_fasta <- read.fasta("mafft_aligned.fasta", as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)

# Split the second and third sequences.
seq1 <- unlist(strsplit(aligned_fasta[[1]], ""))
seq2 <- unlist(strsplit(aligned_fasta[[2]], ""))
seq3 <- unlist(strsplit(aligned_fasta[[3]], ""))

# Make a vector to store the different positions.
nt_changepos <- c()
ref_nt <- c()
medaka_nt <- c()
episeq_nt <- c()

# Loop through the nt on the reference sequence which is the first one.
for (i in 1:nchar(aligned_fasta[[1]])){
  # Append the positions vector with the positions that differ between seq2 and seq3.
  if (seq2[i] != seq3[i]){
    nt_changepos <- c(nt_changepos, i)
    ref_nt <- c(ref_nt, seq1[i])
    medaka_nt <- c(medaka_nt, seq2[i])
    episeq_nt <- c(episeq_nt, seq3[i])
  }
}

# Bind the vectors together.
positions_result <- rbind(ref_nt, medaka_nt, episeq_nt)
colnames(positions_result) <- nt_changepos
positions_result <- rbind(positions_result, unalign_positions(seq3, nt_changepos))
# Transpose the dataframe and rename columns.
positions_result <- t(positions_result)
colnames(positions_result) <- c("Reference", "Medaka_variant", "Episeq_variant", "Episeq_position")

write.csv(positions_result, "Alignment_changes.csv")





