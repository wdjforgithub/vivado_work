//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		24/06/2014
// Project Name:		miniCar
// Module Name:		getBCDDistData
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This is a mode for getting diatance between miniCar and
//							object.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module getBCDDistData(
						clk_in,
						rst_n,
						time_echo,
						sr_data
						);	
						
input clk_in;
input rst_n;
input time_echo;
output[15:0] sr_data;

wire clk_in;
wire rst_n;
wire time_echo;
reg[15:0] sr_data;

//	This section is an adjustment after we test the miniCar system
reg time_echo_reg;
always@(posedge clk_in)
	time_echo_reg <= time_echo;
wire echo;
assign echo = time_echo_reg;

//	This section is to get the BCD data of distance
reg[15:0] cnt_time;
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		cnt_time <= 32'd0;
	end
	else
		if (echo == 1'b1)	begin
			cnt_time[3:0] <= cnt_time[3:0] + 1'b1;
			if (cnt_time[3:0] == 4'd9)	begin
				cnt_time[3:0] <= 4'd0;
				cnt_time[7:4] <= cnt_time[7:4] + 1'b1;
				if (cnt_time[7:4] == 4'd9)	begin
					cnt_time[7:4] <= 4'd0;
					cnt_time[11:8] <= cnt_time[11:8] + 1'b1;
					if (cnt_time[11:8] == 4'd9)	begin
						cnt_time[11:8] <= 4'd0;
						cnt_time[15:12] <= cnt_time[15:12] + 1'b1;
						if (cnt_time[15:12] == 9)
							cnt_time[15:12] <= 4'd0;
					end
				end
			end
		end
		else
			cnt_time <= 16'd0;
end

//	This section aim to increase the stability of the 4-7 digital seg
reg[15:0] temp1, temp2;
always@(negedge echo or negedge rst_n)
begin
	if (!rst_n)
		temp1 <= 16'd0;
	else
		temp1 <= cnt_time;
end

always@(negedge echo or negedge rst_n)
begin
	if (!rst_n)
		temp2 <= 16'd0;
	else
		if (temp1 - temp2 > 2'b11)
			temp2 <= temp1;
		else
			temp2 <= temp2;
end

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		sr_data <= 16'd0;
	else
		sr_data <= temp2;
end

endmodule


