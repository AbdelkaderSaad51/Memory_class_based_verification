package Sequencer_package;
import trans_package::*;
class Sequencer;
mailbox Sequencer_mailbox;
int i;
Transaction blueprint;
function new(mailbox mailbox_inst);
	Sequencer_mailbox=mailbox_inst;
	 blueprint = new();
endfunction 

 task generate_transaction(input int num_tr = 16, ref bit driver_done);
    // Generate 16 write transactions
    for (int i = 0; i < num_tr; i++) begin
        
        blueprint.wr_en = 1;  // Enable write
        blueprint.rd_en = 0;  // Disable read
       
        // Randomize other fields in the transaction
            blueprint.randomize();
            Sequencer_mailbox.put(blueprint.copy());
        
        
        // Wait for the driver to finish processing the current transaction
        wait(driver_done == 1);
        driver_done = 0; // Reset the driver_done flag for the next transaction
        
        #5; // Add a delay if needed between transactions
    end

    // Generate 16 read transactions
    for (int i = 0; i < num_tr; i++) begin
        
        blueprint.wr_en = 0;  // Disable write
        blueprint.rd_en = 1;  // Enable read
        
        // Randomize other fields in the transaction
        //blueprint.randomize();
            // Send the read transaction to the driver
            Sequencer_mailbox.put(blueprint.copy());
        
        
        // Wait for the driver to finish processing the current transaction
        wait(driver_done == 1);
        driver_done = 0; // Reset the driver_done flag for the next transaction
        
        #5; // Add a delay if needed between transactions
    end
    
for (int i = 0; i < num_tr; i++) begin
        blueprint.wr_en = 1;  // Enable write
        blueprint.rd_en = 0;  // Disable read
        
        // Set reset and clear signals
        blueprint.rst = 1;    // Set reset signal
        blueprint.clear = 1;  // Set clear signal

        // Randomize other fields in the transaction
        if (!blueprint.randomize()) begin
            $display("Randomization failed for write transaction!");
            continue; // Skip to the next iteration if randomization fails
        end else begin
            // Send the write transaction to the driver
            Sequencer_mailbox.put(blueprint.copy());
        end
        
        // Wait for the driver to finish processing the current transaction
        wait(driver_done == 1);
        driver_done = 0; // Reset the driver_done flag for the next transaction
        
        #5; // Add a delay if needed between transactions
    end

    // Generate 16 read transactions
    for (int i = 0; i < num_tr; i++) begin
        blueprint.wr_en = 0;  // Disable write
        blueprint.rd_en = 1;  // Enable read
        
        // Reset and clear should be low before reading
        blueprint.rst = 0;    // Deassert reset signal
        blueprint.clear = 0;  // Deassert clear signal

        // Randomize other fields in the transaction
        if (!blueprint.randomize()) begin
            $display("Randomization failed for read transaction!");
            continue; // Skip to the next iteration if randomization fails
        end else begin
            // Send the read transaction to the driver
            Sequencer_mailbox.put(blueprint.copy());
        end
        
        // Wait for the driver to finish processing the current transaction
        wait(driver_done == 1);
        driver_done = 0; // Reset the driver_done flag for the next transaction
        
        #5; // Add a delay if needed between transactions
    end

endtask

endclass : Sequencer
endpackage : Sequencer_package