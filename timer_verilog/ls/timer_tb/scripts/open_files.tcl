global env
# OPEN SOURCE FILES
read [list "$env(HDS_PROJECT_DIR)/timer_tutorial/hdl/control_fsm.v" \
           "$env(HDS_PROJECT_DIR)/timer_tutorial/hdl/Timer_BCDCounter.v" \
           "$env(HDS_PROJECT_DIR)/timer_tutorial/hdl/counter_struct.v" \
           "$env(HDS_PROJECT_DIR)/timer_tutorial/hdl/timer_struct.v" \
           "$env(HDS_PROJECT_DIR)/timer_tutorial/hdl/timer_tester_flow.v" \
           "$env(HDS_PROJECT_DIR)/timer_tutorial/hdl/timer_tb_struct.v"] -format verilog -work timer_tutorial -tech apa
present_design .timer_tutorial.timer_tb.INTERFACE
