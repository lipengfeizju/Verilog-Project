`timescale 1ns / 1ps

module combiner(
	input rotary_a,
	input rotary_b,
	input press,
	input RST_LCD,
	input clk,
	input [7:0] rx_data_in,
	input rx_int_in,
	output reg [127:0] line1_buffer,line2_buffer,
	output reg [7:0] rx_data_out,
	output reg rx_int_out,
	output  reg [2:0] data = 3'b111
    );
	
		
		reg [31:0] buffer = "0000";
		reg [23:0] buffer2 = 0;
		reg [3:0] counter = 0;
		
	wire 	rotary_event;
	wire	rotary_left;
	
	rotary_decode MYINPUT 
	(.clk(clk), 
	.rotary_a(rotary_a), 
	.rotary_b(rotary_b),
	.rotary_event(rotary_event), 
	.rotary_left(rotary_left));
	

	always@(negedge rx_int_in)
	begin
		if(RST_LCD)
		begin
			buffer2<=0;
			buffer <= "0000";
			counter <= 0;
		end
		else
		begin
			buffer2[7:0] <= rx_data_in;
			buffer2[15:8] <= buffer2[7:0];
			buffer2[23:16] <= buffer2[15:8];
			buffer[7:0] <= buffer2[23:16];
			buffer[15:8] <= buffer[7:0];
			buffer[23:16] <= buffer[15:8];
			buffer[31:24] <= buffer[23:16];
			if(counter >= 7)
				counter <= 1;
			else
				counter <= counter+1;
		end
	
	end
			
	
	reg [127:0] buffer_line1,buffer_line2,buffer_line3,buffer_line4;
	
	wire [7:0] A,A1;
	wire [3:0] ONES, TENS,ONES1, TENS1;
	wire [1:0] HUNDREDS,HUNDREDS1;
	binary_to_BCD myconvert (
		.A(A),
		.ONES(ONES), 
		.TENS(TENS),
		.HUNDREDS(HUNDREDS)
	);
	binary_to_BCD myconvert1 (
		.A(A1),
		.ONES(ONES1), 
		.TENS(TENS1),
		.HUNDREDS(HUNDREDS1)
	);
	assign A = buffer2[15:8];
	assign A1 = buffer2[7:0];
/*	
//	assign A = buffer2[7:0];
	reg [2:0] state,next_state,restate;
	always@(posedge clk)
	begin
		if(RST_LCD)
			state = 0;
		else
			state = next_state;
		
	end
	
	reg [7:0] NUM1 = 0,NUM2 = 0,NUM3 = 0,NUM4 = 0;
	always@(posedge clk)
	begin
		case(state)
		3'b000:begin 
		if(buffer == "0000" || (counter < 7)) 
			begin 
				NUM1 = 0;NUM2 = 0;NUM3 = 0;next_state =0;restate = 0;
			end
		else
			begin
			if(buffer2[16] == 1) begin A = buffer2[15:8];next_state = 3'b101;restate = 3'b001;end
			else begin A = buffer2[15:8];next_state = 3'b101;restate = 3'b010; end
			end 
		end
		3'b001:begin NUM1 = HUNDREDS; NUM2 = TENS; NUM3 = ONES; next_state = 3'b001;end
		3'b010:begin NUM1 = TENS; NUM2 = ONES;next_state = 3'b011;restate = 3'b101; end
		3'b011:begin A = buffer2[7:0];next_state = 3'b101;restate = 3'b100; end
		3'b100:begin NUM3 = TENS; NUM4 = ONES; next_state = 3'b100; end 
		3'b101:next_state = 3'b110;
		3'b110:next_state = 3'b111;
		3'b111:next_state = restate;
		endcase
	end
*/	
		
	always@(posedge clk)
	begin
		buffer_line1 = "STUDENT   ID:   ";
		if(buffer == "0000" || (counter < 7))
		begin
			buffer_line2 = "WAITING FOR CARD";
			buffer_line3 = "     WAITING    ";
			buffer_line4 = "    FOR CARD    ";
			//data = 3'b111;
		end
		else
		begin
			buffer_line2[127:64] = "  314010";
			buffer_line2[63:32] = buffer;
			buffer_line2[31:0] = "    ";
			if(buffer2[16] == 1)
			begin
				buffer_line3 = "    WELCOME!    ";
				buffer_line4[127:56] = "   SEAT: ";
				buffer_line4[55:48] =  8'b00110000+HUNDREDS;
				buffer_line4[47:40] =  8'b00110000+TENS;
				buffer_line4[39:32] =  8'b00110000+ONES;
				buffer_line4[31:0] = "    ";
				if(~buffer[0]) data = 3'b101;
				else begin 
				if (buffer[3]) data = 3'b011;
				else	data = 3'b001;
				end
			end
			else
			begin
				buffer_line3 = "    GOODBYE!    ";				
				buffer_line4[127:72] = "TIME : ";
				buffer_line4[71:64] = 8'b00110000+TENS;
				buffer_line4[63:56] = 8'b00110000+ONES;
				buffer_line4[55:32] = "MIN";
				buffer_line4[31:24] = 8'b00110000+TENS1;
				buffer_line4[23:16] = 8'b00110000+ONES1;
				buffer_line4[15:0] = "S ";
				if(~buffer[0]) data = 3'b100;
				else begin 
				if (buffer[3]) data = 3'b010;
				else	data = 3'b000;
				end
			end
		end
	end
	

	
	reg [1:0] line = 1;
	
	always @(posedge clk or posedge press)
     begin
		if(press)
			line <= 0;
		else 
		if (rotary_event)
			if (rotary_left) 
				line <= line + 1; 
			else
				line <= line - 1;
	end
	
	
	always@(posedge clk)
	begin
		case( line ) 
		2'b00:begin line1_buffer <= buffer_line1;  line2_buffer <= buffer_line2; end
		2'b01:begin line1_buffer <= buffer_line2;  line2_buffer <= buffer_line3; end
		2'b10:begin line1_buffer <= buffer_line3;  line2_buffer <= buffer_line4; end
		2'b11:begin line1_buffer <= buffer_line4;  line2_buffer <= buffer_line1; end
		endcase
	end



endmodule


