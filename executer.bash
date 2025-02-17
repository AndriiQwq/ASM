#!/bin/bash

# Add two parameters to the script, input and output file names for the assembly program
# First parameter is the input file name
# Second parameter is the output file name
input_file=$1
output_file=$2

nasm -f elf64 external_proc.asm -o external_proc.o

nasm -f elf64 -g -o ${output_file}.o ${input_file}.asm
ld ${output_file}.o external_proc.o -o ${output_file}
# ld -o ${output_file} ${output_file}.o
./${output_file}
