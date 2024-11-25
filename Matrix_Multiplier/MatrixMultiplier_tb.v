`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:01:18 12/04/2020
// Design Name:   MatrixMultiplier
// Module Name:   E:/sbu/7/FPGA/ISE codes/Matrix_Multiplier_phase2/MatrixMultiplier_tb.v
// Project Name:  Matrix_Multiplier_phase2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MatrixMultiplier
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MatrixMultiplier_tb;

	// Inputs
	reg data_in;
	reg mem_sel;
	reg clk;
	reg [0:0] row_in;
	reg [0:0] col_in;
	reg [7:0] data;
	reg reset;
	reg [0:0] row_out;
	reg [0:0] col_out;

	// Outputs
	wire [16:0] out;

	// Instantiate the Unit Under Test (UUT)
	MatrixMultiplier uut (
		.data_in(data_in), 
		.mem_sel(mem_sel), 
		.clk(clk), 
		.row_in(row_in), 
		.col_in(col_in), 
		.data(data), 
		.reset(reset), 
		.out(out), 
		.row_out(row_out), 
		.col_out(col_out)
	);

	initial begin
		clk = 1'b0;
		forever begin
			#10 clk = ~clk;
		end
	end
	
	integer i,j,elements;
	
	initial begin
		// Initialize Inputs
		data_in = 1'b0;
		mem_sel = 1'b0;
		row_in = 0;
		col_in = 0;
		data = 0;
		reset = 1'b0;
		row_out = 0;
		col_out = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		elements = $fopen("elements.txt","w");
		for(i=0;i<2;i=i+1)begin		//initialize A
			for(j=0;j<2;j=j+1)begin
				#20
				data_in = 1'b1;
				mem_sel = 1'b0;
				data = $random;
				row_in = i;
				col_in = j;
				if(data>127)begin
					$display("Deraye A[%d%d]= - %d",i,j,~data+8'h01);
					$fdisplay(elements, "Deraye A[%d%d]= - %d",i,j,~data+8'h01);
				end else begin
					$display("Deraye A[%d%d]= %d",i,j,data);
					$fdisplay(elements, "Deraye A[%d%d]= %d",i,j,data);
				end
			end
		end
		for(i=0;i<2;i=i+1)begin  //initialize B
			for(j=0;j<2;j=j+1)begin
				#20
				data_in = 1'b1;
				mem_sel = 1'b1;
				data = $random;
				row_in = i;
				col_in = j;
				if(data>127)begin
					$display("Deraye B[%d%d]= - %d",i,j,~data+8'h01);
					$fdisplay(elements, "Deraye B[%d%d]= - %d",i,j,~data+8'h01);
				end else begin
					$display("Deraye B[%d%d]= %d",i,j,data);
					$fdisplay(elements, "Deraye B[%d%d]= %d",i,j,data);
				end
			end
		end
		#20
		for(i=0;i<2;i=i+1)begin    	//produce C
			for(j=0;j<2;j=j+1)begin
				data_in = 1'b0;
				mem_sel = 1'b0;
				row_in = 0;
				col_in = 0;
				data = 0;
				row_out = i;
				col_out = j;
				#20
				if(out>65536)begin
					$display("Deraye C[%d%d]= - %d",i,j,~out+17'h0001);
					$fdisplay(elements, "Deraye C[%d%d]= - %d",i,j,~out+17'h0001);
				end else begin
					$display("Deraye C[%d%d]= %d",i,j,out);
					$fdisplay(elements, "Deraye C[%d%d]= %d",i,j,out);
				end
			end
		end
		#50
		reset = 1'b1;		//reset A,B,C
		
		$fclose(elements);
		
	end   
endmodule


