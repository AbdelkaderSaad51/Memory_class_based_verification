interface mem_intf #(parameter width=32,Depth_width=16,Add_width=4)(clk);
logic rst,rd_en,wr_en,clear;
logic [width-1:0] Data_in;
logic [Add_width-1:0] Address;
logic [width-1:0] Data_out;
logic Valid_out;
input clk;

modport DUT (input clk, rst, rd_en, wr_en, clear, Data_in, Address,output Data_out, Valid_out);
endinterface