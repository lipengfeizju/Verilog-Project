`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:50:28 11/02/2016 
// Design Name: 
// Module Name:    lcd_driver 
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
module lcd_driver(	clk,
							reset,
//							he,
//							v_sync,
							data0,
							data1,
						//	data2,
							data3,
							data4,
						/*	data5,
							data6,*/
							data7,
						//	data8,
							data9,
						//	data_no,
							data_in,
							data_out,
							lcd_data,
							rst,
							cs,
							rs,
							wr,
							rd,
//							addr

	
	rst_n,rs232_rx,rs232_tx,test_pin,
						RST_LCD,lcd_e,lcd_rs,lcd_rw,lcd_db,
						rotary_a,rotary_b,press
    );
	input clk;
	
	
//	input clk; // 50MHz主时钟
	input rst_n;  //低电平复位信号
	input rs232_rx;   // RS232接收数据信号
	output rs232_tx;  //  RS232发送数据信号
	output[7:0] test_pin;

	input RST_LCD;
    
	output lcd_e;
	output lcd_rs;
	output lcd_rw;
	output [7:0] lcd_db;

	input rotary_a;
	input rotary_b;
	input press; 
	
	wire [2:0] data;
/*	
my_uart_top convert1 
(
	//.(clk)clk
	//.(rst_n)rst_n,
	.(rs232_rx)rs232_rx,
	.(rs232_tx)rs232_tx,
	.(test_pin)test_pin,
	.(RST_LCD)RST_LCD,
	.(lcd_e)lcd_e,
	.(lcd_rs)lcd_rs,
	.(lcd_rw)lcd_rw,
	.(lcd_db)lcd_db,
	.(rotary_a)rotary_a,
	.(rotary_b)rotary_b,
	.(press)press,
	.(data)data
	);
*/

my_uart_top convert1 (clk,rst_n,rs232_rx,rs232_tx,test_pin,
						RST_LCD,lcd_e,lcd_rs,lcd_rw,lcd_db,
						rotary_a,rotary_b,press,data
						);
	
	
	input reset;
//	input he;
//	input v_sync;
	output [15:0]data0;
	output [15:0]data1;
//	output [15:0]data2;
	output [15:0]data3;
	output [15:0]data4;
/*	output [15:0]data5;
	output [15:0]data6;*/
	output [15:0]data7;
//	output [15:0]data8;
	output [15:0]data9;
//	output [15:0]data_no;
	output [15:0]data_in;
	output [15:0]data_out;
	
	
	
	
	output [15:0]lcd_data;
	output rst;
	output cs;
	output rs;
	output wr;
	output rd;
//	output [14:0]addr;
	
	reg [7:0]addr0;
	reg [7:0]addr1;
//	reg [7:0]addr2;
	reg [7:0]addr3;
	reg [7:0]addr4;
/*	reg [7:0]addr5;
	reg [7:0]addr6;*/
	reg [7:0]addr7;
//	reg [7:0]addr8;
	reg [7:0]addr9;
//	reg [7:0]addr_no;
	reg [7:0]addr_in;
	reg [7:0]addr_out;
	
	reg [15:0] lcd_data;
	reg rst;
	reg cs;
	reg rs;
	reg wr;
	reg rd;
	
	reg[9:0] count_i;
	reg[9:0] count_i2;
	reg[9:0] count_h;
	reg[9:0] count_h2;
	
	reg[1:0] count_ri;
	reg[1:0] count_rh;
//	reg[19:0] count_v;
	reg [31:0] lcd_counter;
   reg [31:0] lcd_counter_end;
	reg [7:0] state;
   reg [7:0] restate;
	
	reg[1:0] buffer;
	reg[1:0] buffer2;
	
	reg in_out;
	reg in_out2;
	
//	reg[3:0]	 count;
	reg[3:0]	 flag;
	
//	reg v_sync;
	
	
	rom0  rom0(.a(addr0),.spo(data0));
	rom1	rom1(.a(addr1),.spo(data1));
//	rom2  rom2(.a(addr2),.spo(data2));
	rom3	rom3(.a(addr3),.spo(data3));
	rom4  rom4(.a(addr4),.spo(data4));
/*	rom5	rom5(.a(addr5),.spo(data5));
	rom6  rom6(.a(addr6),.spo(data6));*/
	rom7	rom7(.a(addr7),.spo(data7));
//	rom8  rom8(.a(addr8),.spo(data8));
	rom9	rom9(.a(addr9),.spo(data9));
//	rom_no	rom_no(.a(addr_no),.spo(data_no));
	rom_in	rom_in(.a(addr_in),.spo(data_in));
	rom_out	rom_out(.a(addr_out),.spo(data_out));
	
//	wire [15:0]LCD_CMD_INI[0:32];\
    wire[15:0]LCD_CMD_INI[0:134];	
	wire [15:0]LCD_CMD_WIN[0:16];
//	wire [65:0] CS_INI = 66'b010101010101010101010101010101010101010101010101010101010101010101;	
//	wire [65:0] RS_INI = 66'b000011001100110011001100110011001100110011001100110011000000110011;
//	wire [65:0] WR_INI = 66'b010101010101010101010101010101010101010101010101010101010101010101;

	wire [267:0] CS_INI = 268'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;	
	wire [267:0] RS_INI = 268'b0011111100110011111111111111111111111111111111111111111100111111111111111100111111111111111111001100111111001111110011001111111111110011001111110011001111110011111100111111110011111111001111111111111111111111111111111100111111111111111111111111111111110011001100110000;
	wire [267:0] WR_INI = 268'b0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101;
	
//	wire [33:0] CS_WIN = 34'b0101010101010101010101010101010101;
//	wire [33:0] RS_WIN = 34'b0011001100110011001100110011001100; 
//	wire [33:0] WR_WIN = 34'b0101010101010101010101010101010101;

	wire [21:0] CS_WIN = 34'b0000000000000000000000;
	wire [21:0] RS_WIN = 34'b0011111111001111111100; 
	wire [21:0] WR_WIN = 34'b0101010101010101010101;
	
//	assign LCD_CMD_INI[0] = 16'h1100;
//	assign LCD_CMD_INI[1] = 16'hC000;
//	assign LCD_CMD_INI[2] = 16'h0086;
//	assign LCD_CMD_INI[3] = 16'hC001;
//	assign LCD_CMD_INI[4] = 16'h0000;
//	assign LCD_CMD_INI[5] = 16'hC002;
//	assign LCD_CMD_INI[6] = 16'h0086;
//	assign LCD_CMD_INI[7] = 16'hC003;
//	assign LCD_CMD_INI[8] = 16'h0000;
//	assign LCD_CMD_INI[9] = 16'hC100;
//	assign LCD_CMD_INI[10] = 16'h0040;
	
//	assign LCD_CMD_INI[11] = 16'hC200;
//	assign LCD_CMD_INI[12] = 16'h0021;
//	assign LCD_CMD_INI[13] = 16'hC202;
//	assign LCD_CMD_INI[14] = 16'h0002;
//	assign LCD_CMD_INI[15] = 16'hB600;
//	assign LCD_CMD_INI[16] = 16'h0030;
//	assign LCD_CMD_INI[17] = 16'hB602;
//	assign LCD_CMD_INI[18] = 16'h0030;
//	assign LCD_CMD_INI[19] = 16'hC700;
//	assign LCD_CMD_INI[20] = 16'h007D;
//	assign LCD_CMD_INI[21] = 16'h3600;
//	assign LCD_CMD_INI[22] = 16'h0000;
//	assign LCD_CMD_INI[23] = 16'h3A00;
//	assign LCD_CMD_INI[24] = 16'h0066;//0066 0077
//	assign LCD_CMD_INI[25] = 16'h0C00;
//	assign LCD_CMD_INI[26] = 16'h0050;//0050 0070
//	assign LCD_CMD_INI[27] = 16'h2900;
//	assign LCD_CMD_INI[28] = 16'h2C00;
//	assign LCD_CMD_INI[29] = 16'h3A00;
//	assign LCD_CMD_INI[30] = 16'h0055;//0055 0077
//	assign LCD_CMD_INI[31] = 16'h3600;
//	assign LCD_CMD_INI[32] = 16'h0000;
    assign LCD_CMD_INI[0] = 16'hFF; // EXTC Command Set enable register 
    assign LCD_CMD_INI[1] = 16'hFF; 
    assign LCD_CMD_INI[2] = 16'h98; 
    assign LCD_CMD_INI[3] = 16'h06; 
    assign LCD_CMD_INI[4] = 16'hBA; // SPI Interface Setting 
    assign LCD_CMD_INI[5] = 16'hE0; 
    assign LCD_CMD_INI[6] = 16'hBC; // GIP 1 
    assign LCD_CMD_INI[7] = 16'h03; 
    assign LCD_CMD_INI[8] = 16'h0F; 
    assign LCD_CMD_INI[9] = 16'h63; 
    assign LCD_CMD_INI[10] = 16'h69; 
    assign LCD_CMD_INI[11] = 16'h01; 
    assign LCD_CMD_INI[12] = 16'h01; 
    assign LCD_CMD_INI[13] = 16'h1B; 
    assign LCD_CMD_INI[14] = 16'h11; 
    assign LCD_CMD_INI[15] = 16'h70; 
    assign LCD_CMD_INI[16] = 16'h73; 
    assign LCD_CMD_INI[17] = 16'hFF; 
    assign LCD_CMD_INI[18] = 16'hFF; 
    assign LCD_CMD_INI[19] = 16'h08; 
    assign LCD_CMD_INI[20] = 16'h09; 
    assign LCD_CMD_INI[21] = 16'h05; 
    assign LCD_CMD_INI[22] = 16'h00;
    assign LCD_CMD_INI[23] = 16'hEE; 
    assign LCD_CMD_INI[24] = 16'hE2; 
    assign LCD_CMD_INI[25] = 16'h01; 
    assign LCD_CMD_INI[26] = 16'h00;
    assign LCD_CMD_INI[27] = 16'hC1; 
    assign LCD_CMD_INI[28] = 16'hBD; // GIP 2 
    assign LCD_CMD_INI[29] = 16'h01; 
    assign LCD_CMD_INI[30] = 16'h23; 
    assign LCD_CMD_INI[31] = 16'h45; 
    assign LCD_CMD_INI[32] = 16'h67; 
    assign LCD_CMD_INI[33] = 16'h01; 
    assign LCD_CMD_INI[34] = 16'h23; 
    assign LCD_CMD_INI[35] = 16'h45; 
    assign LCD_CMD_INI[36] = 16'h67; 
    assign LCD_CMD_INI[37] = 16'hBE; // GIP 3 
    assign LCD_CMD_INI[38] = 16'h00; 
    assign LCD_CMD_INI[39] = 16'h22; 
    assign LCD_CMD_INI[40] = 16'h27; 
    assign LCD_CMD_INI[41] = 16'h6A; 
    assign LCD_CMD_INI[42] = 16'hBC; 
    assign LCD_CMD_INI[43] = 16'hD8; 
    assign LCD_CMD_INI[44] = 16'h92; 
    assign LCD_CMD_INI[45] = 16'h22; 
    assign LCD_CMD_INI[46] = 16'h22; 
    assign LCD_CMD_INI[47] = 16'hC7; // Vcom 
    assign LCD_CMD_INI[48] = 16'h1E;
    assign LCD_CMD_INI[49] = 16'hED; // EN_volt_reg 
    assign LCD_CMD_INI[50] = 16'h7F; 
    assign LCD_CMD_INI[51] = 16'h0F; 
    assign LCD_CMD_INI[52] = 16'h00; 
    assign LCD_CMD_INI[53] = 16'hC0; // Power Control 1
    assign LCD_CMD_INI[54] = 16'hE3; 
    assign LCD_CMD_INI[55] = 16'h0B; 
    assign LCD_CMD_INI[56] = 16'h00;
    assign LCD_CMD_INI[57] = 16'hFC;
    assign LCD_CMD_INI[58] = 16'h08; 
    assign LCD_CMD_INI[59] = 16'hDF; // Engineering Setting 
    assign LCD_CMD_INI[60] = 16'h00; 
    assign LCD_CMD_INI[61] = 16'h00; 
    assign LCD_CMD_INI[62] = 16'h00; 
    assign LCD_CMD_INI[63] = 16'h00; 
    assign LCD_CMD_INI[64] = 16'h00; 
    assign LCD_CMD_INI[65] = 16'h02; 
    assign LCD_CMD_INI[66] = 16'hF3; // DVDD Voltage Setting 
    assign LCD_CMD_INI[67] = 16'h74; 
    assign LCD_CMD_INI[68] = 16'hB4; // Display Inversion Control 
    assign LCD_CMD_INI[69] = 16'h00; 
    assign LCD_CMD_INI[70] = 16'h00; 
    assign LCD_CMD_INI[71] = 16'h00; 
    assign LCD_CMD_INI[72] = 16'hF7; // 4816'h854
    assign LCD_CMD_INI[73] = 16'h81; 
    assign LCD_CMD_INI[74] = 16'hB1; // Frame Rate 
    assign LCD_CMD_INI[75] = 16'h00; 
    assign LCD_CMD_INI[76] = 16'h10; 
    assign LCD_CMD_INI[77] = 16'h14; 
    assign LCD_CMD_INI[78] = 16'hF1; // Panel Timing Control 
    assign LCD_CMD_INI[79] = 16'h29; 
    assign LCD_CMD_INI[80] = 16'h8A; 
    assign LCD_CMD_INI[81] = 16'h07; 
    assign LCD_CMD_INI[82] = 16'hF2; //Panel Timing Control 
    assign LCD_CMD_INI[83] = 16'h40; 
    assign LCD_CMD_INI[84] = 16'hD2; 
    assign LCD_CMD_INI[85] = 16'h50; 
    assign LCD_CMD_INI[86] = 16'h28; 
    assign LCD_CMD_INI[87] = 16'hC1; // Power Control 2 
    assign LCD_CMD_INI[88] = 16'h17;
    assign LCD_CMD_INI[89] = 16'h85; 
    assign LCD_CMD_INI[90] = 16'h85; 
    assign LCD_CMD_INI[91] = 16'h20; 
    assign LCD_CMD_INI[92] = 16'hE0; 
    assign LCD_CMD_INI[93] = 16'h00; //P1 
    assign LCD_CMD_INI[94] = 16'h0C; //P2 
    assign LCD_CMD_INI[95] = 16'h15; //P3 
    assign LCD_CMD_INI[96] = 16'h0D; //P4 
    assign LCD_CMD_INI[97] = 16'h0F; //P5 
    assign LCD_CMD_INI[98] = 16'h0C; //P6 
    assign LCD_CMD_INI[99] = 16'h07; //P7 
    assign LCD_CMD_INI[100] = 16'h05; //P8 
    assign LCD_CMD_INI[101] = 16'h07; //P9 
    assign LCD_CMD_INI[102] = 16'h0B; //P10 
    assign LCD_CMD_INI[103] = 16'h10; //P11 
    assign LCD_CMD_INI[104] = 16'h10; //P12 
    assign LCD_CMD_INI[105] = 16'h0D; //P13 
    assign LCD_CMD_INI[106] = 16'h17; //P14 
    assign LCD_CMD_INI[107] = 16'h0F; //P15 
    assign LCD_CMD_INI[108] = 16'h00; //P16 
    assign LCD_CMD_INI[109] = 16'hE1; 
    assign LCD_CMD_INI[110] = 16'h00; //P1 
    assign LCD_CMD_INI[111] = 16'h0D; //P2 
    assign LCD_CMD_INI[112] = 16'h15; //P3 
    assign LCD_CMD_INI[113] = 16'h0E; //P4 
    assign LCD_CMD_INI[114] = 16'h10; //P5 
    assign LCD_CMD_INI[115] = 16'h0D; //P6 
    assign LCD_CMD_INI[116] = 16'h08; //P7 
    assign LCD_CMD_INI[117] = 16'h06; //P8 
    assign LCD_CMD_INI[118] = 16'h07; //P9 
    assign LCD_CMD_INI[119] = 16'h0C; //P10 
    assign LCD_CMD_INI[120] = 16'h11; //P11 
    assign LCD_CMD_INI[121] = 16'h11; //P12 
    assign LCD_CMD_INI[122] = 16'h0E; //P13 
    assign LCD_CMD_INI[123] = 16'h17; //P14 
    assign LCD_CMD_INI[124] = 16'h0F; //P15 
    assign LCD_CMD_INI[125] = 16'h00; //P16
    assign LCD_CMD_INI[126] = 16'h35; //Tearing Effect ON 
    assign LCD_CMD_INI[127] = 16'h00; 
    assign LCD_CMD_INI[128] = 16'h36; 
    assign LCD_CMD_INI[129] = 16'h60; 
    assign LCD_CMD_INI[130] = 16'h3A; 
    assign LCD_CMD_INI[131] = 16'h55; 
    assign LCD_CMD_INI[132] = 16'h11; //Exit Sleep 
    assign LCD_CMD_INI[133] = 16'h29; // Display On 

 
	
//	assign LCD_CMD_WIN[0] = 16'h2a00;
//	assign LCD_CMD_WIN[1] = 16'h00; //00
//	assign LCD_CMD_WIN[2] = 16'h2a01;
//	assign LCD_CMD_WIN[3] = 16'h00; //00
//	assign LCD_CMD_WIN[4] = 16'h2a02;
//	assign LCD_CMD_WIN[5] = 16'h01; //03
//	assign LCD_CMD_WIN[6] = 16'h2a03;
//	assign LCD_CMD_WIN[7] = 16'hdf; //20
//	assign LCD_CMD_WIN[8] = 16'h2b00;
//	assign LCD_CMD_WIN[9] = 16'h00; //00
//	assign LCD_CMD_WIN[10] = 16'h2b01;
//	assign LCD_CMD_WIN[11] = 16'h00; //00
//	assign LCD_CMD_WIN[12] = 16'h2b02;
//	assign LCD_CMD_WIN[13] = 16'h01; //01
//	assign LCD_CMD_WIN[14] = 16'h2b03;
//	assign LCD_CMD_WIN[15] = 16'hdf; //e0
//	assign LCD_CMD_WIN[16] = 16'h2c00;
	
	
	assign LCD_CMD_WIN[0] = 16'h2a;
	assign LCD_CMD_WIN[1] = 16'h00; //00
	assign LCD_CMD_WIN[2] = 16'h00; //00
	assign LCD_CMD_WIN[3] = 16'h03; //03
	assign LCD_CMD_WIN[4] = 16'h54; //55
	
	assign LCD_CMD_WIN[5] = 16'h2b;
	assign LCD_CMD_WIN[6] = 16'h00; //00
	assign LCD_CMD_WIN[7] = 16'h00; //00
	assign LCD_CMD_WIN[8] = 16'h01; //01
	assign LCD_CMD_WIN[9] = 16'hde; //df
	
	assign LCD_CMD_WIN[10] = 16'h2c;

	

	
	
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			state <= 0;
			rd <= 1;
			cs <= 1;
			rs <= 1;
			wr <= 1;
         restate <= 0;
			lcd_counter <= 0;
			buffer <= data[2:1];
			in_out <= data[0];
		end
		else begin
			case(state)
				0:begin
					cs <= 1;
               state <= 100;
               restate <= 1;
               lcd_counter_end <= 2500000;
				//	buffer <=3;
				//	in_out <= 0;
            end
            1:begin
               rst <= 0;
               state <= 100;
               restate <= 2;
               lcd_counter_end <= 2500000;
            end
            2:begin
               rst <= 1;
               state <= 100;
               restate <= 3;
               lcd_counter_end <= 7000000;
					count_i <= 0;
					count_h <= 0;
					
				//	v_sync <= 1;
					
            end
				
				3:begin
					if(count_i == 134) begin
						count_i <= 0;
						state <= 8;
					end
					else begin
						lcd_data <= LCD_CMD_INI[count_i];
						cs <= CS_INI[267-count_i*2];
						rs <= RS_INI[267-count_i*2];
						wr <= WR_INI[267-count_i*2];
						state <= 5;
						restate <= 4;
					end
				end
				4:begin
					cs <= CS_INI[267-count_i*2 - 1];
					rs <= RS_INI[267-count_i*2 - 1];
					wr <= WR_INI[267-count_i*2 - 1];
					count_i <= count_i + 1;
					state <= 5;
					restate <= 3;
					if(count_i == 133 )begin
						state <= 100;
						lcd_counter_end <= 2500000;
					end
					else if(count_i == 134) begin
						state <= 100;
						lcd_counter_end <= 2500000;
					end
					
//					else if(count_i == 28) begin
//						state <= 100;
//						lcd_counter_end <= 2000000;
//					end
				end
				
				5:begin
					state <= 6;
				end
				
				6:begin
					state <= 7;
				end
				
				7:begin
					state <= restate;
				end
				
				8:begin
					if(count_i == 11) begin
						count_i <= 0;
						count_h <= 0;
					/*	if(v_sync == 1)
							lcd_data <= 0;*/
						
						addr0 <= 0;
						addr1 <= 0;
					//	addr2 <= 0;
						addr3 <= 0;
						addr4 <= 0;
					/*	addr5 <= 0;
						addr6 <= 0;*/
						addr7 <= 0;
					//	addr8 <= 0;
						addr9 <= 0;
					//	addr_no <= 0;
						addr_in <= 0;
						addr_out <= 0;
						
						count_ri <= 0;
						count_rh <= 0;
						
						count_i2 <= 0;
						count_h2 <= 0;
					//	state <= 51;// tape
					//	state <= 53;// block
					//	state <= 55;// motion_block
						if(buffer == 3)
							state <= 71;
						else
							state <= 61;// picture
						
						buffer2 <= buffer;
						in_out2 <= in_out;
						
					end
					else begin
						lcd_data <= LCD_CMD_WIN[count_i];
						cs <= CS_WIN[21-count_i*2];
						rs <= RS_WIN[21-count_i*2];
						wr <= WR_WIN[21-count_i*2];
						state <= 5;
						restate <= 9;
					end
				end
				9:begin
					cs <= CS_WIN[21-count_i*2 - 1];
					rs <= RS_WIN[21-count_i*2 - 1];
					wr <= WR_WIN[21-count_i*2 - 1];
					count_i <= count_i + 1;
					state <= 5;
					restate <= 8;
					if(count_i == 10) begin
						state <= 100;
						lcd_counter_end <= 2500000;
					end
					if(count_i == 11) begin
						state <= 100;
						lcd_counter_end <= 2500000;
					end
					
//					else if(count_i == 28) begin
//						state <= 100;
//						lcd_counter_end <= 2000000;
//					end
				end

				61:begin

					if((count_i == 853)&&(count_h == 479))
					begin
						state <= 67;
					//	restate <= 69;
					end
					
					else if((count_i == 853)&&(count_h != 479)&&((count_h < 100)||((count_h >= 164)&&(count_h < 240))||(count_h >= 304))) 
					begin
						count_i <= 0;
						count_i2 <= 0;
						count_ri <= 0;
				

						state <= 61;
					
						count_h <= count_h + 1;
					end
					
					else if((count_i == 853)&&(count_rh != 3)&&(count_h != 479)&&(count_h >= 100)&&(count_h < 164)) 
					begin
						count_i <= 0;
						count_i2 <= 0;
						count_ri <= 0;
						
						addr0 <= addr0 - 15;
						addr1 <= addr1 - 15;
					//	addr2 <= addr2 - 15;
						addr3 <= addr3 - 15;
						addr4 <= addr4 - 15;
					/*	addr5 <= addr5 - 15;
						addr6 <= addr6 - 15;*/
						addr7 <= addr7 - 15;
					//	addr8 <= addr8 - 15;
						addr9 <= addr9 - 15;
						
					/*	if(count_rh == 3)
						begin
						state <= 63;
						addr <= 75*(count_h2+2)-1;
						count_h2 <= count_h2 + 1;

						end
						if(count_h == 100)
						begin
							count_h <= 0;
							state <= 5;
							restate <= 7;
						end*/
						state <= 61;
						
						count_rh <= count_rh +1;
						count_h <= count_h + 1;
					end					
					
					else if((count_i == 853)&&(count_rh == 3)&&(count_h != 479)&&(count_h >= 100)&&(count_h < 164)) 
					begin
						count_i <= 0;
						count_i2 <= 0;
						count_ri <= 0;
				

						state <= 61;
						addr0 <= addr0 + 1;
						addr1 <= addr1 + 1;
					//	addr2 <= addr2 + 1;
						addr3 <= addr3 + 1;
						addr4 <= addr4 + 1;
					/*	addr5 <= addr5 + 1;
						addr6 <= addr6 + 1;*/
						addr7 <= addr7 + 1;
					//	addr8 <= addr8 + 1;
						addr9 <= addr9 + 1;
						count_h2 <= count_h2 + 1;

					/*	if(count_h == 100)
						begin
							count_h <= 0;
							state <= 5;
							restate <= 7;
						end*/
						
						count_rh <= count_rh +1;
						count_h <= count_h + 1;
					end
					
					else if((count_i == 853)&&(count_rh != 3)&&(count_h != 479)&&(count_h >= 240)&&(count_h < 304)) 
					begin
						count_i <= 0;
						count_i2 <= 0;
						count_ri <= 0;
						
						if(in_out == 1)
							addr_in <= addr_in - 15;
						else
							addr_out <= addr_out - 15; 
						
						state <= 61;
						
						count_rh <= count_rh +1;
						count_h <= count_h + 1;
					end
					
					else if((count_i == 853)&&(count_rh == 3)&&(count_h != 479)&&(count_h >= 240)&&(count_h < 304)) 
					begin
						count_i <= 0;
						count_i2 <= 0;
						count_ri <= 0;
				

						state <= 61;
						
						if(in_out == 1)
							addr_in <= addr_in + 1;
						else
							addr_out <= addr_out + 1;
						count_h2 <= count_h2 + 1;

					/*	if(count_h == 100)
						begin
							count_h <= 0;
							state <= 5;
							restate <= 7;
						end*/
						
						count_rh <= count_rh +1;
						count_h <= count_h + 1;
					end
				
					else begin
						if(count_h < 100)
						begin
							lcd_data <= 16'hffff;
							state <= 5;
							restate <= 63;
						end
						else if((count_h >= 100) && (count_h < 164))
						begin
							if(count_i < 270)
							begin
								lcd_data <= 16'hffff;
								state <= 5;
								restate <= 63;
							end
							else
							begin
								if(buffer == 0)begin
									if(count_i2 < 15)
									begin
										lcd_data <= data3;
										state <= 5;
										restate <= 62;
									end
									else if((count_i2 >= 15)&&(count_i2 < 30))
									begin
										lcd_data <= data0;
										state <= 5;
										restate <= 62;
									end
									else if((count_i2 >= 30)&&(count_i2 < 45))
									begin
										lcd_data <= data4;
										state <= 5;
										restate <= 62;
									end
									else if((count_i2 >= 45)&&(count_i2 < 60))
									begin
										lcd_data <= data1;
										state <= 5;
										restate <= 62;
									end								
									else
									begin
										lcd_data <= 16'hffff;
										state <= 5;
										restate <= 63;
									end
								end
								
								else if(buffer == 1)begin
									if(count_i2 < 15)
									begin
										lcd_data <= data3;
										state <= 5;
										restate <= 62;
									end
									else if((count_i2 >= 15)&&(count_i2 < 30))
									begin
										lcd_data <= data4;
										state <= 5;
										restate <= 62;
									end
									else if((count_i2 >= 30)&&(count_i2 < 45))
									begin
										lcd_data <= data7;
										state <= 5;
										restate <= 62;
									end
									else if((count_i2 >= 45)&&(count_i2 < 60))
									begin
										lcd_data <= data9;
										state <= 5;
										restate <= 62;
									end								
									else
									begin
										lcd_data <= 16'hffff;
										state <= 5;
										restate <= 63;
									end
								end
								else if(buffer == 2)begin
									if(count_i2 < 15)
									begin
										lcd_data <= data3;
										state <= 5;
										restate <= 62;
									end
									else if((count_i2 >= 15)&&(count_i2 < 30))
									begin
										lcd_data <= data9;
										state <= 5;
										restate <= 62;
									end
									else if((count_i2 >= 30)&&(count_i2 < 45))
									begin
										lcd_data <= data4;
										state <= 5;
										restate <= 62;
									end
									else if((count_i2 >= 45)&&(count_i2 < 60))
									begin
										lcd_data <= data0;
										state <= 5;
										restate <= 62;
									end								
									else
									begin
										lcd_data <= 16'hffff;
										state <= 5;
										restate <= 63;
									end
								end
							end
						end
						
						else if((count_h >= 240) && (count_h < 304))
						begin
							if(count_i < 297)
							begin
								lcd_data <= 16'hffff;
								state <= 5;
								restate <= 63;
							end
							else
							begin
								if(count_i2 < 15)
								begin
									if(in_out == 1)
										lcd_data <= data_in;
									else
										lcd_data <= data_out;
									
									state <= 5;
									restate <= 66;
								end
					
								
								else
								begin
									lcd_data <= 16'hffff;
									state <= 5;
									restate <= 63;
								end
							end
						end
						else
						begin
							lcd_data <= 16'hffff;
							state <= 5;
							restate <= 63;
						end
						
						cs <= 0;
						rs <= 1;
						wr <= 0;

					end
				end
				
				62:begin
					cs <= 0;
					rs <= 1;
					wr <= 1;
					
					if(count_ri == 3)
					
					begin
						if(buffer == 0)begin
							if(count_i2 < 15)
								addr3 <= addr3 + 1;
							else if((count_i2 >= 15)&&(count_i2 < 30))
								addr0 <= addr0 + 1;
							else if((count_i2 >= 30)&&(count_i2 < 45))
								addr4 <= addr4 + 1;
							else if((count_i2 >= 45)&&(count_i2 < 60))
								addr1 <= addr1 + 1;
						/*	else if((count_i2 >= 60)&&(count_i2 < 75))
								addr1 <= addr1 + 1;
							else if((count_i2 >= 75)&&(count_i2 < 90))
								addr0 <= addr0 + 1;*/
						end
						else if(buffer == 1)begin
							if(count_i2 < 15)
								addr3 <= addr3 + 1;
							else if((count_i2 >= 15)&&(count_i2 < 30))
								addr4 <= addr4 + 1;
							else if((count_i2 >= 30)&&(count_i2 < 45))
								addr7 <= addr7 + 1;
							else if((count_i2 >= 45)&&(count_i2 < 60))
								addr9 <= addr9 + 1;
						/*	else if((count_i2 >= 60)&&(count_i2 < 75))
								addr1 <= addr1 + 1;
							else if((count_i2 >= 75)&&(count_i2 < 90))
								addr0 <= addr0 + 1;*/
						end
						else if(buffer == 2)begin
							if(count_i2 < 15)
								addr3 <= addr3 + 1;
							else if((count_i2 >= 15)&&(count_i2 < 30))
								addr9 <= addr9 + 1;
							else if((count_i2 >= 30)&&(count_i2 < 45))
								addr4 <= addr4 + 1;
							else if((count_i2 >= 45)&&(count_i2 < 60))
								addr0 <= addr0 + 1;
						/*	else if((count_i2 >= 60)&&(count_i2 < 75))
								addr1 <= addr1 + 1;
							else if((count_i2 >= 75)&&(count_i2 < 90))
								addr0 <= addr0 + 1;*/
						end
						count_i2 <= count_i2 + 1;
					end
					
					count_ri <= count_ri + 1;
					count_i <= count_i + 1;
					
					state <= 5;
					restate <= 61;
					
//					else if(count_i == 28) begin
//						state <= 100;
//						lcd_counter_end <= 2000000;
//					end
				end
				
				63:begin
					cs <= 0;
					rs <= 1;
					wr <= 1;
					
					count_i <= count_i + 1;
					
					state <= 5;
					restate <= 61;
				end
				
				64:begin
							
						case(flag)
						0:begin
							lcd_data <= data0;
							state <= 5;
							restate <= 62;
							if(count_ri == 3)
								addr0 <= addr0 + 1;
						end
						1:begin
							lcd_data <= data1;
							state <= 5;
							restate <= 62;
							if(count_ri == 3)
								addr1 <= addr1 + 1;
						end
					/*	2:begin
							lcd_data <= data2;
							state <= 5;
							restate <= 62;
							if(count_ri == 3)
								addr2 <= addr2 + 1;
						end*/
						3:begin
							lcd_data <= data3;
							state <= 5;
							restate <= 62;
							if(count_ri == 3)
								addr3 <= addr3 + 1;
						end
						4:begin
							lcd_data <= data4;
							state <= 5;
							restate <= 62;
							if(count_ri == 3)
								addr4 <= addr4 + 1;
						end
					/*	5:begin
							lcd_data <= data5;
							state <= 5;
							restate <= 62;
							if(count_ri == 3)
								addr5 <= addr5 + 1;
						end
						6:begin
							lcd_data <= data6;
							state <= 5;
							restate <= 62;
							if(count_ri == 3)
								addr6 <= addr6 + 1;
						end
						7:begin
							lcd_data <= data7;
							state <= 5;
							restate <= 62;
							if(count_ri == 3)
								addr7 <= addr7 + 1;
						end
						8:begin
							lcd_data <= data8;
							state <= 5;
							restate <= 62;
							if(count_ri == 3)
								addr8 <= addr8 + 1;
						end
						9:begin
							lcd_data <= data9;
							state <= 5;
							restate <= 62;
							if(count_ri == 3)
								addr9 <= addr9 + 1;
						end*/
						endcase
				end
				
			/*	65:begin
						if(((count_i2 == 15)||((count_i2 == 30))||(count_i2 == 45)||(count_i2 == 60)||(count_i2 == 75)||(count_i2 == 90)||(count_i2 == 105)||(count_i2 == 120)||(count_i2 == 135)) && (count_ri == 0))
							begin
								addr0 <= 15 * count_h2;
								addr1 <= 15 * count_h2;
							//	addr2 <= 15 * count_h2;
								addr3 <= 15 * count_h2;
								addr4 <= 15 * count_h2;
							/*	addr5 <= 15 * count_h2;
								addr6 <= 15 * count_h2;
								addr7 <= 15 * count_h2;
								addr8 <= 15 * count_h2;
								addr9 <= 15 * count_h2;
							end	
						state <= 5;
						restate <= 61;
						
					end*/
					
				66:begin
					cs <= 0;
					rs <= 1;
					wr <= 1;
					
					if(count_ri == 3)
					
					begin
						if(in_out == 1)
							addr_in <= addr_in + 1; 
						else
							addr_out <= addr_out + 1;
						
						count_i2 <= count_i2 + 1;
					end
					
					count_ri <= count_ri + 1;
					count_i <= count_i + 1;
					
					state <= 5;
					restate <= 61;
					
//					else if(count_i == 28) begin
//						state <= 100;
//						lcd_counter_end <= 2000000;
//					end
				end
				
				67:begin
					state <= 68;
				end
				
				68:begin
					buffer <= data[2:1];
					in_out <= data[0];
					state <= 69;
				end
				
				69:begin
						if((buffer != buffer2) || (in_out != in_out2))
							state <= 0;
						else
							state <= 68;
				end
				
				71:begin
						if((count_i == 853)&&(count_h == 479))
						begin
							state <= 67;
						//	restate <= 69;
						end					
						
						else if((count_i == 853)&&(count_h != 479)) 
						begin
							count_i <= 0;

							state <= 71;
							
							count_h <= count_h + 1;
						end					
					
				
						else begin
						
							lcd_data <= 16'hffff;
							state <= 5;
							restate <= 73;
						
							cs <= 0;
							rs <= 1;
							wr <= 0;
						end
					end
				
				
				73:begin
						cs <= 0;
						rs <= 1;
						wr <= 1;
						
						count_i <= count_i + 1;
						
						state <= 5;
						restate <= 71;
					end
					
				100:begin
				
					lcd_counter<=lcd_counter+1;
					if(lcd_counter>=lcd_counter_end)
					begin
					state<=restate;
					lcd_counter<=0;
					end
					else
					state<=state;
				end
				
				default:state<=0;
			endcase
		end
	end


//TODO... ...



endmodule

