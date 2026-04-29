#include "FifoRTL.h"

void FifoRTL::fifo_comb() {
    if (in_ready.read() && in_valid.read()) {
        new_wr_index.write((wr_index.read() + 1) % DEPTH);
        new_empty.write(0);
        new_in_ready.write(1);
        new_out_valid.write(1);
        buffer[wr_index.read()].write(in_data.read());

        if ((wr_index.read() + 1) % DEPTH == rd_index.read()) {
            new_full.write(1);

            new_in_ready.write(0);
        }
    }

    else if (out_valid.read() && out_ready.read()) {
        new_rd_index.write((rd_index.read() + 1) % DEPTH);
        out_data.write(buffer[rd_index.read()].read());
        new_full.write(0);
        new_in_ready.write(1);

        if ((rd_index.read() + 1) % DEPTH == wr_index.read()) {

            new_out_valid.write(0);
            new_empty.write(1);
        }
    }

    else {
        new_in_ready.write(in_ready);
        new_empty.write(empty);
        new_full.write(full);

    }
}
void FifoRTL::fifo_seq() {
    if (reset.read()) {
        wr_index.write(0);
        rd_index.write(0);
        empty.write(1);
        full.write(0);
        in_ready.write(1);
        out_valid.write(0);
        return;
    }

    wr_index.write(new_wr_index.read());
    full.write(new_full.read());
    empty.write(new_empty.read());
    if (clk) {
        rd_index.write(new_rd_index.read());
        in_ready.write(new_in_ready.read());
        out_valid.write(new_out_valid.read());
    }

    //std::cout << "in_ready: " << new_in_ready << "\n";
}