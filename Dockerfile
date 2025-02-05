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

# Copy in lambda calculus kernel code
COPY lambda-kernculus/ ./lambda-kernel/lambda-kernculus
COPY setup.py ./lambda-kernel/setup.py

# Give big permission so all can run (should probably be more specific)
RUN chmod -R 777 ./lambda-kernel/lambda-kernculus
RUN chmod -R 777 ./lambda-kernel/setup.py

# Install requirements for the kernel
RUN pip install -e ./lambda-kernel

# Switch to Jovyan user to install kernel for Jupyter
USER jovyan
RUN jupyter kernelspec install --user ./lambda-kernel/lambda-kernculus/lambda-calculus
RUN pip install dyalog-jupyter-kernel

RUN python -m 'dyalog_kernel' install
