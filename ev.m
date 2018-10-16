clc
clear
global events;
global channelthreshold;
global events2; %containing the copy of the events
global n; %total number of initial events present, will change accordingly
global comevents;  %events that are completed
global timing; %counts the executing time for each event
global ttime; %total simulation time
global channel;
channel = 0;  %channel is idle
n = 3;
timing = 1;  %minimum time consumed during each iteration
comevents = zeros(1,n);
ttime = 0;
channelthreshold = 1.3;


events=struct('throughput',{},'frametime',{},'node',{},'IFS',{},'CWS',{},'timeout',{},'type',{},'status',{},'k',{},'ack',{},'time',{},'Pr',{},'channel',{},'Pt',{},'Gt',{},'Gr',{},'lamda',{},'d',{});
events(1).throughput=0;
events(1).frametime=3; %distance/speed  
events(1).node=1;
events(1).IFS=3;  %Interframe Space - also used here to define the priority
events(1).CWS=0;  %Contention Window Size
events(1).timeout=6;%TimeOut timer for Ack 
events(1).type='Send';
events(1).status=-1;
events(1).k=0;       %K max vaulue is 15 above which if the event is not able to send the packet then it will abort
events(1).ack=1;
events(1).time=0;
events(1).Pr=0;
events(1).channel=5;
events(1).Pt=1; %watt
events(1).Gt=1;
events(1).Gr=1;
events(1).lamda=6; %wavelength in cm
events(1).d=100;

events(2).throughput=0;
events(2).frametime=2;
events(2).node=2;
events(2).type='Send';
events(2).IFS=2;
events(2).timeout=6;
events(2).CWS=0;
events(2).status=-1;
events(2).k=0;
events(2).ack=1;
events(2).time=0;
events(2).Pr=0;
events(2).channel=3.6;
events(2).Pt=1;
events(2).Gt=1;
events(2).Gr=1;
events(2).lamda=8.3;
events(2).d=60;

events(3).throughput=0;
events(3).frametime=4;
events(3).node=3;
events(3).IFS=1;
events(3).CWS=0;
events(3).timeout=6;
events(3).type='Send';
events(3).status=-1;
events(3).k=0;
events(3).ack=1;
events(3).time=0;
events(3).Pr=0;
events(3).channel=2.4;
events(3).Pt=1;
events(3).Gt=1;
events(3).Gr=1;
events(3).lamda=12.5;
events(3).d=150;





events2 = events;

time(events,[1,2,3],ttime,timing,channel,n,comevents,events2,0,channelthreshold);

%jain(events,[1,2,3,4,5]);

