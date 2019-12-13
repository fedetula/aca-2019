`timescale 1ns / 1ps

module io_led (
    input  logic        clk, rst,
    input  logic        write,
    input  logic [31:0] data_i,
    output logic [3:0]  data_o);

    always_ff @(posedge clk)
        if (rst) data_o = '0;
        else
            if (write)
                data_o = data_i[3:0];

endmodule
