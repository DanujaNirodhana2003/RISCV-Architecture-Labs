# Windows-friendly Python replacement for generate_memory_image.sh
# Usage: python generate_memory_image.py sample_program.s

import sys
import os

def main():
    if len(sys.argv) != 2:
        print("Usage: python generate_memory_image.py <assembly_file>")
        sys.exit(1)

    assembly_file = sys.argv[1]
    machine_file = assembly_file + ".machine"

    if not os.path.exists(machine_file):
        print(f"Error: Machine code file '{machine_file}' not found. Did you run the assembler first?")
        sys.exit(1)

    # Read the machine file and write the formatted bytes to instr_mem.mem
    with open(machine_file, "r") as f_in, open("instr_mem.mem", "w") as f_out:
        for line in f_in:
            line = line.strip()
            if not line:
                continue
            
            # Split the 32-bit line into four 8-bit bytes
            byte3 = line[0:8]
            byte2 = line[8:16]
            byte1 = line[16:24]
            byte0 = line[24:32]
            
            # Write in little-endian order (byte0 byte1 byte2 byte3) separated by spaces
            f_out.write(f"{byte0} {byte1} {byte2} {byte3}\n")

    print("Instruction memory content 'instr_mem.mem' successfully generated!")

if __name__ == "__main__":
    main()
