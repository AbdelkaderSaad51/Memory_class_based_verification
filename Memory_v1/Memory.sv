module Memory #(parameter width=32,Depth_width=16,Add_width=4) (mem_intf.DUT intf);//pass the interface with modport to make the design resepect the modport

//memory array initialization of 16 locations each one is 32 bit width
reg [width-1:0] Mem [Depth_width-1:0];
integer i;

always @(posedge intf.clk or posedge intf.rst)begin
	if(intf.rst)begin
	intf.Data_out<=32'b0;
	intf.Valid_out<=0;
	end
	else begin
		// Clear the memory contents if 'clear' is high
		if(intf.clear)begin
			for (i=0;i<Depth_width-1;i=i+1)begin
		    Mem[i]<=32'b0; 
	        end
		end

        if(intf.wr_en)
         Mem[intf.Address]<=intf.Data_in;

	    if(intf.rd_en && !intf.wr_en)begin
	      intf.Data_out<=Mem[intf.Address]; // Only read if write isn't happening
	      intf.Valid_out<=1'b1;
        end
	end

end
endmodule : Memory