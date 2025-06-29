import Enviroment_package::*;
module top;
bit clk;

initial begin
	forever
	#2 clk=~clk;
end


mem_intf intf1(clk);
virtual mem_intf vif;
 // Instantiate the Memory module, passing the interface
Memory #(.width(32), .Depth_width(16), .Add_width(4)) mem(.intf(intf1));
Enviroment my_Env;

initial begin
	vif=intf1;
	my_Env=new(vif);
	my_Env.run();
end

endmodule