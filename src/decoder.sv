`timescale 1ns / 1ps

// Decoder routes the Data Bus only (not the instr. bus)
module decoder (
    input  logic [31:0] addr_i,
    input  logic [31:0] mem_data_i,
    input  logic [31:0] switch_data_i,
    input  logic        write_i,
    output logic [31:0] data_o,
    output logic        mem_enable_o,
    output logic        led_enable_o);

    always_comb begin
        led_enable_o = 0;
        mem_enable_o = 0;
        data_o = 32'bx;
   
        case (addr_i[10:9])
            2'b11:   led_enable_o = write_i; // led
            2'b10:   data_o       = switch_data_i; // switch
            default: 
                begin
                     mem_enable_o = write_i; // memory
                     data_o       = mem_data_i; 
                end
        endcase
    end
    
endmodule
