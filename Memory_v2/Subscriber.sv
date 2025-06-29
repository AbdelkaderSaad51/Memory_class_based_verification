package Subscriber_package;
import trans_package::*;

class Subscriber;

Transaction captured_trans;

mailbox Subscriber_mailbox;

event stop_event;

event start_sample;

// Coverage group to track values of the transaction
covergroup cg();
	coverpoint captured_trans.wr_en {
            bins write_enabled = {1};  // Check if write is enabled
            bins write_disabled ={0}; // Check if write is disabled
        }
        coverpoint captured_trans.rd_en {
            bins read_enabled = {1}; // Check if read is enabled
            bins read_disabled ={0}; // Check if read is disabled
        }
	coverpoint captured_trans.Address {
            bins addr_0 = {0}; // Cover specific addresses
            bins addr_1 = {1};
            bins addr_2 = {2};
            bins addr_3 = {3};
            bins addr_4 = {4};
            bins addr_5 = {5};
            bins addr_6 = {6};
            bins addr_7 = {7};
            bins addr_8 = {8};
            bins addr_9 = {9};
            bins addr_10 = {10};
            bins addr_11 = {11};
            bins addr_12 = {12};
            bins addr_13 = {13};
            bins addr_14 = {14};
            bins addr_15 = {15};
        }
	coverpoint captured_trans.clear {
            bins clear_enabled = {1};  // Check if clear is enabled
            bins clear_disabled ={0}; // Check if clear is disabled
        }
    coverpoint captured_trans.clear {
            bins rst_enabled = {1};  // Check if rst is enabled
            bins rst_disabled ={0}; // Check if rst is disabled
        }

        coverpoint captured_trans.Data_in {
            bins Data_in_first_range={[10:1000]}; 
            bins Data_in_second_range={[1001:10000]}; 
            bins Data_in_third_range={[10000:50000]};          
        }

        coverpoint captured_trans.Data_out {
            bins Data_out_first_range={[10:1000]}; 
            bins Data_out_second_range={[1001:10000]}; 
            bins Data_out_third_range={[10000:50000]}; 
            bins zero={0};         
        }
endgroup : cg



function new(mailbox mbox,event stop_ev,event sample_begin); 
Subscriber_mailbox=mbox;
stop_event=stop_ev;
start_sample=sample_begin;
cg=new();
endfunction 



task capture();
	forever begin
    if (stop_event.triggered) begin
        $display("Exiting subscriber task...");
        break; // Exit the loop when the stop event is triggered
      end
      wait(start_sample.triggered());
Subscriber_mailbox.peek(captured_trans);

		cg.sample();
	#2;
end
endtask


 


endclass


endpackage