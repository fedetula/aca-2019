`timescale 1ns / 1ps

// For now we ignore the address 2LSB (until we extend LW, SW)
module memory32 #(parameter DEPTH=8) (
    input  logic clk,
    // Read ports
    input  logic [DEPTH-1:0] rd_addr1_i, rd_addr2_i, 
    output logic [31:0]      rd_data1_o, rd_data2_o,
    // Write ports
    input  logic             write_i,
    input  logic [31:0]      wr_data_i,
    input  logic [DEPTH-1:0] wr_addr_i);

    logic [31:0] mem[2**(DEPTH-2)];

    always_comb begin
        rd_data1_o = mem[rd_addr1_i[DEPTH-1:2]];
        rd_data2_o = mem[rd_addr2_i[DEPTH-1:2]];
    end
    
    always_ff @(posedge clk)
        if (write_i)
            mem[wr_addr_i[DEPTH-1:2]] <= wr_data_i;

    initial begin
        $readmemh("/home/fedetula/data/hdl/riscv-unicycle-v1/mem_files/fibonacci.mem", mem);
    end
    
endmodule
