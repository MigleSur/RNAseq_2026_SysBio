rule multiqc:
    input:
        fastqc = expand("results/fastqc/{sample}_{stage}_fastqc.html",
            sample=config["samples"],
            stage=["raw","filtered"]),
        fastp =  expand("results/fastp/{sample}_fastp.html",
            sample=config["samples"]),
        hisat = expand("results/hisat2/{sample}_summary.txt",
            sample=config["samples"])
    output:
        "results/multiqc/multiqc_report.html",
        directory("results/multiqc/multiqc_data"),
    params:
        extra="--verbose",  # Optional: extra parameters for multiqc.
#    conda:
#        "../envs/rnaseq_preprocess.yaml"  
    wrapper:
        "v8.1.1/bio/multiqc"