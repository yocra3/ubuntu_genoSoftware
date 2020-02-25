FROM ubuntu:18.04 

MAINTAINER Carlos Ruiz


# Install basic software and system libraries
RUN apt-get update --fix-missing && \
  apt-get install -q -y tabix git make gcc libz-dev python-dev libbz2-dev \
			liblzma-dev libcurl4-openssl-dev g++ libssl-dev autoconf pkg-config \
			libncurses5-dev wget unzip

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