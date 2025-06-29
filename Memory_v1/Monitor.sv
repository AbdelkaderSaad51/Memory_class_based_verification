package Monitor_package;
import trans_package::*;

class Monitor;
virtual mem_intf vif;
Transaction monitor_trans;
mailbox monitor_mailbox;
event stop_event;
event send_to_scoreboard;

function new(virtual mem_intf intf_inst,mailbox mailbox_inst,event stop_ev,event mr_event);
vif=intf_inst;
monitor_trans=new();
monitor_mailbox=mailbox_inst;
stop_event=stop_ev;
send_to_scoreboard=mr_event;
endfunction

task start_monitor();
forever begin
@(negedge vif.clk);

if (stop_event.triggered) begin
        $display("Exiting Monitor task...");
        break; // Exit the loop when the stop event is triggered
    end
monitor_trans.Address=vif.Address;
monitor_trans.Data_in=vif.Data_in;

monitor_trans.rd_en=vif.rd_en;
monitor_trans.wr_en=vif.wr_en;

monitor_trans.rst=vif.rst;
monitor_trans.clear=vif.clear;
monitor_trans.Valid_out=vif.Valid_out;
monitor_trans.Data_out=vif.Data_out;
#2;
 // Put the captured transaction into the mailbox
monitor_mailbox.put(monitor_trans);
->send_to_scoreboard;


if(vif.rd_en && vif.Valid_out)begin

	$display("During Read opertion:the value of the Data_out =%0d and its Address =%0d and Valid out =%0d",monitor_trans.Data_out,monitor_trans.Address,monitor_trans.Valid_out);
            end
if(vif.wr_en)begin
	$display("During write operation:the vaulue of Data_in=%0d and its Address =%0d",monitor_trans.Data_in,monitor_trans.Address,vif);
            end
if(vif.rst)begin
        $display("During reset:Data_out=%0d and Valid out =%0d",monitor_trans.Data_out, monitor_trans.Valid_out);
end


end	

    endtask

endclass : Monitor


endpackage 


