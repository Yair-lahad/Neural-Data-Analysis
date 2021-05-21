clear
close all

%%% Exercise 1 intra cellular recordings
% Gali Winterberger      id - 315679571
% Yair Lahad             id - 205493018

%--------------------------------------------------------------
load('S1.mat');
load('S2.mat');
%Si=S1; %making it easier to observe each case (s1 or s2)
Si=S2;
fs =10000; %sampling rate
dt = 1/fs ; %time step
N= length(Si); % number of components in Si
t=dt*(1:N); % time vector

%%% Exercise 2

th = -30 ;% threshold
saTH=(Si>th); %samples above threshold
dif_saTH= diff(saTH); % derivative of samples above threshold
L2H=find(dif_saTH >0); %begining of membrence potetntial- points where voltage start to pass threshold
H2L=find(dif_saTH<0); %ending of membrence potential- points where voltage finish to pass threshold
LM=[]; % creating vector for local maximum
LM_ind=[]; % vector for local maximum index in Si

% loop on threshold crossing events

for spike=1 : length(H2L) 
    start=L2H(spike); %the first time in the event which we cross the threshold
    final=H2L(spike); %the last time in the event which we cross the threshold
    [val,index]=max(Si(start:final)); % the local maximum point and Si index of the current local max
    LM=[LM,val];% adding our local maximum values to result vector
    LM_ind=[LM_ind,index+start-1]; % adding our local maximum indexes to index vector
end

%Exercise 3 
seg_len=3000; % size of segment
seg=1; %index for segement 
SC=zeros(1,N/seg_len); % vector for counting spikes in segement
for spike=1 : length(LM_ind)  %loop on the spikes vector
    if LM_ind(spike)<=seg*seg_len % condition for adding the spike count to the segment 
        SC(seg)=SC(seg)+1; 
    else
        while LM_ind(spike)>seg*seg_len %if not in the right one- reaching for the currect segment
           seg=seg+1;
        end
        SC(seg)=1+SC(seg); % adding value to segment
        
    end
end
R=(SC/2000)*fs; % rate for each segment - spikes per sec

%Exercise 4 - plotting
hold on %all orders on the same plot
title('Intra-cellular recordings');
xlabel('time in seconds');ylabel('Voltage in mv');
plot(t,Si,'-o','MarkerIndices',L2H,'MarkerEdgeColor','g');
plot(t,Si,'-o','MarkerIndices',H2L,'MarkerEdgeColor','r');
plot(t,Si,'-o','MarkerIndices',LM_ind,'MarkerEdgeColor','black');
plot(t,Si,'b');%makes Si blue
[tval,tind]=max(Si(1:seg_len)); % getting the index to start plotting the Rates per segment
times=t(1,(tind:seg_len:N)); %choosing the distance to represent each Rate 
for seg = 1:length(times)
    text(times(seg),max(LM)+3,num2str(R(seg))); % represnting rates per segment
end
legend('L2H', 'H2L', 'LM','Voltage singal'); %adding explanation for graph components
text(-1,max(LM)+5,"Rate- Spikes per sec");
hold off

