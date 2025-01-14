import argparse

def parse_ms_file(ms_file):
    """
    Parse an ms-format file and extract positions and haplotypes.
    """
    with open(ms_file, 'r') as f:
        lines = f.readlines()

    # Extract SNP positions (line starts with 'positions:')
    positions = []
    haplotypes = []
    for line in lines:
        if line.startswith("positions:"):
            positions = line.strip().split()[1:]
        elif line.startswith("0") or line.startswith("1"):
            haplotypes.append(line.strip())
    
    # Convert positions to float
    positions = [float(pos) for pos in positions]
    return positions, haplotypes

def write_vcf(output_file, positions, haplotypes):
    """
    Write positions and haplotypes to a VCF file.
    """
    num_samples = len(haplotypes)
    num_sites = len(positions)

    with open(output_file, 'w') as vcf:
        # VCF header
        vcf.write("##fileformat=VCFv4.2\n")
        vcf.write(f"##source=ms_to_vcf_script\n")
        vcf.write(f"#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t" +
                  "\t".join([f"Sample{i+1}" for i in range(num_samples)]) + "\n")
        
        # VCF body
        for idx, pos in enumerate(positions):
            ref = "A"  # Arbitrary reference allele
            alt = "T"  # Arbitrary alternative allele
            genotypes = [hap[idx] for hap in haplotypes]
            genotype_string = "\t".join([f"{g}|{g}" for g in genotypes])  # Assuming diploid
            vcf.write(f"1\t{int(pos * 1000000)}\t.\t{ref}\t{alt}\t.\t.\t.\tGT\t{genotype_string}\n")

def main():
    parser = argparse.ArgumentParser(description="Convert ms file to VCF format.")
    parser.add_argument("ms_file", help="Input ms file")
    parser.add_argument("vcf_file", help="Output VCF file")
    args = parser.parse_args()

    # Parse the ms file
    positions, haplotypes = parse_ms_file(args.ms_file)
    
    # Write the VCF file
    write_vcf(args.vcf_file, positions, haplotypes)

if __name__ == "__main__":
    main()

