//////////////////////////////////////////////////////////////////////////////////
// Institutions: 		HUST-EI-TX1105
// Designers: 			Tong.Liu & Weitong.Liang
// 
// Create Date:		27/06/2014
// Project Name:		miniCar
// Module Name:		segOUT
// Target Devices: 	NEXYS 4
// Tool versions: 	ISE 14.6
// Description: 		Use 4-7 seg to display data.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//							None
//
//////////////////////////////////////////////////////////////////////////////////
module	segOUT(
					clk_in,
					rst_n,
					mode_seg_en,
				
					data_in_1,		//DHT-11
					data_in_2,		//speed
					data_in_3,		//distance
					seg_cs,
					seg_db,
					Frame_Data//
					);
				
input clk_in;
input rst_n;
input[2:0] mode_seg_en;
input[31:0] data_in_1, data_in_2, data_in_3;
//test2 wangdongjian
input[7:0] Frame_Data;//
output[7:0] seg_cs;
output[7:0] seg_db;

wire clk_in;
wire rst_n;
wire[2:0] mode_seg_en;
wire[31:0] data_in1, data_in2, data_in3;
reg[7:0] seg_cs;
reg[7:0] seg_db;

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
	begin
		seg_cs <= 8'b0111_1111;
	end
	else
	begin
		seg_cs <= {seg_cs[6:0],seg_cs[7]};
	end
end

always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		SEGOUT <= 8'hFF;
	else
		if (mode_seg_en == 3'b011)				//	DHT-11 Data
			case(seg_cs)		
			8'b0111_1111:		SEGOUT <= {4'h0,data_in_1[7:4]};
			8'b1011_1111:		SEGOUT <= {4'h0,data_in_1[3:0]};
			8'b1101_1111:		SEGOUT <= 8'hFF;
			8'b1110_1111:		SEGOUT <= 8'hFF;
			8'b1111_0111:		SEGOUT <= {4'h0,data_in_1[23:20]};
			8'b1111_1011:		SEGOUT <= {4'h0,data_in_1[19:16]};
			8'b1111_1101:		SEGOUT <= 8'hFF;
			8'b1111_1110:		SEGOUT <= 8'hFF;
			default:				SEGOUT <= 8'hFF;
			endcase
		else if (mode_seg_en == 3'b010)		//	Speed data
			case(seg_cs)		
			8'b0111_1111:		SEGOUT <= {4'h0,Frame_Data[7:4]};//
			8'b1011_1111:		SEGOUT <= {4'h0,Frame_Data[3:0]};//
			8'b1101_1111:		SEGOUT <= 8'hFF;
			8'b1110_1111:		SEGOUT <= 8'hFF;
			8'b1111_0111:		SEGOUT <= {4'h0,data_in_2[23:20]};
			8'b1111_1011:		SEGOUT <= {4'h0,data_in_2[19:16]};
			8'b1111_1101:		SEGOUT <= 8'hFF;
			8'b1111_1110:		SEGOUT <= 8'hFF;
			default:				SEGOUT <= 8'hFF;
			endcase
		else if (mode_seg_en == 3'b001)		// Distance data
			case(seg_cs)		
			8'b0111_1111:		SEGOUT <= {4'h0,data_in_3[7:4]};
			8'b1011_1111:		SEGOUT <= {4'h0,data_in_3[3:0]};
			8'b1101_1111:		SEGOUT <= 8'hFF;
			8'b1110_1111:		SEGOUT <= 8'hFF;
			8'b1111_0111:		SEGOUT <= 8'hFF;
			8'b1111_1011:		SEGOUT <= 8'hFF;
			8'b1111_1101:		SEGOUT <= {4'h0,data_in_3[15:12]};
			8'b1111_1110:		SEGOUT <= {4'h0,data_in_3[11:8]};
			default:				SEGOUT <= 8'hFF;
			endcase
		else if (mode_seg_en == 3'b000)
			SEGOUT <= 8'hFF;
		else
			SEGOUT <= 8'hFF;			
end

reg[7:0] SEGOUT;	
always@(posedge clk_in or negedge rst_n)
begin
	if (!rst_n)
		seg_db <= 8'hFF;
	else
	case(SEGOUT)
	8'h0:		seg_db <= 8'b0000_0011;
	8'h1:		seg_db <= 8'b1001_1111;
	8'h2:		seg_db <= 8'b0010_0101;
	8'h3:		seg_db <= 8'b0000_1101;
	8'h4:		seg_db <= 8'b1001_1001;
	8'h5:		seg_db <= 8'b0100_1001;
	8'h6:		seg_db <= 8'b0100_0001;
	8'h7:		seg_db <= 8'b0001_1111;
	8'h8:		seg_db <= 8'b0000_0001;
	8'h9:		seg_db <= 8'b0000_1001;
	8'hA:		seg_db <= 8'b0001_0001;
	8'hB:		seg_db <= 8'b1100_0001;
	8'hC:		seg_db <= 8'b0110_0011;
	8'hD:		seg_db <= 8'b1000_0101;
	8'hE:		seg_db <= 8'b0110_0001;
	8'hF:		seg_db <= 8'b0111_0001;
	default:	seg_db <= 8'b1111_1111;
	endcase
end	

endmodule
