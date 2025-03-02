#!/bin/bash

# Add two parameters to the script, input and output file names for the assembly program
# First parameter is the input file name
# Second parameter is the output file name

# Example: bash executer.bash main main

# Comand sumarizer:
# nasm -f elf64 lib.asm -o lib.o
# nasm -f elf64 -g -o ${output_file}.o ${input_file}
# ld ${output_file}.o lib.o -o ${output_file}
# ./${output_file}

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file.asm> <output_file>"
    exit 1
fi

input_file=$1.asm
output_file=$2

if ! nasm -f elf64 lib.asm -o lib.o; then
    echo "Failed to compile lib.asm"
    exit 1
fi

if ! nasm -f elf64 -g -o ${output_file}.o ${input_file}; then
    echo "Failed to compile ${input_file}"
    exit 1
fi

if ! ld ${output_file}.o lib.o -o ${output_file}; then
    echo "Failed to link object files"
    exit 1
fi

echo "Succfull compiled ${input_file} to ${output_file}.
Running ${output_file}...
-------------------------------------------------
"
./${output_file}
