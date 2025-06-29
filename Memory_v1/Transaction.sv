package trans_package;
class Transaction #(parameter width=32,Depth_width=16,Add_width=4);
logic rst,rd_en,wr_en,clear;
logic [width-1:0] Data_in;
logic [Add_width-1:0] Address;
logic [width-1:0] Data_out;
logic Valid_out;
// Constructor
    function new();
        Data_in = 32'b0;
        Address = 4'b0;
        wr_en = 0;
        rd_en = 0;
        clear = 0;
        rst=0;
    endfunction
endclass
endpackage : trans_package