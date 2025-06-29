package Scoreboard_package;
import trans_package::*;
import callback1::*;
class Scoreboard extends DriverScoreboardCallback;

mailbox Scoreboard_mailbox;
int expected_value;
event stop_event;
event start_capture;
Transaction captured_trans;
logic [31:0] memory_array_monitor[logic[3:0]];
logic [31:0] memory_array_driver [logic[3:0]];
int i;

function new(mailbox mbox,event stop_ev,event capture);
	Scoreboard_mailbox=mbox;
	stop_event=stop_ev;
	start_capture=capture;
endfunction : new

// Overriding the callback function to receive data from the driver
    virtual function void pass_data_to_scoreboard(logic [31:0] data,logic[3:0] address);
       memory_array_driver[address]=data;
    endfunction


    // Task to capture transactions from Monitor

task compare();
    int error_count = 0;
forever begin

            // Check for stop event
            if (stop_event.triggered) begin
                $display("Stopping the Scoreboard...");
                break; // Exit the forever loop
            end

wait(start_capture.triggered());
Scoreboard_mailbox.peek(captured_trans);
memory_array_monitor[captured_trans.Address]=captured_trans.Data_in;



    $display("Checking data at address %h: Monitor Data = %h, Driver Data = %h",
             captured_trans.Address, memory_array_monitor[captured_trans.Address], memory_array_driver[captured_trans.Address]);

    if (memory_array_monitor[captured_trans.Address] === memory_array_driver[captured_trans.Address]) begin
        $display("Data match at address %h: Monitor Data = %h, Driver Data = %h",
                 captured_trans.Address, memory_array_monitor[captured_trans.Address], memory_array_driver[captured_trans.Address]);
    end else begin
        // Increment the error counter and display an error message
                error_count++;
                $error("Data mismatch at address %h: Monitor Data = %h, Driver Data = %h. Total errors: %d",
                       captured_trans.Address, memory_array_monitor[captured_trans.Address], memory_array_driver[captured_trans.Address], error_count);
    end
 /*else begin
    $warning("Address %h not found in one of the arrays!", captured_trans.Address);
end
*/
#2;
end
endtask




endclass : Scoreboard


endpackage : Scoreboard_package