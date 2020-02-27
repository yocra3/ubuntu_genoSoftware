FROM ubuntu:18.04 

MAINTAINER Carlos Ruiz

## Avoids problems when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Install basic software and system libraries
RUN apt-get update --fix-missing && \
  apt-get install -q -y tabix git make gcc libz-dev python-dev libbz2-dev \
			liblzma-dev libcurl4-openssl-dev g++ libssl-dev autoconf pkg-config \
			libncurses5-dev wget unzip default-jre libtbb-dev python-numpy \
			python-matplotlib python-pysam python-pip

## vt
RUN cd ~ && git clone https://github.com/atks/vt.git  && \
 #change directory to vt
 cd vt && \
 #run make, note that compilers need to support the c++0x standard 
 make && \
 #you can test the build
 make test
 
ENV PATH $PATH:~/vt/

## vcftools
RUN cd ~ && git clone https://github.com/vcftools/vcftools.git && \
	cd vcftools/ && \
	./autogen.sh && \
	./configure && \
	make && \
	make install 

## htslib
RUN cd ~ && git clone https://github.com/samtools/htslib.git && \
	cd htslib/ && \
	autoheader && \
	autoconf -Wno-syntax && \
	./configure && \
	make && \
	make install 


## samtools
RUN cd ~ && git clone https://github.com/samtools/samtools.git && \
	cd samtools/ && \
	autoheader && \
	autoconf -Wno-syntax && \
./configure && \
	make && \
	make install 


## bcftools
RUN cd ~ && git clone https://github.com/samtools/bcftools.git && \
	cd bcftools/ && \
	autoheader && \
	autoconf -Wno-syntax && \
	./configure && \
	make && \
	make install

## plink
RUN cd ~ && mkdir plink && cd plink &&\
 wget http://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20200219.zip &&\
 unzip plink_linux_x86_64_20200219.zip &&\
 cp plink /usr/bin/ && cp prettify /usr/bin/


## STAR
RUN cd ~ && git clone https://github.com/alexdobin/STAR.git && \
	cd STAR/source/ && \
	make STAR
	
ENV PATH $PATH:~/STAR/bin/Linux_x86_64/

## fastQC
RUN cd ~ && wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip && \
	unzip fastqc_v0.11.9.zip && rm fastqc_v0.11.9.zip && \
	chmod 755 FastQC/fastqc

ENV PATH $PATH:~/FastQC/

## Bowtie2
RUN cd ~ && wget -O bowtie2-2.4.0-source.zip https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.4.0/bowtie2-2.4.0-source.zip/download && \
	unzip bowtie2-2.4.0-source.zip && rm bowtie2-2.4.0-source.zip && \
	cd bowtie2-2.4.0 && make

ENV PATH $PATH:~/bowtie2-2.4.0/

## FastQ Screen
RUN cd ~ && wget http://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/fastq_screen_v0.14.0.tar.gz && \
	tar -zxvf fastq_screen_v0.14.0.tar.gz && rm fastq_screen_v0.14.0.tar.gz

## skewer
RUN cd ~ && git clone https://github.com/relipmoc/skewer.git && \
	cd skewer && \
	make && make install

## htseq
RUN pip install HTSeq

## multi QC
RUN pip install multiqc