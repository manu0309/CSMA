function jain(events,eventlist)
sum = 0;
sumsqr = 0;
    for i=1:length(eventlist)
        sum = sum + events(eventlist(i)).throughput;
        sumsqr = sumsqr + events(eventlist(i)).throughput^2;
    end
    fprintf('Jain Index for given nodes is %d\n',sum^2/(sumsqr*length(eventlist)));
end
