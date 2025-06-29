package Driver_package;
import trans_package::*;//put import inside the package
import Scoreboard_package::*;
import callback1::*;
class driver;

virtual mem_intf vif;
mailbox driver_mailbox;
event stop_event;
bit driver_done;
Scoreboard my_scoreboard;

DriverScoreboardCallback callback;

function new(virtual mem_intf intf_inst,mailbox mailbox_inst,event stop_ev,bit driver_done);
driver_done=0;
vif=intf_inst;

driver_mailbox=mailbox_inst;

stop_event=stop_ev;

endfunction

function void register_callback(DriverScoreboardCallback cb);//why not connect them in the new?
        callback = cb;
    endfunction

task send_trans(Transaction mem_transaction, ref bit driver_done);
	forever begin
	if (stop_event.triggered) begin
        $display("Exiting Driver task...");
        break; // Exit the loop when the stop event is triggered
      end
	

 // Get the transaction from the mailbox
driver_mailbox.get(mem_transaction);
//assign the values taken from sequencer to vif
        vif.rst = mem_transaction.rst;
        vif.rd_en = mem_transaction.rd_en;
        vif.wr_en = mem_transaction.wr_en;
        vif.clear = mem_transaction.clear;
        vif.Data_in = mem_transaction.Data_in;
        vif.Address = mem_transaction.Address;

        // If a callback is registered, send data to the scoreboard via the callback
        if (callback != null) begin
            callback.pass_data_to_scoreboard(mem_transaction.Data_in,mem_transaction.Address);//why did i call the callback function not scoreboard
        end
        else begin
            $display("No callback registered for Driver");
        end

// Wait for a clock cycle to simulate the behavior
@(negedge vif.clk);
driver_done=1;
 

end

endtask : send_trans



endclass : driver
endpackage 

