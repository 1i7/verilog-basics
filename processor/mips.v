/**
 * Program counter - go to next value on each clock.
 *
 * @param clk - clock
 *
 * @param pc_next - next value for program counter
 * @param pc - program counter
 */
module pc(input clk, 
    input [31:0] pc_next, output reg [31:0] pc);

	 always @(posedge clk)
	     pc <= pc_next;
	 
endmodule

/**
 * Register file.
 * 
 * @param clk - clock
 *
 * @param ra1 - read address for source register 1
 * @param ra2 - read address for source register 2
 * @param rd1 - read data for source register 1
 * @param rd2 - read data for source register 2
 *
 * @param we - write enabled flag
 * @param wa - write address for destination register
 * @param wd - write data for destination register
 */
module regfile(input clk, 
    /* Read 2 registers */
    input [4:0] ra1, input [4:0] ra2,
	 output [31:0] rd1, output [31:0] rd2,
	 
	 /* Write register */
	 input we, input [4:0] wa, input [31:0] wd
	 );
	 
	 reg [31:0] rf [31:0];
	 
	 always @(posedge clk)
	     if(we) rf[wa] <= wd;
		  
	 assign rd1 = ra1 ? rf[ra1] : 0; // reg[0] is zero
	 assign rd2 = ra2 ? rf[ra2] : 0; // reg[0] is zero	 
endmodule

/**
 * Datapath and contoller implementation - connect program counter, 
 * register file and handle instructions.
 *
 * @param clk - clock
 *
 * @param pc - program counter
 * @param instr - current instruction value
 *
 * @param dmem_we - data memory write enabled flag
 * @param dmem_addr - data memory access address for read/write
 * @param dmem_wd - data memory write data
 * @param dmem_rd - data memory read data
 */
module datapath_and_controller(input clk,
    output [31:0] pc, input [31:0] instr,
	 
	 /* Data memory manipulation */
	 output reg dmem_we, 
	 output reg [31:0] dmem_addr, 
	 output reg [31:0] dmem_wd, 
	 input [31:0] dmem_rd);
	 
	 reg [31:0] pc_next;
	 
	 // Program counter
	 pc pcount(clk, pc_next, pc);
	 	 
	 // Register file
	 reg [4:0] rf_ra1, rf_ra2;
	 wire [31:0] rf_rd1, rf_rd2;
	 
	 reg rf_we;
	 reg [4:0] rf_wa;
	 reg [31:0] rf_wd;
	 
	 regfile rf(clk, 
	     rf_ra1, rf_ra2, rf_rd1, rf_rd2,
		  rf_we, rf_wa, rf_wd);
		  
	 // Instructions
	 wire [5:0] instr_op;
	 assign instr_op = instr[31:26]; // 6 bits
	 
	 // R-type
	 wire [4:0] instr_rtype_rs;
	 wire [4:0] instr_rtype_rt;
	 wire [4:0] instr_rtype_rd;
	 //wire [4:0] instr_rtype_shamt;
	 wire [5:0] instr_rtype_funct;
	 
	 assign instr_rtype_rs = instr[25:21]; // 5 bits
	 assign instr_rtype_rt = instr[20:16]; // 5 bits
	 assign instr_rtype_rd = instr[15:11]; // 5 bits
	 //assign instr_rtype_shamt = instr[10:6]; // 5 bits - not used here
	 assign instr_rtype_funct = instr[5:0]; // 6 bits
	 
	 // I-type
	 wire [4:0] instr_itype_rs;
	 wire [4:0] instr_itype_rt;
	 wire [15:0] instr_itype_imm;
	 
	 assign instr_itype_rs = instr[25:21]; // 5 bits
	 assign instr_itype_rt = instr[20:16]; // 5 bits
	 assign instr_itype_imm = instr[15:0]; // 16 bits
	 
	 // J-type
	 wire [25:0] instr_jtype_addr;
	 assign instr_jtype_addr = instr[25:0]; // 26 bits
	 
	 parameter INSTR_OP_LW    = 6'b100011;
	 parameter INSTR_OP_SW    = 6'b101011;
	 parameter INSTR_OP_ADDI  = 6'b001000;
	 parameter INSTR_OP_BEQ   = 6'b000100;
	 parameter INSTR_OP_J     = 6'b000010;	 
	 parameter INSTR_OP_RTYPE = 6'b000000;
	 
	 parameter INSTR_RTYPE_FUNCT_ADD = 6'b100000;
	 parameter INSTR_RTYPE_FUNCT_SUB = 6'b100010;
	 
	 always @(*)
	 begin
	     pc_next = pc + 4;
		  rf_we = 0;
		  dmem_we = 0;
		  
		  // set default values
		  rf_ra1 = 0;
		  rf_ra2 = 0;
		  rf_wa = 0;
		  rf_wd = 0;
		  
		  dmem_addr = 0;
		  dmem_wd = 0;
		  
	     case(instr_op)
		  INSTR_OP_RTYPE:
		      case(instr_rtype_funct)
				
				INSTR_RTYPE_FUNCT_ADD:
		      begin
		          // add $s0, $s1, $s2
				    // $s0 = $s1 + $s2
					 // rs=$s1, rt=$s2, rd=$s0
				
				    // rf_rd1 would immediately receive rs register value
				    rf_ra1 = instr_rtype_rs;
					 
					 // rf_rd2 would immediately receive rt register value
				    rf_ra2 = instr_rtype_rt;
				
				    // write data to rd register on next clock
				    rf_wa = instr_rtype_rd;
				    rf_wd = rf_rd1 + rf_rd2;
				    rf_we = 1;
		      end
				
				INSTR_RTYPE_FUNCT_SUB:
		      begin
		          // sub $s0, $s1, $s2
				    // $s0 = $s1 - $s2
					 // rs=$s1, rt=$s2, rd=$s0
				
				    // rf_rd1 would immediately receive rs register value
				    rf_ra1 = instr_rtype_rs;
					 
					 // rf_rd2 would immediately receive rt register value
				    rf_ra2 = instr_rtype_rt;
				
				    // write data to rd register on next clock
				    rf_wa = instr_rtype_rd;
				    rf_wd = rf_rd1 - rf_rd2;
				    rf_we = 1;
		      end
				
				endcase
		  
		  INSTR_OP_LW:
		  begin
		      // lw $s0, 4 ($0)
				// load word (32 bit) from memory at addr $0 + 4 to register $s0
				// rs=$0, rt=$s0, imm=4
				
				// rf_rd1 would immediately receive rs register value
				rf_ra1 = instr_itype_rs;
				
				// read data from memory, dmem_rd would immediately receive value at dmem_addr
				dmem_addr = rf_rd1 + instr_itype_imm;
				
				// write data to rt register at next clock
				rf_wa = instr_itype_rt;
				rf_wd = dmem_rd;
				rf_we = 1;
		  end
		  
		  INSTR_OP_SW:
		  begin
		      // sw $s0, 4 ($0)
				// save word (32 bit) to memory at addr $0 + 4 from register $s0
				// rs=$0, rt=$s0, imm=4
				
				// rf_rd1 would immediately receive rs register value
				rf_ra1 = instr_itype_rs;
				
				// rf_rd2 would immediately receive rt register value
				rf_ra2 = instr_itype_rt;
				
				// write data to memory at next clock
				dmem_addr = rf_rd1 + instr_itype_imm;
				dmem_wd = rf_rd2;
				dmem_we = 1;
		  end
		  
		  INSTR_OP_ADDI:
		  begin
		      // addi $s0, $s1, 4
				// $s0 = $s1 + 4
				// rs=$s0, rt=$s1, imm=4
				
				// rf_rd1 would immediately receive rs register value
				rf_ra1 = instr_itype_rs;
				
				// write data to rt register at next clock
				rf_wa = instr_itype_rt;
				rf_wd = rf_rd1 + instr_itype_imm;
				rf_we = 1;
		  end
		  
		  INSTR_OP_BEQ:
		  begin
		      // beq $s0, $s1, 4
				// jump to 4 ((!)absolute value for simplicity) if $s0 == $s1
				// rs=$s0, rt=$s1, imm=4
				
				// rf_rd1 would immediately receive rs register value
				rf_ra1 = instr_itype_rs;
				
				// rf_rd2 would immediately receive rt register value
				rf_ra2 = instr_itype_rt;
				
				if(rf_rd1 == rf_rd2)
				    pc_next = instr_itype_imm;
		  end
		  
		  INSTR_OP_J:
		  begin
		      // j 4
				// jump to 4 ((!)absolute value for simplicity)
				// addr = 4
				
				pc_next = instr_jtype_addr;
		  end
		  endcase
	 end
endmodule

/**
 * MIPS processor core implementation.
 *
 * @param clk - clock
 *
 * @param pc - program counter
 * @param instr - current instruction value
 *
 * @param dmem_we - data memory write enabled flag
 * @param dmem_addr - data memory access address for read/write
 * @param dmem_wd - data memory write data
 * @param dmem_rd - data memory read data
 */
module mips(input clk, 
    output [31:0] pc, input [31:0] instr,
	 
	 /* Data memory manipulation */
	 output dmem_we, output [31:0] dmem_addr, 
	 output [31:0] dmem_wd, 
	 input [31:0] dmem_rd);
	 
	 datapath_and_controller dpctrl(clk, 
	     pc, instr, 
		  dmem_we, dmem_addr, dmem_wd, dmem_rd);

endmodule
