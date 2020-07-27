Contents
========

* [How to use this file](#how-to-use-this-file)
* [Introduction](#introduction)
* [Copying the pipeline](#copying-the-pipeline)
* [Directories](#directories)
* [Prerequisites](#prerequisites)
* [Customisation](#customisation)
* [Start the pipeline](#start-the-pipeline)


How to use this file
---------------------

This README file gives an introduction on how clone the pipeline repository and how to run the pipeline on the server. 
If you have any question, comment, complain or suggestion or if you encounter any conflicts or errors in this document or the pipeline, please open an issue.

###### Enjoy your analysis and happy results!

```
Text written in boxes is code, which usually can be executed in your Linux terminal. You can just copy/paste it.
```

`Text in a red box indicates directory or file names`

Text in brackets "<>" indicates that you have to replace it and the brackets by your own appropiate text.

Introduction
------------

BSAnalyser is a pipeline designed to test multiple BS aligners and SNP callers from raw paired-end BS sequencing data (FASTQ). It will align sequences using the chosen aligners and call SNPs using the chosen SNP calling tools for each aligner used.  It can also be used to call SNPs from BS-seq data with a specified aligner and SNP caller.


Copying the pipeline
------------------

To start a new analysis project based on this pipeline, follow the following steps:

- Clone and rename the pipeline-skeleton from our GitLab server by typing in the terminal. Replace <name> by your NIOO login-name. Cloning will only work, if you have logged in to gitlab at least once before:

```
git clone --recurse-submodules https://github.com/nioo-knaw/BSAnalyser.git
```

Then you need to activate BS-snper by doing the following:
```
cd BSAnalyser/programs/BS-snper/
sh BS-Snper.sh
```

or in one line:
```
cd BSAnalyser/programs/BS-snper/ ; sh BS-Snper.sh
```

You should now have a BSAnalyser directory in the directory you are currently in.

Directories
--------------------------

##### The toplevel `README` file

This file contains this content with general information about how to run this pipeline.

##### The `data` directory

Place your paired-end BS-seq data here. It is important to have `_R1_` in the file name of the first of the pair and `_R2_` in the file name of its mate. Besides that, multiple individuals can be placed in this folder and each will be processed.

##### The `src` directory

Contains the code of the BSAnalyser pipeline.

##### The `docs` directory

Here, you can store all other files, like metadata etc.

##### The `output` directory

This is the directory where all output will be generated.
Hierarchy:
```
BSAnalyser
|--- output
	|--- benchmark file with average info on all aligners (`alignfinalAVGS.bnch`, can be used as .tsv file)
	|--- benchmark file with average info on all SNP callers (`snpfinalAVGS.bnch`, can be used as .tsv file)
    |--- aligner
		|--- BS seq Individual
		|--- benchmark file with average info on alignment (`AVGSallInfo.bnch`, can be used as .tsv file)
		|--- benchmark file benchmarking stats on building of the alignment index (`build.bnch`, can be used as .tsv file)
			|--- unaltered alignment file (`unsorted.bam`)
			|--- benchmark file with info on alignment (`allInfo.bnch`, can be used as .tsv file)
		|--- SNP-caller
			|--- benchmark file with average info on SNP caller (`AVGSallInfo.bnch`, can be used as .tsv file)
			|--- BS seq Individual
				|--- unaltered file with SNPs (`snp.raw.vcf`)
				|--- benchmark file with info on SNP caller (`allInfo.bnch`, can be used as .tsv file)
|
```

Prerequisites
------------------

You have to install different dependencies using conda before starting the pipeline for the first time:

```
conda env create -f BSAnalyser.yml
source activate BSAnalyser
```

if you already have created the environment "BSAnalyser" before, than activate it by

```
source activate BSAnalyser
```

You can deactivate the environment after pipeline execution with

```
source deactivate
```

In the `src/config.yaml`, put the path to the reference genome for the sequences next to "refGenome:", just like the example. Just to be clear, this is the folder with refgenome file(s), not the actual file. The rest can be left alone, unless more customisation is desired.

customisation
------------------

##### src/config.yaml
Specify the aligner or SNP caller if only one kind is desired. The name to be entered here can be found in the src/Snakefile file in the "Tools" dictionary. (ctr f "Tools" and you'll find a list of aligners and SNP-callers).
To include new aligners and SNP callers, you can add them to the "Tools" dictionary. Add the command to be called on the cmd-line here to call the new aligner/SNP-caller. Follow the examples found in the dictionary.
Enter the desired amount of cores to allocate per tool in the src/config.yaml file next to "numOfThreads:" instead of the current "1".
A SNP-chip .vcf file can be added next to "snpChip:" to compare the generated `snp.raw.vcf` files of the SNP-callers to the SNP-chip.

##### Custom programs
Some programs cannot be found on conda and require manual installation. The programs already included have been pre-installed in the git repository at the 'programs/' folder. If it is desired, other programs not found on conda can be installed here. They then have to be added the same way as the other programs in the src/Snakefile.
This can be done using git:

```
git submodule add <repo name e.g. "https://github.com/hellbelly/BS-Snper"> programs/<program name e.g. "BS-snper">
```

Start the pipeline
------------------

##### Activate the BSAnalyser environment

(see [Prerequisites](#prerequisites) for detailed instructions).
```
source activate BSAnalyser
```

##### Add read files in the `data` directory.

see [Directories](#directories)

##### Execute the pipeline

Execute the following commands:

```bash
#Navigate to the BSAnalyser/src map
cd ~/BSAnalyser/src

#or
cd BSAnalyser/src

#You can check what will happen by first running a `dry-run`
snakemake -np --reason

#Run!
snakemake --cores <amount of cores to allocate to the entire pipeline>

#If you want one specific alignment done or SNPs called, call for `unsorted.bam` or `snps.called`, e.g.:
snakemake --cores <amount of cores to allocate to the entire pipeline> ~/BSAnalyser/output/bismark/read_r1_/unsorted.bam
snakemake --cores <amount of cores to allocate to the entire pipeline> ~/BSAnalyser/output/bismark/bis-snp/read_r1_/snps.called

#To get the statistics in a tab delimited file (.bnch) on the data that was created (The alignment files (`.bam`) and SNP files (`.vcf`))
#For the aligners:
snakemake --cores <amount of cores to allocate to the entire pipeline> ~/BSAnalyser/output/alignfinalAVGS.bnch

# For the SNP callers
snakemake --cores <amount of cores to allocate to the entire pipeline> ~/BSAnalyser/output/snpfinalAVGS.bnch

# You can also directly process the results in R by afjusting the R script found in the src folder. Only do this if you understand R.
# For the aligners
snakemake --cores <amount of cores to allocate to the entire pipeline> ~/BSAnalyser/output/reports/align/final.done

# For the SNP callers
snakemake --cores <amount of cores to allocate to the entire pipeline> ~/BSAnalyser/output/reports/snp/final.done


```

#### Test data

You can access, copy or link test data from /data/tutorials/epiGBS/test_data/ and run the pipeline.
