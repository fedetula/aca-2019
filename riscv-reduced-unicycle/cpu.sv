module cpu(input  logic clk, rst,
           output logic [31:0] inst_addr,
           input  logic [31:0] inst_data,
           output logic [31:0] data_addr,
           output logic [31:0] data_out,
           input  logic [31:0] data_in,
           output logic        data_write);

       typedef enum logic[1:0] {ADD, SUB, AND, OR} alu_op_t;
       typedef enum logic {FROM_RS2, FROM_IMMED} alu_src2_t;
       typedef enum logic {FROM_ALU, FROM_MEM} rf_data_in_t;
       typedef enum logic {BRANCH, SEQUENTIAL} pc_ctrl_t;
       typedef enum logic {INST_BEQ, INST_SEQ} pc_flow_t;

       logic [31:0] pc, rs1_data, rs2_data, rd_data, immed;
       logic [31:0] rf[32];
       logic [4:0] rs1_addr, rs2_addr, rd_addr;
       logic [31:0] alu_in1, alu_in2, alu_out;
       logic zero;
       pc_ctrl_t pc_ctrl;

       // Control signals (also data_write)
       alu_op_t alu_op;
       alu_src2_t alu_src2;
       rf_data_in_t rf_data_in;
       pc_flow_t pc_flow;
       logic rf_write;

       // Instruction Bus
       always_comb inst_addr = pc;
    
       // Data Bus
       always_comb begin
          data_addr = alu_out;
          data_out = rs1_data;
       end 
       
       // Decoder 
       always_comb begin
          rs1_addr = inst_data[19:15];
          rs2_addr = inst_data[24:20];
          rd_addr  = inst_data[11:7];
          immed    = 32'(signed'(inst_data[31:20]));

          alu_op  = ADD;
          alu_src2 = FROM_RS2;
          rf_write = 1;
          data_write = 0;
          rf_data_in = FROM_ALU;
          pc_flow = INST_SEQ;

          case (inst_data) inside
              {7'b0000_000, 5'b?, 5'b?, 3'b000, 5'b?, 7'b0110011}: ;
              {7'b0100_000, 5'b?, 5'b?, 3'b000, 5'b?, 7'b0110011}: alu_op = SUB;
              {7'b0000_000, 5'b?, 5'b?, 3'b111, 5'b?, 7'b0110011}: alu_op = AND;
              {7'b0000_000, 5'b?, 5'b?, 3'b110, 5'b?, 7'b0110011}: alu_op = OR;
              {7'b?       , 5'b?, 5'b?, 3'b000, 5'b?, 7'b0010011}: alu_src2 = FROM_IMMED; // ADDI
              {7'b?       , 5'b?, 5'b?, 3'b010, 5'b?, 7'b0100011}: begin  // SW
                                                                       alu_src2 = FROM_IMMED;
                                                                       rf_write = 0;
                                                                       data_write = 1;
                                                                       immed = 32'(signed'({inst_data[31:25], 
                                                                                            inst_data[11:7]}));
                                                                   end
              {7'b?       , 5'b?, 5'b?, 3'b010, 5'b?, 7'b0000011}: begin  // LW
                                                                       alu_src2 = FROM_IMMED;
                                                                   end
              {7'b?       , 5'b?, 5'b?, 3'b000, 5'b?, 7'b1100011}: begin  // BEQ
                                                                       pc_flow = INST_BEQ;
                                                                       immed = 32'(signed'({inst_data[31], 
                                                                                            inst_data[7], 
                                                                                            inst_data[30:25], 
                                                                                            inst_data[11:8], 
                                                                                            1'b0}));
                                                                   end
          endcase
       end
  
       // PC Controller
       always_comb
           pc_ctrl = (pc_flow == INST_BEQ && zero) ? BRANCH : SEQUENTIAL;

       // PC 
       always_ff @(posedge clk, posedge rst)
           if (rst) pc <= '0;
           else     pc <= (pc_ctrl == BRANCH) ? pc + immed : pc + 4;

       // RF Write
       always_comb rd_data = (rf_data_in == FROM_ALU) ? alu_out : data_in;

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
           alu_in1 = rs1_data;
           alu_in2 = (alu_src2 == FROM_IMMED) ? immed : rs2_data;
           rd_data = 'x;
           case (alu_op) inside
                ADD: alu_out = alu_in1 + alu_in2;
                SUB: alu_out = alu_in1 - alu_in2;
                AND: alu_out = alu_in1 & alu_in2;
                OR:  alu_out = alu_in1 | alu_in2;
           endcase
           zero = (alu_in1 == alu_in2);
       end

endmodule        
