#!/bin/bash

# Add two parameters to the script, input and output file names for the assembly program
# First parameter is the input file name
# Second parameter is the output file name
input_file=$1
output_file=$2

nasm -f elf -o ${output_file}.o ${input_file}.asm
ld -m elf_i386 -s -o ${output_file} ${output_file}.o
./${output_file}