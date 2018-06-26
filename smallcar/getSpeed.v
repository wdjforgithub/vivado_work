//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		27/06/2014
// Project Name:		miniCar
// Module Name:		getSpeed
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This mode is created for geting the speed data of miniCar
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module getSpeed	(
						clk_in,
						rst_n,
						speed_pulse,
						speed_data
						);

input clk_in;
input rst_n;
input[1:0] speed_pulse;
output[31:0] speed_data;

wire[11:0] cnt_pulse_left;
wire[11:0] cnt_pulse_right;
Speed					U1	(
							.clk_in(clk_in),
							.rst_n(rst_n),
							.speed_pulse(speed_pulse[1]),
							.cnt_pulse(cnt_pulse_left)
							);
							
Speed					U2	(
							.clk_in(clk_in),
							.rst_n(rst_n),
							.speed_pulse(speed_pulse[0]),
							.cnt_pulse(cnt_pulse_right)
							);
							
wire[7:0] left_data, right_data;
wire[1:0] h1, h2;	
bin2BCD			B1	(
						.A(cnt_pulse_left[8:1]),
						.TENS_ONES(left_data),
						.HUNDREDS(h1)
						);
				
bin2BCD			B2	(
						.A(cnt_pulse_right[8:1]),
						.TENS_ONES(right_data),
						.HUNDREDS(h2)
						);

assign speed_data =  {8'hFF,left_data,8'hFF,right_data};

endmodule
