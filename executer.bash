#!/bin/bash

# Add two parameters to the script, input and output file names for the assembly program
# First parameter is the input file name
# Second parameter is the output file name

# Example: bash executer.bash z1_64 z1_64

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file.asm> <output_file>"
    exit 1
fi

input_file=$1.asm
output_file=$2

if ! nasm -f elf64 external_proc.asm -o external_proc.o; then
    echo "Failed to compile external_proc.asm"
    exit 1
fi

if ! nasm -f elf64 -g -o ${output_file}.o ${input_file}; then
    echo "Failed to compile ${input_file}"
    exit 1
fi

if ! ld ${output_file}.o external_proc.o -o ${output_file}; then
    echo "Failed to link object files"
    exit 1
fi

echo "Succfull compiled ${input_file} to ${output_file}.
Running ${output_file}...
-------------------------------------------------
"
./${output_file}
