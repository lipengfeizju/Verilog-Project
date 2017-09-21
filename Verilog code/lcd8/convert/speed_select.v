`timescale 1ns / 1ps

module speed_select(clk,rst_n,bps_start,clk_bps);
 
input clk; // 50MHz主时钟
input rst_n;  //低电平复位信号
input bps_start;  //接收到数据后，波特率时钟启动信号置位
output clk_bps;   // clk_bps的高电平为接收或者发送数据位的中间采样点
 
parameter bps9600    = 5207,    //波特率为9600bps
          bps19200   = 2603,    //波特率为19200bps
          bps38400   = 1301,    //波特率为38400bps
          bps57600   = 867, //波特率为57600bps
          bps115200  = 433; //波特率为115200bps
 
parameter bps9600_2 = 2603,
          bps19200_2 = 1301,
          bps38400_2 = 650,
          bps57600_2 = 433,
          bps115200_2 = 216; 
 
reg[12:0] bps_para;  //分频计数最大值
reg[12:0] bps_para_2;    //分频计数的一半
reg[12:0] cnt;           //分频计数
reg clk_bps_r;           //波特率时钟寄存器
 
//----------------------------------------------------------
reg[2:0] uart_ctrl;  // uart波特率选择寄存器
//----------------------------------------------------------
 
always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
           uart_ctrl <= 3'd0;   //默认波特率为9600bps
       end
    else begin
           case (uart_ctrl)  //波特率设置
              3'd0:  begin
                     bps_para <= bps9600;
                     bps_para_2 <= bps9600_2;
                     end
              3'd1:  begin
                     bps_para <= bps19200;
                     bps_para_2 <= bps19200_2;
                     end
              3'd2:  begin
                     bps_para <= bps38400;
                     bps_para_2 <= bps38400_2;
                     end
              3'd3:  begin
                     bps_para <= bps57600;
                     bps_para_2 <= bps57600_2;
                     end
              3'd4:  begin
                     bps_para <= bps115200;
                     bps_para_2 <= bps115200_2;
                     end
              default: ;
              endcase
       end
end
 
always @ (posedge clk or negedge rst_n)
    if(!rst_n) cnt <= 13'd0;
    else if(cnt<bps_para && bps_start) cnt <= cnt+1'b1;  //波特率时钟计数启动
    else cnt <= 13'd0;
 
always @ (posedge clk or negedge rst_n)
    if(!rst_n) clk_bps_r <= 1'b0;
    else if(cnt==bps_para_2 && bps_start) clk_bps_r <= 1'b1;    // clk_bps_r高电平为接收或者发送数据位的中间采样点
    else clk_bps_r <= 1'b0;
 
assign clk_bps = clk_bps_r;
 
endmodule