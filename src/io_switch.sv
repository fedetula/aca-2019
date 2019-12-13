`timescale 1ns / 1ps

module io_switch (
    input  logic [3:0]  data_i,
    output logic [31:0] data_o);

    always_comb
       data_o = 32'(data_i);

endmodule
