//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		27/06/2014
// Project Name:		miniCar
// Module Name:		createEn
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		The function of this mode is create a en signal for tempera-
//							ture and humidity sampling toward FPGA.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module createEn(
					clk_in,
					rst_n,
					sample_en
					);
					
input clk_in;
input rst_n;
output sample_en;

wire clk_in;
wire rst_n;
reg sample_en;

reg state;
parameter	IDLE  	= 1'b0,
				Create	= 1'b1;
reg[31:0] cnt_delay;	
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		sample_en <= 40'd0;
		state <= IDLE;
	end
	else
	case(state)
	IDLE:			// wait for 2s
	begin
		cnt_delay <= cnt_delay + 1'b1;
		if (cnt_delay == 32'd20000000)
		begin
			cnt_delay <= 0;
			state <= Create;
		end
	end
	Create:		//	create signal
	begin
		sample_en <= 1'b0;
		cnt_delay <= cnt_delay + 1'b1;
		if (cnt_delay == 32'd10000000)
		begin
			cnt_delay <= 0;
			sample_en <= 1'b1;
		end
		state <= Create;
	end
	endcase
end

endmodule
