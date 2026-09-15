// and_gate.v - A simple 2-input AND gate module
module and_gate (a, b, out);
    input a, b;
    output out;

    // Perform logical AND operation
    assign out = a & b;
endmodule