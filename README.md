# CSMA
Carrier-sense multiple access with collision avoidance (CSMA/CA) in computer networking, is a network multiple access method in which carrier sensing is used, but nodes attempt to avoid collisions by transmitting only when the channel is sensed to be "idle".

The above code is the simulation of the CSMA/CA in Matlab

The folder consist of four files
1. time.m
2. ev.m
3. jain.m
4. ev2.m

Here ev.m file is used to initilise the nodes present and then events will be generated according to the parameters given(for eg. frametime, energy of node, Inter frame space etc.)
This function calls the time function(time.m file) which do the simulation of the CSMA/CA and gives the output.

The simulation is such that with in a time t all the nodes are active and will perform there respective action in parallel.
For each time, state of each node is shown as an output.

ev2.m file is case showing the initial 3 nodes generating 3 events with all the parameters initialized

Jain index for the simulation is also calculted to display whether all the nodes got fair chance in the network or not.
