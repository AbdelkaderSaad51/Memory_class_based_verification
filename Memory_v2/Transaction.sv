package trans_package;
class Transaction #(parameter width=32,Depth_width=16,Add_width=4);
logic rd_en,wr_en;
logic rst,clear;
rand logic [width-1:0] Data_in;
randc logic [Add_width-1:0] Address;
logic  [width-1:0] Data_out;
logic  Valid_out;
// Constructor
    function new();
        Data_in = 32'b0;
        Address = 4'b0;
        wr_en = 0;
        rd_en = 0;
        clear = 0;
        rst=0;
    endfunction

    //why copy?

    function Transaction copy();
        Transaction new_trans = new();
        new_trans.Data_in = this.Data_in;
        new_trans.Address = this.Address;
        new_trans.wr_en = this.wr_en;
        new_trans.rd_en = this.rd_en;
        new_trans.clear = this.clear;
        new_trans.rst = this.rst;
        new_trans.Data_out = this.Data_out;
        new_trans.Valid_out = this.Valid_out;
        return new_trans;
    endfunction
  
constraint Data_input {
    Data_in dist{[10:1000]:/80,[1001:10000]:/100,[10000:50000]:/30};
}


endclass
endpackage : trans_package