package Enviroment_package;
import Sequencer_package::*;
import Driver_package::*;
import Monitor_package::*;
import Subscriber_package::*;
import Scoreboard_package::*;
import trans_package::*;

class Enviroment;

Sequencer my_sequencer;
driver my_driver;
Monitor my_monitor;
Subscriber my_subscriber;
Scoreboard my_scoreboard;
Transaction my_transaction;
event monitor_scoreboard;
event stop_execution;
mailbox my_mail;

bit driver_done;

virtual mem_intf vif;

function new(virtual mem_intf intf_inst);
vif=intf_inst;
my_mail=new();
my_sequencer=new(my_mail);
my_driver=new(vif,my_mail,stop_execution,driver_done);
my_monitor=new(vif,my_mail,stop_execution,monitor_scoreboard);
my_subscriber=new(my_mail,stop_execution,monitor_scoreboard);
my_scoreboard=new(my_mail,stop_execution,monitor_scoreboard);
my_driver.register_callback(my_scoreboard);
endfunction



task run();
my_transaction=new();

fork
my_sequencer.generate_transaction(16,driver_done);
my_driver.send_trans(my_transaction,driver_done);
my_monitor.start_monitor();
my_subscriber.capture();
my_scoreboard.compare();
join_none;

#1000;
->stop_execution;
$display("Event triggered!");

endtask


endclass : Enviroment



endpackage : Enviroment_package