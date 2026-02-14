rule hisat2:
   input:
       fastq=expand("{path}/{{sample}}_filtered.fastq", path=config["input_path"])
   output:
       sam="results/hisat2/{sample}.sam",
       bam="results/hisat2/{sample}.bam",
       summary="results/hisat2/{sample}_summary.txt"
   params:
       index=config["genome_index"]
   conda: "envs/preprocess_rnaseq.yaml"
   threads: 2
   shell:
       """
       hisat2 -p {threads} -x {params.index} -U {input.fastq} --new-summary --summary-file {output.summary} -S {output.bam}
       samtools view -b {output.bam} {output.sam}
       """



rule sort_bam:
   input:
       unsorted_bam="results/hisat2/{sample}.bam"
   output:
       sorted_bam="results/hisat2/{sample}.sorted.bam"
   threads: 4
   conda: "envs/preprocess_rnaseq.yaml"
   shell:
       """
           samtools sort -@ {threads} -o {output.sorted_bam} {input.unsorted_bam}
       """

rule index_bam:
   input:
       sorted_bam="results/hisat2/{sample}.sorted.bam"
   output:
       bam_index="results/hisat2/{sample}.sorted.bam.bai"
   conda: "envs/preprocess_rnaseq.yaml"
   shell:
       """
           samtools index {input.sorted_bam}
       """

