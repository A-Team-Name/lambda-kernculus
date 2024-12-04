FROM quay.io/jupyter/base-notebook:latest

# APL Kernel setup
## APL Installation

# root user required for dpkg install
USER root

RUN wget -O apl.deb https://www.dyalog.com/uploads/php/download.dyalog.com/download.php?file=19.0/linux_64_19.0.50027_unicode.x86_64.deb && \
    dpkg -i apl.deb && \
    rm apl.deb

# use httpx 0.27.2 because 0.28.0 has an issue
RUN conda install -y httpx=0.27.2

# change back to original user "jovyan" - from notebook image
USER jovyan

# # APL kernel installation
RUN pip install dyalog-jupyter-kernel

RUN python -m 'dyalog_kernel' install
