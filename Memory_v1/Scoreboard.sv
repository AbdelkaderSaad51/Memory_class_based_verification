package Scoreboard_package;
import trans_package::*;

class Scoreboard;
Transaction captured_trans;
mailbox Scoreboard_mailbox;
int expected_value;
event stop_event;
event start_capture;

function new(mailbox mbox,event stop_ev,event capture);
	Scoreboard_mailbox=mbox;
	stop_event=stop_ev;
	start_capture=capture;
endfunction : new

task compare();
forever begin

            // Check for stop event
            if (stop_event.triggered) begin
                $display("Stopping the Scoreboard...");
                break; // Exit the forever loop
            end
wait(start_capture.triggered());

Scoreboard_mailbox.peek(captured_trans);

  //if(Scoreboard_mailbox.try_peek(captured_trans))begin

  	if(captured_trans.Valid_out)begin
	if(captured_trans.rd_en)begin
		expected_value=get_expected_values(captured_trans.Address);
		if(captured_trans.Data_out !== expected_value)
			$display("Mismatch at Address:%0d expected_value:%0d got:%0d bad job bro",captured_trans.Address,expected_value, captured_trans.Data_out);
		else 
			$display("Match at Address:%0d expected_value:%0d got:%0d good job bro",captured_trans.Address,expected_value, captured_trans.Data_out);
	end
end
  else begin
   if(captured_trans.rst)begin
   	if(captured_trans.Data_out==0)
  	$display("Data_out=%0d during reset as expected",captured_trans.Data_out);
  else 
  	$display("error in reset Data_out=%0d",captured_trans.Data_out);
  end
end


  #2;
end
endtask



function int get_expected_values(int address);
	get_expected_values=address*123+12;
endfunction



endclass : Scoreboard


endpackage : Scoreboard_package