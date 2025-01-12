# Dockerfile
FROM mcr.microsoft.com/devcontainers/python:1-3.12-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y \
    pandoc \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    texlive-fonts-extra \
    gfortran \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Set Fortran compiler environment variable
ENV FC=gfortran

# Install Python packages
RUN pip install --no-cache-dir \
    matplotlib \
    jupyter \
    pandas \
    numpy \
    pyinstaller \
    scipy \
    meson \
    pytest \
    hypothesis \
    pooch \
    plotly \
    tabulate \
    openpyxl \
    nbstripout

# Set up nbstripout for the repository
# This gives an error because it is not a git repository
# RUN nbstripout --install