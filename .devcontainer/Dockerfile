FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

USER root
RUN wget https://github.com/chapel-lang/chapel/releases/download/1.25.1/chapel-1.25.1.tar.gz
RUN tar xzf chapel-1.25.1.tar.gz
RUN sudo apt-get update -y && sudo apt-get install -y gcc g++ m4 perl python3 python3-pip python3-venv python3-dev bash make mawk git pkg-config cmake llvm-11-dev llvm-11 llvm-11-tools clang-11 libclang-11-dev libclang-cpp11-dev libedit-dev gfortran libnetcdf-dev libnetcdff-dev
RUN cd chapel-1.25.1/ && ./configure && make -j 6 && sudo make install
RUN cd chapel-1.25.1/ && make mason && sudo cp ./bin/linux64-x86_64/mason /usr/local/bin