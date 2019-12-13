`timescale 1ns / 1ps

module top(input  logic clk, rst,
           input  logic [3:0] sw,
           output logic [3:0] led);

    // CPU signals
    logic [31:0] inst_addr, inst_data, data_addr, data_out, data_in;
    logic data_write;
    // decoder signals
    logic [31:0] mem_data, switch_data;
    logic mem_enable, led_enable;

    cpu       cpu_inst(.*);

    decoder   decoder_inst(.addr_i(data_addr),
                           .mem_data_i(mem_data),
                           .switch_data_i(switch_data),
                           .write_i(data_write),
                           .data_o(data_in),
                           .mem_enable_o(mem_enable),
                           .led_enable_o(led_enable));

    memory32  memory_inst(.clk(clk), 
                          .rd_addr1_i(inst_addr),
                          .rd_addr2_i(data_addr), 
                          .rd_data1_o(inst_data),
                          .rd_data2_o(mem_data),
                          .write_i(mem_enable),
                          .wr_data_i(data_out),
                          .wr_addr_i(data_addr));

    io_switch switch_inst(.data_i(sw),
                          .data_o(switch_data));

    io_led    led_inst(.clk(clk),
                       .rst(rst),
                       .write(led_enable),
                       .data_i(data_out),
                       .data_o(led));

endmodule
