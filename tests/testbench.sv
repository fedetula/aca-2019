`timescale 1ns / 1ps

module testbench;

    logic clk = 0, rst = 1;
    logic [3:0] sw, led;
    
    top dut(.*);
    
    always #(0.5) clk = ~clk;
    
    initial begin
        sw=7;
        #2;
        rst=0;
        #55;
        $finish;
    end
    
endmodule
