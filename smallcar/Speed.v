//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		27/06/2014
// Project Name:		miniCar
// Module Name:		Speed
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		This mode is created for geting the binary speed data of 
//							miniCar
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module Speed(
				clk_in,
				rst_n,
				speed_pulse,
				cnt_pulse
				);
				
input clk_in;
input rst_n;
input speed_pulse;
output[11:0] cnt_pulse;

wire clk_in;
wire rst_n;
wire speed_pulse;
reg[11:0] cnt_pulse;

reg sMode_reg_1, sMode_reg_2;
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		sMode_reg_1 <= 1'b0;
		sMode_reg_2 <= 1'b0;
	end
	else
	begin
		sMode_reg_1 <= speed_pulse;
		sMode_reg_2 <= sMode_reg_1;
	end		
end
wire sMode_pos_pulse = sMode_reg_1 & (~sMode_reg_2);


reg[11:0] cnt_speed;
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		cnt_speed <= 12'd0;
	else
	begin
		if (cnt_1s == 20'd1000_000)
			cnt_speed <= 12'd0;
		else if (sMode_pos_pulse)
			cnt_speed <= cnt_speed + 1'b1;
		else
			;
	end
end

reg[19:0] cnt_1s;
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		cnt_1s <= 20'd0;
	else if (cnt_1s == 20'd1000_000)
		cnt_1s <= 20'd0;
	else
		cnt_1s <= cnt_1s + 1'b1;
end

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		cnt_pulse <= 12'd0;
	else if (cnt_1s == 20'd1000_000)
		cnt_pulse <= cnt_speed;
	else
		cnt_pulse <= cnt_pulse;
end


endmodule

