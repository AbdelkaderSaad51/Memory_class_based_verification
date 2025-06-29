package Sequencer_package;
import trans_package::*;
class Sequencer;

integer i;

mailbox Sequencer_mailbox;
function new(mailbox mailbox_inst);
	Sequencer_mailbox=mailbox_inst;
	
endfunction 

task generate_transaction(ref bit driver_done);
	Transaction Memory_trans;
	Memory_trans=new();//why every iteration new trans?
Memory_trans.clear=1;//clear the memory
#5;

Sequencer_mailbox.put(Memory_trans);
wait(driver_done==1); // Wait for the driver to complete the transaction
      driver_done = 0; // Reset the done flag


Memory_trans.clear=0;
//write to the memory
for(i=0;i<16;i++)begin
	Memory_trans=new();
	Memory_trans.wr_en=1;//enable write
	Memory_trans.rd_en=0;//disable read
	Memory_trans.Address=i;
	Memory_trans.Data_in=i*123+12;
	Sequencer_mailbox.put(Memory_trans);// Put the transaction into the mailbox for each iteration
	wait(driver_done==1); // Wait for the driver to complete the transaction
      driver_done = 0; // Reset the done flag
#5;
end

//read from memory
for(i=0;i<16;i++)begin
	Memory_trans=new();
	Memory_trans.wr_en=0;//disable write
	Memory_trans.rd_en=1;//enable read
	//Memory_trans.Data_in=i*123+12;
	Memory_trans.Address=i;
	Sequencer_mailbox.put(Memory_trans);// Put the transaction into the mailbox for each iteration
	wait(driver_done==1); // Wait for the driver to complete the transaction
      driver_done = 0; // Reset the done flag
#5;
end


Memory_trans=new();
//check rst
Memory_trans.rst=1;
Sequencer_mailbox.put(Memory_trans);
wait(driver_done==1); // Wait for the driver to complete the transaction
      driver_done = 0; // Reset the done flag
#5;
Memory_trans=new();
Memory_trans.rst=0;


endtask
endclass : Sequencer
endpackage : Sequencer_package