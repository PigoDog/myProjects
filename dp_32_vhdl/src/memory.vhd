USE work.dp32_types.ALL, work.alu_32_types.ALL;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY memory IS
	GENERIC (Tpd : TIME := unit_delay);
	PORT (
		d_bus : INOUT bus_bit_32 BUS;
		a_bus : IN bit_32;
		read : IN STD_LOGIC;
		write : IN STD_LOGIC;
		ready : OUT STD_LOGIC);
END memory;
ARCHITECTURE behaviour OF memory IS
BEGIN
	PROCESS
		CONSTANT low_address : INTEGER := 0;
		CONSTANT high_address : INTEGER := 65535;
		TYPE memory_array IS
		ARRAY(INTEGER RANGE low_address TO high_address)OF bit_32;
		VARIABLE address : INTEGER := 0;
		VARIABLE mem : memory_array :=
		(-- init
X"1006_0008", -- r6 = N = 8
X"1003_0600", -- r3 = gap = N

-- outer loop
X"110A_0301", -- r10 = gap - 1
X"410B_0000", X"0000_0020", -- if negative -> check swapped

-- gap = gap - 1
X"1203_030A",
X"1303_030D",

X"1001_0000",-- i = 0
X"0107_0603",-- r7 = N - gap

-- inner loop
X"0002_0103", -- r2 = i + gap
X"010A_0602", -- r6 = N - (i + gap)
X"4109_0000", X"0000_0002", -- jump outer loop

X"2004_0100", X"0000_001D", --loading data into r4 from r1 with an dist
X"2005_0200", X"0000_001D", --loading data into r5 from r2 with an dist

X"010A_0405", -- r10 = r4 - r5
X"410B_0000", X"0000_0019", -- skip swap

-- swap
X"2105_0100", X"0000_001D", -- mem[r1 + dist] + r5
X"2104_0200", X"0000_001D", -- mem[r2 + dist] + r5

X"0000_0000",
-- skip swap
X"1001_0101", -- i++
X"0000_0000",
X"410B_0000", X"0000_0008", -- jump inner loop

-- memory
X"0000_0006",
X"0000_0001",
X"0000_0007",
X"0000_0002",
X"0000_0004",
X"0000_0008",
X"0000_0003",
X"0000_0005",
X"0000_0000",

others => X"0000_0000");
	BEGIN
		--
		-- put d_bus and reply into initial state
		--
		d_bus <= NULL AFTER Tpd;
		ready <= '0' AFTER Tpd;
		--
		-- wait for a command
		--
		WAIT UNTIL (read = '1') OR (write = '1');
		--
		-- dispatch read or write cycle
		--
		address := bits_to_int(a_bus);
		IF address >= low_address AND address <= high_address THEN
			-- address match for this memory
			IF write = '1' THEN
				ready <= '1' AFTER Tpd;
				WAIT UNTIL write = '0'; -- wait until end of write cycle
				mem(address) := d_bus;--'delayed(Tpd); -- sample data from Tpd ago
			ELSE -- read='1'
				d_bus <= mem(address) AFTER Tpd; -- fetch data
				ready <= '1' AFTER Tpd;
				WAIT UNTIL read = '0'; -- hold for read cycle
			END IF;
		END IF;
	END PROCESS;
END behaviour;
