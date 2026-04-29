#ifndef FIFO_H
#define FIFO_H

#include "systemc.h"


SC_MODULE(FifoRTL)
{
    static const int DEPTH = 4;
    sc_in<bool> clk;  
    sc_in<bool> reset;

    sc_in<sc_uint<32>> in_data;
    sc_in<bool> in_valid; 
    sc_in<bool> out_ready;  
    
    sc_out<sc_uint<32>> out_data;
    sc_out<bool> out_valid;
    sc_out<bool> in_ready;

    sc_vector <sc_signal<sc_uint<32>>> buffer;
    sc_signal <sc_uint<32> > number;
    sc_signal< sc_uint<DEPTH> > wr_index;
    sc_signal < sc_uint<DEPTH> > rd_index;
	sc_signal<bool> full;
	sc_signal<bool> empty;

    sc_signal< sc_uint<DEPTH> > new_wr_index;
    sc_signal < sc_uint<DEPTH> > new_rd_index;
    sc_signal<bool> new_full;
    sc_signal<bool> new_empty;

    sc_signal<bool> new_out_valid;
    sc_signal<bool> new_in_ready;


    void fifo_comb();
    void fifo_seq();


    SC_CTOR(FifoRTL):
        buffer("buffer", DEPTH)
    {
        SC_METHOD(fifo_comb);
        sensitive << in_ready << out_valid << out_ready << in_valid << in_data << rd_index;

        SC_METHOD(fifo_seq);
        sensitive << clk;
    }
};

#endif
