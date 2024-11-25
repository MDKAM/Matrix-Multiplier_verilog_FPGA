`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:59:11 12/04/2020 
// Design Name: 
// Module Name:    MatrixMultiplier 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MatrixMultiplier #(parameter W_IN=8, W_OUT=17, ROWS_A=2, COLS_A=2, ROWS_B=2, COLS_B=2)(
	 input data_in,
    input mem_sel,
	 input clk,
    input [0:0] row_in,
    input [0:0] col_in,
    input signed [W_IN-1:0] data,
    input reset,
    output reg signed [W_OUT-1:0] out,
    input [$clog2(ROWS_A)-1:0] row_out,
    input [$clog2(COLS_B)-1:0] col_out
    );
	reg signed [W_IN-1:0] a [0:ROWS_A-1][0:COLS_A-1];
	reg signed [W_IN-1:0] b [0:ROWS_B-1][0:COLS_B-1];
	reg signed [W_OUT-1:0] c [0:ROWS_A-1][0:COLS_B-1];

	integer i,j,k;
	reg flag = 1'b0;

	always @(posedge clk)begin
	
		if (data_in==1 && reset==0)begin
			flag = 1'b1;
			if (!mem_sel)begin	//initialize a
				a[row_in][col_in]<=data;
			end else begin		//initialize b
				b[row_in][col_in]<=data;
			end
		end else if (data_in==0 && reset==0 && flag ==1'b1) begin
			flag = 1'b0;
			for (i=0 ; i<ROWS_A ; i=i+1)begin
				for (j=0 ; j<COLS_B ; j=j+1)begin
					c[i][j]=0;
					for (k=0 ; k<COLS_A ; k=k+1)begin
					c[i][j]= c[i][j]+a[i][k]*b[k][j];
					end
				end
			end
			out=c[row_out][col_out];
		end else if (reset)begin
			flag = 1'b1;
			for (i=0 ; i<ROWS_A ; i=i+1)begin
				for (j=0 ; j<COLS_A ; j=j+1)begin
					a[i][j]<=0;
				end
			end
			for (i=0 ; i<ROWS_B ; i=i+1)begin
				for (j=0 ; j<COLS_B ; j=j+1)begin
					b[i][j]<=0;
				end
			end
			for (i=0 ; i<ROWS_A ; i=i+1)begin
				for (j=0 ; j<COLS_B ; j=j+1)begin
					c[i][j]=0;
				end
			end
			out=c[row_out][col_out];
		end
		out=c[row_out][col_out];
	end

endmodule
