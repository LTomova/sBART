function sBART_behavioral
%% sBART: social Balloon Analogue Risk Task
% description of task and experimental procedures in: https://www.nature.com/articles/s41598-018-23455-7
% task is an adapted version from automatic BART by Pleskac, T.J., Wallsten, T.S, Wang, P. &
% Lejuez, C.W. (2008)
% written for PTB Version 3.0.8 running on Windows 10 OS
% this is the behavioral version of the task (input via keyboard)
% command to start sBART: sBART_behavioral;
% written by Livia Tomova, 2017

% subj_id
subID = input('Enter the Subject ID: ');


% create folder for logfiles
path = '.\log_sBART';
subjectdir = fullfile(path,sprintf('sBART_%s%d',subID));
exdir=exist(subjectdir);
if exdir== 7
    sprintf('A folder with this name already exists. The experiment is stopped to not overwrite any data.')
    return
else
mkdir(path,sprintf('sBART_%s%d',subID));
end


%conditons:
% 1= high risk 20 trials
% 2= low risk 20 trials
% 3= neutral 20 trials
% % fixed order of conditions for 60 trials:
cond=[2 1 3 2 3 1 1 2 3 1 3 2 3 1 2 3 2 1 2 1 3 2 3 1 1 2 3 1 3 2 3 1 2 3 2 1 2 1 3 2 3 1 1 2 3 1 3 2 3 1 2 3 2 1 2 1 3 2 3 1];

%fixed explosion points for each trial (taken from automatic BART by Pleskac et al. 2008 -
%original has 30 trials so explosion point vector doubled here (just same
%numbers repeated)
expl = [64 105 39 96 88 21 121 10 64 32 64 101 26 34 47 121 64 95 75 13 64 112 30 88 9 64 91 17 115 50 64 105 39 96 88 21 121 10 64 32 64 101 26 34 47 121 64 95 75 13 64 112 30 88 9 64 91 17 115 50];

% configurations
HideCursor;
Screen('Preference', 'SkipSyncTests', 0); % set to 1 on laptop; 0 on scanner
KbName('UnifyKeyNames'); % make sure we're getting the correct name for all the keyboards
displays = max(Screen('Screens')); %Highest screen number is most likely correct display
[window,screenRect] = Screen('OpenWindow', displays,0);
scrnRes     = Screen('Resolution',displays(end));               % Get Screen resolution
[x0, y0]		= RectCenter([0 0 scrnRes.width scrnRes.height]);   % Screen center.
Screen('Preference', 'VisualDebugLevel', 0); %surpressess warning at beginning of ptb start
InitializePsychSound(1);

% load balloon pics
balloon=imread('balloon.jpg');
poppedballoon=imread('poppedballoon.jpg');

% load sounds
inflate= 'inflate.wav';
pop='explosion.wav';
cash='casino.wav';


% choices of others
%conditions:
%cond1 = majority of other players choses high amounts of pumps (2 out of
%of 3)
%cond2 = majority of other players choses low amounts of pumps (2 out of
%3)
%cond3 = neutral choices of other players deviate around mean pumps (=64)

%implementation:
% total number of pumps: 128
% High risk pumps = range: 75 until 127
% Low risk pumps = range: 1 until 53
% Neutral pumps = range: 54(64-10) until (64+10)74
% Two vectors(high_risk_choices): high risky decsisons, 60 values,on each high risk trial 2 of
% the values are chosen and randomly assigned to either player 1,2 or 3
% same for low_risk_choices
% One vector with neutral choices deviating around mean number pumps -
% lenght vector = neutral cond 

%vectors for choices of others
%making more random vectors turns out to give better variation than having 
%one vector for each condition from which all choices are sampled
hr_ch1 = round(75+(127-75)*rand(1,60));
hr_ch2 = round(75+(127-75)*rand(1,60));
lr_ch1 = round(1+(53-1)*rand(1,60));
lr_ch2 = round(1+(53-1)*rand(1,60));
n_ch = round(54+(74-54)*rand(1,60));  
n_ch1 = round(54+(74-54)*rand(1,60));
n_ch2 = round(54+(74-54)*rand(1,60));
n_ch3 = round(54+(74-54)*rand(1,60));

%make different sizes of the balloon
[yimg,ximg,z]=size(balloon);
%first size, before inflating
sx = 250;          % desired x-size of image (pixels)
sy = yimg*sx/ximg; % desired y-size--keep proportional
destrect=[x0-sx/2,y0-sy/2,x0+sx/2,y0+sy/2];
%inflation1
sx_inf1= 500;
sy_inf1 = yimg*300/ximg;
destrect1=[x0-sx_inf1/2,y0-sy_inf1/2,x0+sx_inf1/2,y0+sy_inf1/2];
%inflation2
sx_inf2= 750;
sy_inf2 = yimg*400/ximg;
destrect2=[x0-sx_inf2/2,y0-sy_inf2/2,x0+sx_inf2/2,y0+sy_inf2/2];
%inflation3
sx_inf3= 850;
sy_inf3 = yimg*500/ximg;
destrect3=[x0-sx_inf3/2,y0-sy_inf3/2,x0+sx_inf3/2,y0+sy_inf3/2];
%inflation4
sx_inf3= 1000;
sy_inf3 = yimg*600/ximg;
destrect4=[x0-sx_inf3/2,y0-sy_inf3/2,x0+sx_inf3/2,y0+sy_inf3/2];

%instructions
title = 'Individual round'; %for team round, change to: title = 'Team round';
instructions1 = 'Pump up each balloon (max pumps: 128).';
instructions2 = 'Press Enter to start.';
waiting = 'Waiting for repsonses of all teammembers...';
ques='How many times do you want to pump up the balloon?';
teamchinfo = 'Choices of your our teammembers';
Screen(window,'TextSize',30);


Screen('FillRect', window, [255,255,255])

maxPriorityLevel = MaxPriority(window); %give ptb maximal priority
oldPriorityLevel = Priority(maxPriorityLevel); %to set back to old priority


% this is when the experiment starts
experimentStart = GetSecs;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% present instructions
DrawFormattedText(window, title,'center',100,[255,0,0],40);
DrawFormattedText(window, instructions1,'center',200,[1,1,1],40);
DrawFormattedText(window, instructions2,'center',800,[1,1,1],40);
balloonTex = Screen('MakeTexture',window,balloon);
Screen('DrawTexture',window,balloonTex, [], destrect);
Screen('Flip',window);
KbWait;
Screen('Close'); 

%get ready
instructions = 'Get ready.';
Screen(window,'TextSize',36);
DrawFormattedText(window, instructions,'center','center',[1,1,1],40);
Screen('Flip',window);
WaitSecs(5);
Screen('Close'); 

%% trialstart
for trialNum = 1:60
    trialcond(trialNum,1)=cond(trialNum);
    trialexpl(trialNum,1)= expl(trialNum);
   
   %assign choices of other players based on condition
    if trialcond(trialNum,1) == 1
        ch1trial(trialNum,1)= hr_ch1(trialNum);
        ch2trial(trialNum,1)= hr_ch2(trialNum);
        ch3trial(trialNum,1)= n_ch(trialNum);
    elseif trialcond(trialNum,1) == 2
        ch1trial(trialNum,1)= lr_ch1(trialNum);
        ch2trial(trialNum,1)= lr_ch2(trialNum);
        ch3trial(trialNum,1)= n_ch(trialNum);
    elseif trialcond(trialNum,1) == 3
        ch1trial(trialNum,1)= n_ch1(trialNum);
        ch2trial(trialNum,1)= n_ch2(trialNum);
        ch3trial(trialNum,1)= n_ch3(trialNum);
    end
    
    %shuffle to always assign high and low choices to different players
    %to avoid creating "low/high risk - people"
    teamch(trialNum,1)=ch1trial(trialNum,1);
    teamch(trialNum,2)=ch2trial(trialNum,1);
    teamch(trialNum,3)=ch3trial(trialNum,1);
    rand_ch=randperm(3);
    rand_nr1=rand_ch(1,1);
    rand_nr2=rand_ch(1,2);
    rand_nr3=rand_ch(1,3);
    ch_p1(trialNum,1)=teamch(trialNum,rand_nr1);
    ch_p2(trialNum,1)=teamch(trialNum,rand_nr2);
    ch_p3(trialNum,1)=teamch(trialNum,rand_nr3);
    
    %create text for display
    teamch1 = ['Player 1: ' num2str(ch_p1(trialNum,1))];
    teamch2 = ['Player 2: ' num2str(ch_p2(trialNum,1))]; 
    teamch3 = ['Player 3: ' num2str(ch_p3(trialNum,1))];
   
    %create screen with first question
    responseStart = GetSecs;
    balloonTex = Screen('MakeTexture',window,balloon);
    Screen('DrawTexture',window,balloonTex, [], destrect);
    
    while 1
        reply1=Ask(window,ques,[],[],'GetChar',RectLeft,RectTop); % accept keyboard input and echo it to screen
        resp = str2num(reply1);
        
        if isempty(resp)
            
        else
            resp1(trialNum,1)=resp;  %check if response numerical, otherwise do not continue
            break;
        end
    end
    
    clear resp
    
    
    Screen('Flip',window);
    RT_rep1(trialNum) = GetSecs - responseStart; %response time for first choice
    Screen('Close');
    
    %pretend to wait until all responses collected
    DrawFormattedText(window,waiting,'center','center',[1,1,1],40);
    Screen('Flip',window);
    WaitSecs(3);
    Screen('Close');
    
    %show choices of others
    DrawFormattedText(window, teamchinfo,'center',300,[1,1,1],40);
    DrawFormattedText(window, teamch1,100,500,[255,0,0],40);
    DrawFormattedText(window, teamch2,100,600,[255,0,0],40);
    DrawFormattedText(window, teamch3,100,700,[255,0,0],40);
    Screen('Flip',window);
    WaitSecs(3);
    Screen('Close'); 
    
    %ask again about number of pumps
    responseStart = GetSecs;
    balloonTex = Screen('MakeTexture',window,balloon);
    Screen('DrawTexture',window,balloonTex, [], destrect);
    
    while 1
        reply2=Ask(window,ques,[],[],'GetChar',RectLeft,RectTop); % accept keyboard input, echo it to screen
        resp = str2num(reply2);
        
        if isempty(resp)   %check if response numerical, otherwise do not continue
            
        else
            resp2(trialNum,1)=resp;
            break;
        end
    end
    
    clear resp
    
    
    Screen('Flip',window); 
    RT_rep2(trialNum) = GetSecs - responseStart;
    Screen('Close');
    
    %display info about final choice
    finchoice = ['Your choice:' num2str(reply2)];
    DrawFormattedText(window, finchoice,'center',300,[1,1,1],40);
    Screen('Flip',window);
    WaitSecs(1);
    Screen('Close');

    %blow up balloon
    balloonTex = Screen('MakeTexture',window,balloon); %initial size
    Screen('DrawTexture',window,balloonTex, [], destrect);
    Screen('Flip',window);
    WaitSecs(1);
    SoundOut(1,inflate); %sound
    
    %size2
    Screen('DrawTexture',window,balloonTex, [], destrect1);
    Screen('Flip',window);
    SoundOut(1,inflate); %sound

    %size 3
    Screen('DrawTexture',window,balloonTex, [], destrect2);
    Screen('Flip',window);
    SoundOut(1,inflate); %sound
    
    %size 4
    Screen('DrawTexture',window,balloonTex, [], destrect3);
    Screen('Flip',window);
    SoundOut(1,inflate); %sound
    
 

    if resp2(trialNum) > trialexpl(trialNum)
        outcome(trialNum)=2; %2=no win on this trial
        balloonTex = Screen('MakeTexture',window,poppedballoon);
        Screen('DrawTexture',window,balloonTex, [], destrect4);
        Screen('Flip',window);
        SoundOut(1,pop);
        WaitSecs(1); 
        Screen('DrawTexture',window,balloonTex, [], destrect4);
        nowin = 'No win. No points.';
        DrawFormattedText(window, nowin,'center',100,[1,1,1],40);
        Screen('Flip',window);
        WaitSecs(1);
    else
        outcome(trialNum)=1; %1=win on this trial
        Screen('DrawTexture',window,balloonTex, [], destrect4);
        Screen('Flip',window);
        WaitSecs(2)
        win = ['You win!!! + ' num2str(reply2) 'points!!'];
        Screen('DrawTexture',window,balloonTex, [], destrect4);
        DrawFormattedText(window, win,'center',100,[1,1,1],40);
        SoundOut(1,cash);
        Screen('Flip',window);
        WaitSecs(2)
        
    end
    Screen('Close'); 
    
    %log each trial in case of crash 
    names_log={'cond','chosen_pumps1','chosen_pumps2','response_time1','response_time2','outcome'}
    log(trialNum,1)=cond(trialNum); % 1= high risk, 2= low risk, 3= neutral 
    log(trialNum,2)=resp1(trialNum);
    log(trialNum,3)=resp2(trialNum);
    log(trialNum,4)=RT_rep1(trialNum);
    log(trialNum,5)=RT_rep2(trialNum);
    log(trialNum,6)=outcome(trialNum);
    save safetylog

end
cd(subjectdir);
save([subID '.sBART.single.mat']); %for team round change to: save([subID '.sBART.team.mat']);
Screen('CloseAll');
Priority(oldPriorityLevel);
warning on;
cd('Taskfolder') %insert full path to the task folder
end
