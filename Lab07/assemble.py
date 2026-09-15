import sys
import os

# OP-CODE definitions matching CO2070Assembler.c
OPCODES = {
    "loadi": "00000000",
    "mov":   "00000001",
    "add":   "00000010",
    "sub":   "00000011",
    "and":   "00000100",
    "or":    "00000101",
    "j":     "00000110",
    "beq":   "00000111",
    "lwd":   "00001000",
    "lwi":   "00001001",
    "swd":   "00001010",
    "swi":   "00001011",
    "bne":   "00001100",
    "sll":   "00001101",
}

def val_to_binary(val):
    val = val.strip().upper()
    if val == "X":
        return "00000000"
    
    # Strip R/r prefix if present
    if val.startswith("R"):
        reg_num = val[1:]
        try:
            num = int(reg_num)
            if 0 <= num <= 7:
                return f"{num:08b}"
        except ValueError:
            pass
            
    # Parse hex immediate values (e.g. 0xFF, 0xAA)
    if val.startswith("0X"):
        try:
            num = int(val, 16)
            if 0 <= num <= 255:
                return f"{num:08b}"
        except ValueError:
            pass
            
    # Parse decimal values
    try:
        num = int(val)
        if 0 <= num <= 255:
            return f"{num:08b}"
    except ValueError:
        pass
        
    raise ValueError(f"Invalid operand value: {val}")

def assemble_line(line, line_num):
    # Strip comments
    if "//" in line:
        line = line.split("//")[0]
    line = line.strip()
    if not line:
        return None
        
    # Replace commas with spaces for parsing support
    line = line.replace(",", " ")
    tokens = line.split()
    if not tokens:
        return None
        
    op = tokens[0].lower()
    if op not in OPCODES:
        raise ValueError(f"Line {line_num}: Unknown opcode '{op}'")
        
    op_bin = OPCODES[op]
    args = tokens[1:]
    
    # Process instruction format mapping
    if op in ["mov", "loadi", "lwd", "lwi"]:
        # Format: op RD RS/IMM
        if len(args) != 2:
            raise ValueError(f"Line {line_num}: '{op}' expects 2 operands (got {len(args)})")
        rd, rs_imm = args[0], args[1]
        fld2 = val_to_binary(rd)
        fld1 = val_to_binary("X")
        fld0 = val_to_binary(rs_imm)
        
    elif op in ["swd", "swi"]:
        # Format: op RT RS/IMM
        if len(args) != 2:
            raise ValueError(f"Line {line_num}: '{op}' expects 2 operands (got {len(args)})")
        rt, rs_imm = args[0], args[1]
        fld2 = val_to_binary("X")
        fld1 = val_to_binary(rt)
        fld0 = val_to_binary(rs_imm)
        
    elif op == "j":
        # Format: j IMM
        if len(args) != 1:
            raise ValueError(f"Line {line_num}: 'j' expects 1 operand (got {len(args)})")
        imm = args[0]
        fld2 = val_to_binary(imm)
        fld1 = val_to_binary("X")
        fld0 = val_to_binary("X")
        
    elif op in ["add", "sub", "and", "or", "beq", "bne", "sll"]:
        # Format: op RD RT RS
        if len(args) != 3:
            raise ValueError(f"Line {line_num}: '{op}' expects 3 operands (got {len(args)})")
        rd, rt, rs = args[0], args[1], args[2]
        fld2 = val_to_binary(rd)
        fld1 = val_to_binary(rt)
        fld0 = val_to_binary(rs)
        
    else:
        raise ValueError(f"Line {line_num}: Opcode '{op}' mapping not implemented")
        
    # Return little-endian byte format: FLD0 FLD1 FLD2 OP
    return f"{fld0} {fld1} {fld2} {op_bin}"

def assemble_file(src_path, dest_path):
    print(f"Assembling {src_path} -> {dest_path}...")
    try:
        with open(src_path, "r", encoding="utf-8") as f_in:
            lines = f_in.readlines()
            
        compiled_lines = []
        for idx, line in enumerate(lines, 1):
            try:
                bin_line = assemble_line(line, idx)
                if bin_line:
                    compiled_lines.append(bin_line)
            except ValueError as e:
                print(f"Error assembling line {idx}: {e}")
                sys.exit(1)
                
        with open(dest_path, "w", encoding="utf-8") as f_out:
            for bin_line in compiled_lines:
                f_out.write(bin_line + "\n")
                
        print("Assembly completed successfully!")
    except Exception as e:
        print(f"Failed to assemble file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    src = "test_program_lab6.s"
    dest = "instr_mem_lab6.mem"
    if len(sys.argv) > 1:
        src = sys.argv[1]
    if len(sys.argv) > 2:
        dest = sys.argv[2]
    assemble_file(src, dest)
