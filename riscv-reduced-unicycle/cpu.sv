module cpu(input  logic clk, rst,
           input  logic [31:0] inst_data,
           output logic [31:0] inst_addr);

       typedef enum logic[1:0] {ADD, SUB, AND, OR} alu_op_t;

       logic [31:0] pc, rs1_data, rs2_data, rd_data;
       logic [31:0] rf[32];
       logic [4:0] rs1_addr, rs2_addr, rd_addr;
       alu_op_t alu_op;
       logic rf_write;

       always_comb inst_addr = pc;
     
       // Decoder 
       always_comb begin
          rs1_addr = inst_data[19:15];
          rs2_addr = inst_data[24:20];
          rd_addr  = inst_data[11:7];

          alu_op  = ADD;
          rf_write = 1;

          case (inst_data) inside
              {7'b0000_000, 5'b?, 5'b?, 3'b000, 5'b?, 7'd51}: alu_op = ADD;
              {7'b0100_000, 5'b?, 5'b?, 3'b000, 5'b?, 7'd51}: alu_op = SUB;
              {7'b0000_000, 5'b?, 5'b?, 3'b111, 5'b?, 7'd51}: alu_op = AND;
              {7'b0000_000, 5'b?, 5'b?, 3'b110, 5'b?, 7'd51}: alu_op = OR;
          endcase
       end
   
       // PC 
       always_ff @(posedge clk, posedge rst)
           if (rst) pc <= '0;
           else     pc <= pc + 4;

       // RF Write
       always_ff @(posedge clk)
           if (rd_addr != '0 && rf_write)
               rf[rd_addr] <= rd_data;

       // RF Read
       always_comb begin
           rs1_data = rf[rs1_addr];
           rs2_data = rf[rs2_addr];
       end

       // ALU
       always_comb begin
           rd_data = 'x;
           case (alu_op) inside
                ADD: rd_data = rs1_data + rs2_data;
                SUB: rd_data = rs1_data - rs2_data;
                AND: rd_data = rs1_data & rs2_data;
                OR:  rd_data = rs1_data | rs2_data;
           endcase
       end

endmodule        
