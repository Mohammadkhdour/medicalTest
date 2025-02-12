# 🏥 MedicalTest - Assembly Language Project

## 📌 Overview
**MedicalTest** is a program written in Assembly Language designed to perform medical test calculations or analysis at a low level. This project demonstrates the use of Assembly for processing medical-related data efficiently.

## 🛠️ Features
- Written entirely in Assembly (x86/x86-64 NASM)
- Efficient processing of medical test data
- Low-level optimization for performance
- Demonstrates direct memory and register manipulation

## 📂 Project Structure
- `midicalTest.asm` - Main Assembly source file containing the implementation
- `README.md` - Documentation for understanding and usage

## 🖥️ Prerequisites
Before running the program, ensure you have:
- **NASM (Netwide Assembler)** installed (`sudo apt install nasm` on Linux)
- **GNU Linker (ld)** for linking (`sudo apt install binutils`)
- A compatible **x86/x86-64** system or an emulator like **DOSBox** (if running 16-bit code)

## 🚀 Installation & Compilation
To assemble and link the program:

```sh
nasm -f elf32 midicalTest.asm -o midicalTest.o
ld -m elf_i386 midicalTest.o -o midicalTest
