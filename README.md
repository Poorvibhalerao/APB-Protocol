# APB-Protocol
# INTRODUCTION
 APB is low bandwidth and low-performance bus. So, the components requiring lower bandwidth like the peripheral devices such as UART, Keypad, Timer, and PIO (Peripheral Input Output) devices are connected to the APB. The bridge connects the high-performance AHB or ASB bus to the APB bus. So, for APB the bridge acts as the master, and all the devices connected on the APB bus act as the slave.
 
## APB signals:

|SIGNAL|	SOURCE|	Description|	WIDTH(Bit)|
|------|--------|------------|----------|
|PCLK|	Clock Source|	All APB functionality occurs at a rising edge.|	1|
|PRESETn|	System Bus|	An active low signal.|	1|
|PADDR|	APB bridge|	The APB address bus can be up to 32 bits.|	32|
|PSELx	|APB bridge|	There is a PSEL for each slave. It’s an active high signal.|	1|
|PENABLE|	APB bridge|	It indicates the 2nd cycle of a data transfer. It’s an active high signal.|	1|
|PWRITE|	APB bridge|	Indicates the data transfer direction. PWRITE=1 indicates APB write access(Master to slave) PWRITE=0 indicates APB read access(Slave to master)|	1|
|PREADY|	Slave Interface|	This is an input from Slave. It is used to enter the access state.|	1|
|PSLVERR|	Slave Interface|	This indicates a transfer failure by the slave.|	1|
|PRDATA|	Slave Interface|	Read Data. The selected slave drives this bus during reading operation|	32|
|PWDATA|	Slave Interface|	Write data. This bus is driven by the peripheral bus bridge unit during write cycles when PWRITE is high.|	32|
