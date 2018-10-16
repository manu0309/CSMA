function time(events,eventlist,ttime,timing,channel,n,comevents,events2,y,channelthreshold)

    z=0;
    if(isempty(eventlist))
        fprintf('Total Simulation time is %d\n',ttime);
        for i=1:length([1,2,3])
            fprintf('Throughput for node %d is %d\n',events(i).node,events(i).throughput);
        end
        jain(events,[1,2,3]);
        return;
    else
        ttime = ttime + timing;
        fprintf('#######\n');
        fprintf('At time %d\n',ttime);
        fprintf('length of eventlist %d\n',length(eventlist));
        for i=1:length(eventlist)
                fprintf('///////\n');
                switch(events(eventlist(i)).status)
                    case -1   %Idle channel?
                        fprintf('node %d checking whether channel is idle or not?\n',events(eventlist(i)).node);
                        if (channel == 0)  %Channel is idle
                            fprintf('node %d finds channel idle and changes its status to IFS\n',events(eventlist(i)).node);
                            events(eventlist(i)).status=0;
                        end
                        events(eventlist(i)).time = events(eventlist(i)).time  + timing;
                        
                    case 0 %Wait IFS time
                        if(events(eventlist(i)).IFS==0)
                            fprintf('Changing node %d status to check whether the channel is still idle or not\n',events(eventlist(i)).node);
                            events(eventlist(i)).status = 1;
                        else
                            events(eventlist(i)).IFS = events(eventlist(i)).IFS-timing;
                            fprintf('node %d wait IFS time(%d) now remaining(%d) \n',events(eventlist(i)).node,events2(eventlist(i)).IFS,events(eventlist(i)).IFS);
                        end
                        events(eventlist(i)).time = events(eventlist(i)).time  + timing;
                        
                    case 1 %still idle
                        fprintf('node %d checking whether channel is still idle or not?\n',events(eventlist(i)).node);
                        if (channel == 0)  %Channel is still idle
                            fprintf('node %d finds channel idle and changes its status to wait for R slots(CWS)\n',events(eventlist(i)).node);
                            events(eventlist(i)).status=2;
                            a = 2^(events(eventlist(i)).k);
                            fprintf('Value of a is %d\n',a);
                            rng('shuffle');
                            events(eventlist(i)).CWS = randi(a)-1;
                            z = events(eventlist(i)).CWS;
                            fprintf('CW wait slots assigned to this node is %d\n',z);
                        else
                            fprintf('node %d finds channel busy and changes its status to again to wait for channel idle\n',events(eventlist(i)).node);
                            events(eventlist(i)).status=-1;
                            events(eventlist(i)) = events2(eventlist(i));
                        end
                        events(eventlist(i)).time = events(eventlist(i)).time  + timing;
                        
                    case 2 %Wait R slots
                        if(events(eventlist(i)).CWS==0 && channel==0)
                            fprintf('node %d wait R slots finishes and channel is idle so ready for sending frame\n',events(eventlist(i)).node);
                            events(eventlist(i)).status=3;
                        end
                        if (channel == 0 && events(eventlist(i)).CWS ~=0)
                            events(eventlist(i)).CWS = events(eventlist(i)).CWS-timing;
                            fprintf('node %d wait R slots(%d) now remaining(%d) \n',events(eventlist(i)).node,z,events(eventlist(i)).CWS); 
                        else
                            if(channel == 1)
                                fprintf('node %d - channel busy halt at %d\n',events(eventlist(i)).node,events(eventlist(i)).CWS); 
                            end
                        end
                        
                        events(eventlist(i)).time = events(eventlist(i)).time  + timing;
                        
                    case 3 %Send frame
                        if(events(eventlist(i)).frametime)
                            events(eventlist(i)).frametime = events(eventlist(i)).frametime - timing;      %time taken to send the frame or up to which the
                            fprintf('node %d is sending frame(%d) remaining(%d)\n',events(eventlist(i)).node,events2(eventlist(i)).frametime,events(eventlist(i)).frametime);
                        else
                            fprintf('node %d has sent the frame\n',events(eventlist(i)).node);
                        end
                        if(events(eventlist(i)).timeout)
                            events(eventlist(i)).timeout = events(eventlist(i)).timeout - timing;      %time taken to send the frame or up to which the
                            fprintf('node %d timeout starts(%d) remaining(%d)\n',events(eventlist(i)).node,events2(eventlist(i)).timeout,events(eventlist(i)).timeout);
                        end
                        events(eventlist(i)).time = events(eventlist(i)).time  + timing;
                    case 4 %remaining Timeout
                        events(eventlist(i)).timeout = events(eventlist(i)).timeout - timing;      %time taken to send the frame or up to which the
                        fprintf('node %d timeout starts(%d) remaining(%d)\n',events(eventlist(i)).node,events2(eventlist(i)).timeout,events(eventlist(i)).timeout);
                        
                end
                fprintf('//////////////////\n')
        end
    
        %Here now we have to analyse the status of each events 
        %checking whether we receive ack after some time.
        %if we receive an ack then ....
    
        %///////////The functionality for periodicity of events will be dealt later////////////
        %function generates the possible list of events(periodic) need to be
        %executed. We have to initialise the new events. Also if the event missed its deadline then its value is
        %zero so we have to remove it from the list.
        %///////////////////////
       
        x = 0; 
        for i=1:length(eventlist)
            if(events(eventlist(i)).status == 3) %send frame
                x = x+1;
                channel = 1;
                fprintf('Channel becomes busy\n');
                events(eventlist(i)).Pr = events(eventlist(i)).Pt*events(eventlist(i)).Gt*events(eventlist(i)).Gr*((4*3.14*events(eventlist(i)).lamda)./events(eventlist(i)).d).^2;  %Power transmitted by each node
                fprintf('Power reached to the coordinator by event %d is %d\n',events(eventlist(i)).node,events(eventlist(i)).Pr);
            end
        end
        
        %///////
        if(x>1)
            for i=1:length(eventlist)
                if(events(eventlist(i)).status == 3)
                    events(eventlist(i)).ack = 0;
                end
            end
        end
            
        
        power=0;
        for i=1:length(eventlist)
            for j=1:length(eventlist)
                if(events(eventlist(i)).status == 3 && i ~= j && events(eventlist(j)).status == 3) %send frame
                    if((events(eventlist(i)).channel-events(eventlist(j)).channel)<channelthreshold) 
                        events(eventlist(i)).Pr = events(eventlist(i)).Pr/(events(eventlist(i)).channel-events(eventlist(j)).channel);   
                        fprintf('%d\n',eventlist(j));
                    end
                end
            end
            
            power = power + events(eventlist(i)).Pr;    %adding the total power transmitted
        end
        
         fprintf('Total Power reached to the coordinator by events %d\n',power);

         for i=1:length(eventlist)
            if(events(eventlist(i)).status == 3 && events(eventlist(i)).frametime == 0)
                %events(eventlist(i)).ack = 1;
                channel = 0;
                fprintf('Frame sent by the node %d completed, making the channel again idle\n',events(eventlist(i)).node);
                events(eventlist(i)).Pr = 0;
                events(eventlist(i)).status = 4; %status for timeout
            end
            if(events(eventlist(i)).timeout == 0 && events(eventlist(i)).ack)
                fprintf('Since Ack is received by the node %d so it is successfully transmitted\n',events(eventlist(i)).node);
                events(eventlist(i)).status = 5; %status for success
            end
        end
    
        
            for i=1:length(eventlist)
                if(events(eventlist(i)).status == 4 && events(eventlist(i)).timeout == 0 && events(eventlist(i)).ack == 0)
                    if(events(eventlist(i)).k < 15)
                        events2(eventlist(i)).k = events2(eventlist(i)).k + 1;
                        events2(eventlist(i)).time = events(eventlist(i)).time;
                        events(eventlist(i)) = events2(eventlist(i));
                        fprintf('Reinitialising the event of node %d\n',events(eventlist(i)).node); 
                    else
                        events(eventlist(i)).status = 6; %status for abort
                        fprintf('Node %d reaches its maximum value so aborting it....%d\n',events(eventlist(i)).node);
                    end
                end
            end
        
        newevents = [];    
        for i=1:length(eventlist)
            if(events(eventlist(i)).status == 5)
                comevents(i) = eventlist(i);   %adding the successfully completed events in the list comevents
                fprintf('Adding node %d to the list of completed events\n',events(eventlist(i)).node);
                fprintf('Total time taken by node %d in successfully transmitting is %d\n',events(eventlist(i)).node,events(eventlist(i)).time);
                events(eventlist(i)).throughput = 1/events(eventlist(i)).time;
            else 
                if(events(eventlist(i)).status == 6)
                    %aborted event
                else
                    fprintf('%d is added to new event list\n',eventlist(i));
                    newevents(length(newevents)+1) = eventlist(i);
                    %fprintf('%d timeout of node\n',events(newevents(1)).timeout);
                end
            
            end
        end
        fprintf('#################\n');
        
        if(y<9)
            time(events,newevents,ttime,timing,channel,n,comevents,events2,y+1,channelthreshold);%calling the function again
    
        end
    end
end
        
    
    
       
    

    
