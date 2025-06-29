package callback1;
class DriverScoreboardCallback;
    //virtual function to pass data to the scoreboard
    virtual function void pass_data_to_scoreboard(logic [31:0] data,logic[3:0] address);
endfunction : pass_data_to_scoreboard
endclass
endpackage : callback1
