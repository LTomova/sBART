
function sBART_fMRI_joystick_team
%% for usage with MRI compatible joystick
%% sBART: social Balloon Analogue Risk Task
% description of task and experimental procedures in: https://www.nature.com/articles/s41598-018-23455-7
% task is an adapted version from automatic BART by Pleskac, T.J., Wallsten, T.S, Wang, P. &
% Lejuez, C.W. (2008)
% written for PTB Version 3.0.8 running on Windows 10 OS
% 24 trials per cond, 6 runs each 12 trials long (approx. 6min)
% this runs team version of the task
% command to start sBART: sBART_fMRI_joystick_team;
% written by Livia Tomova, 2017



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%duration how long participants can take to make their decision
respDur=5;

% subj_id
subID = input('Enter the Subject ID: ');
%run = input ('Enter run number: ');

% create folder for logfiles
path = '.\log_sBART_fMRI';
subjectdir = fullfile(path,sprintf('sBART_fMRI_%s%d',subID));
exdir=exist(subjectdir);
if exdir== 7
    sprintf('A folder with this name already exists. The experiment is stopped to not overwrite any data.')
    return
else
    mkdir(path,sprintf('sBART_fMRI_%s%d',subID));
end

%conditons:
% 1= high risk 24 trials
% 2= low risk 24 trials
% 3= neutral 24 trials
% a randomization will be made for each session (6 sessions, 12 trials per session)

%old but for backup left here: fixed order of 72 trials
%cond=[2 1 3 2 3 1 1 2 3 1 3 2 3 1 2 3 2 1 2 1 3 2 3 1 1 2 3 1 3 2 3 1 2 3 2 1 2 1 3 2 3 1 1 2 3 1 3 2 3 1 2 3 2 1 2 1 3 2 3 1 1 3 2 3 1 1 2 3 1 3 2 3];

%fixed explosion points for each trial (taken from automatic BART by Pleskac et al. 2008 -
%original has 30 trials so explosion point vector doubled here (just same
%numbers repeated)
expl = [64 105 39 96 88 21 121 10 64 32 64 101 26 34 47 121 64 95 75 13 64 112 30 88 9 64 91 17 115 50 64 105 39 96 88 21 121 10 64 32 64 101 26 34 47 121 64 95 75 13 64 112 30 88 9 64 91 17 115 50 64 105 39 96 88 21 121 10 64 32 64 101];


%load jitter distributions
load DurTest
% configurations
HideCursor;
Screen('Preference', 'SkipSyncTests', 0); % set to 1 on laptop; 0 on scanner
displays = max(Screen('Screens')); %Highest screen number is most likely correct display
[window,screenRect] = Screen('OpenWindow', displays,0);
scrnRes     = Screen('Resolution',displays(end));               % Get Screen resolution
[x0, y0]		= RectCenter([0 0 scrnRes.width scrnRes.height]);   % Screen center.
Screen('Preference', 'VisualDebugLevel', 0); %surpressess warning at beginning of ptb start
InitializePsychSound(1);

% load balloon pics
balloon=imread('balloon.jpg');
poppedballoon=imread('poppedballoon.jpg');
scale = imread('ratingscale_vert.jpg');
fill = imread('fil_vert.jpg');

% load sounds
inflate= 'inflate.wav';
pop='explosion.wav';
cash='casino.wav';


%create size of ratingscale on screen
destrect_sc=[510,250,650,750];

%create size of balloon for question screen
destrect_bl=[800,150,1000,322];

penWidthPixels = 4;% Pen width for the frame
%create background screen (white)
Screen('FillRect', window, [255,255,255])


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
hr_ch1 = round(75+(127-75)*rand(1,72));
hr_ch2 = round(75+(127-75)*rand(1,72));
lr_ch1 = round(1+(53-1)*rand(1,72));
lr_ch2 = round(1+(53-1)*rand(1,72));
n_ch = round(54+(74-54)*rand(1,72));
n_ch1 = round(54+(74-54)*rand(1,72));
n_ch2 = round(54+(74-54)*rand(1,72));
n_ch3 = round(54+(74-54)*rand(1,72));

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
title = 'Team round';
instructions1 = 'Pump up each balloon (max pumps: 128).';
waiting = 'Waiting for responses of all teammembers...';
ques='How many times do you want to pump up the balloon?';
teamchinfo = 'Choices of your teammembers';
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
%DrawFormattedText(window, instructions2,'center',800,[1,1,1],40);
balloonTex = Screen('MakeTexture',window,balloon);
Screen('DrawTexture',window,balloonTex, [], destrect);
Screen('Flip',window);
WaitSecs(3);

% Setting up response keys - imac never worked...
delete(instrfindall);
clear s;


% Choose your keyboard for responses:
%Keyboard    = 'imac';
Keyboard    = 'cedrus';
%Keyboard    = 'windows';

switch Keyboard
    case 'imac'
        ResponseKeys = [30:33];  % Keys 30-33 = [1!,2@,3#,4$]
        triggerKey			= '+';
    case 'cedrus'
        ResponseKeys = {'1','2','3'};
        triggerKey			= {'5','6'};
    case 'windows'
        ResponseKeys = [49:52]; % Keys 97-100 = [1,2,3,4], Keys 49-52 = [1!,2@,3#,4$]
        triggerKey   = '+';%'3';
        
    otherwise
        ResponseKeys = [89:92];  % Keys 89-92 = [1,2,3,4]
        triggerKey			= '+';
end



% START run loop

count=0;
for run = 1:1
    %create cond order (random permutations of four times 1,2,3)
    condpm=randperm(3);
    condtmp=perms(condpm);
    cond(1,1:3)=condtmp(1,1:3);
    cond(1,4:6)=condtmp(2,1:3);
    cond(1,7:9)=condtmp(3,1:3);
    cond(1,10:12)=condtmp(4,1:3);
    text1 =[ 'Team round. Run ', num2str(run),' of 1'];
    DrawFormattedText(window, text1,'center','center',[1,1,1],40);
    Screen('Flip',window);
    
    
    if strcmp(Keyboard,'cedrus')
        % Disconnect and delete all instrument objects in case any previous
        % code did not cleanup properly.
        %instrreset;
        
        % Open serial port, set properties
        s = serial('COM3');
        set ( s, 'baudrate',         9600  );
        set ( s, 'databits',            8  );
        set ( s, 'parity',          'None' );
        set ( s, 'stopbits',            1  );
        set ( s, 'flowcontrol',     'None' );
        set ( s, 'inputbuffersize',     1  );
        set ( s, 'outputbuffersize',    1  );
        set ( s, 'baudrate',        19200  );
        set ( s, 'timeout',         0.001  );
        set ( s, 'terminator',    char(0)  );
        fopen(s)
        
        
        
        % Wait for response
        tic
        while (toc<999) % Wait for a while before timeout (i.e. 999 seconds)
            if s.bytesavailable
                serial_inputs = fscanf(s);
                if any(strcmp(serial_inputs, triggerKey))
                    break
                end
            end
        end
    else
        
        while 1
            FlushEvents('keyDown');
            trig = GetChar;
            if strcmp(trig, triggerKey);
                break
            end
        end
    end
    
    %WaitSecs('YieldSecs', 3.0);
    triggerTime = GetSecs;
    RunStart=GetSecs;
    Screen('Close');
    
    %get ready
    instructions = '+';
    Screen(window,'TextSize',36);
    DrawFormattedText(window, instructions,'center','center',[1,1,1],40);
    Screen('Flip',window);
    WaitSecs(6);
    Screen('Close');
    Screen('FillRect', window, [255,255,255])
    
    
    
    %% trialstart
    for trialNum = 1:10
        trialStart=GetSecs;
        Screen('FillRect', window, [255,255,255])
        count = count+1;
        %draw fixation cross (jittered duration)
        DrawFormattedText(window, '+','center','center',[1,1,1],40);
        Screen('Flip',window);
        WaitSecs(jit1(count));
        Screen('Close');
        
        trialcond(trialNum,1)=cond(trialNum);
        trialexpl(trialNum,1)= expl(count);
        
        %assign choices of other players based on condition
        if trialcond(trialNum,1) == 1
            ch1trial(trialNum,1)= hr_ch1(count);
            ch2trial(trialNum,1)= hr_ch2(count);
            ch3trial(trialNum,1)= n_ch(count);
        elseif trialcond(trialNum,1) == 2
            ch1trial(trialNum,1)= lr_ch1(count);
            ch2trial(trialNum,1)= lr_ch2(count);
            ch3trial(trialNum,1)= n_ch(count);
        elseif trialcond(trialNum,1) == 3
            ch1trial(trialNum,1)= n_ch1(count);
            ch2trial(trialNum,1)= n_ch2(count);
            ch3trial(trialNum,1)= n_ch3(count);
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
        
        %starting values for scale
        pos = 500; %starting position of fil
        destrect_fl=[510,pos,650,750]; %create first fill location
        rx=64;
        pumps = '64';
        
        %create screen with first question
        responseStart = GetSecs;
        Response1Start=responseStart;
        confirm = 0;
        
        %draw first scale
        % Screen('FrameRect', window, [1 0 0], destrect_lw, penWidthPixels);
        ratingscale= Screen('MakeTexture',window,scale);
        fillscale= Screen('MakeTexture',window,fill);
        balloonTex = Screen('MakeTexture',window,balloon);
        Screen('DrawTexture',window,ratingscale, [], destrect_sc);
        Screen('DrawTexture',window,fillscale, [], destrect_fl);
        Screen('DrawTexture',window,balloonTex, [], destrect_bl);
        DrawFormattedText(window, pumps,400,500,[1,1,1],40);
        Screen('Flip',window);
        
        
        thiskey=0;
        FlushEvents('keyDown');
        
        
        %time for participants to respond
        % stop= response1Start + 30;
        stop= responseStart + respDur;
        
        while GetSecs < stop %wait for confirm button press and make sure screen coordinates work
            
            %DisableKeysForKbCheck([87 46 34 6 54 162]); you  might need this
            %for controlling for input of scanner trigger
            
            
            % for scanner button box
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %             %wait for keypress
            %             thiskey = 0;
            %
            %             if s.bytesavailable
            %             serial_inputs = fscanf(s);
            %
            %             if any(strcmp(serial_inputs, ResponseKeys))
            %                 thiskey = str2num(serial_inputs);
            %
            %             end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % for keyboard
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %             %wait for keypress
            %             [a , b, keyCode] = KbCheck(-3);
            %             if a  %if keypress occurs
            %                 Key = find(keyCode); %% find keycode of key that was pressed
            %                 thiskey = KbName(Key(1)); %% figure out its name (taking only the first button if subjects hit more than one)
            %                 thiskey = str2double(thiskey(1)); %% make it a number, taking only the first (since KbName can return multiple e.g. 1! instead of 1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            % for joystick
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [p,b] = mat_joy(0);
            y_start=p(2,1)
            [p,b] = mat_joy(0);
            y=p(2,1)
            buttons=b;
            thispress1(trialNum,1:16)=buttons;
            
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %for Joystick
            
            if (y > y_start) || (y > 0) %if joystick is moved backwards or all the way to the back
                pos = pos + 3.5; %going down
                rx = rx - 1; %subtract x for each move that is made down
                if (pos >= 725) || (rx < 0)  %if limit reached stop moving
                    pos=725;
                    rx = 0;
                else   %as long as no limit reached keep showing changes
                    pumps =  num2str(rx);
                    destrect_fl=[510,pos,650,750];
                    %draw whole scale again with new fill and numbers
                    ratingscale= Screen('MakeTexture',window,scale);
                    fillscale= Screen('MakeTexture',window,fill);
                    balloonTex = Screen('MakeTexture',window,balloon);
                    Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                    Screen('DrawTexture',window,fillscale, [], destrect_fl);
                    Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                    DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                    Screen('Flip',window);
                    if ((pos >= 725) && (rx ~= 0)) %if limit on scale reached but number of pumps not on limit, keep moving
                        pos=725;
                        rx = rx - 1;
                        pumps = num2str(rx);%change number of pumps on screen
                        destrect_fl=[510,pos,650,750];
                        %draw whole scale again with new fill and numbers
                        ratingscale= Screen('MakeTexture',window,scale);
                        fillscale= Screen('MakeTexture',window,fill);
                        balloonTex = Screen('MakeTexture',window,balloon);
                        Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                        Screen('DrawTexture',window,fillscale, [], destrect_fl);
                        Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                        DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                        Screen('Flip',window);
                    else
                        pumps = num2str(rx);%change number of pumps on screen
                        destrect_fl=[510,pos,650,750];
                        %draw whole scale again with new fill and numbers
                        ratingscale= Screen('MakeTexture',window,scale);
                        fillscale= Screen('MakeTexture',window,fill);
                        balloonTex = Screen('MakeTexture',window,balloon);
                        Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                        Screen('DrawTexture',window,fillscale, [], destrect_fl);
                        Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                        DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                        Screen('Flip',window);
                    end
                end
            elseif (y < y_start) || (y == -1) %if joystick is moved forwards or all the way to the front
                pos = pos - 3.5; %going up
                rx = rx + 1;
                if (pos <= 275) || (rx > 128)
                    pos=275;
                    rx = 128;
                else
                    pumps =  num2str(rx);
                    destrect_fl=[510,pos,650,750];
                    %draw whole scale again with new fill and numbers
                    ratingscale= Screen('MakeTexture',window,scale);
                    fillscale= Screen('MakeTexture',window,fill);
                    balloonTex = Screen('MakeTexture',window,balloon);
                    Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                    Screen('DrawTexture',window,fillscale, [], destrect_fl);
                    Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                    DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                    Screen('Flip',window);
                    if ((pos <= 275) && (rx ~= 128))
                        pos=275;
                        rx = rx + 1;
                        pumps =  num2str(rx);
                        destrect_fl=[510,pos,650,750];
                        %draw whole scale again with new fill and numbers
                        ratingscale= Screen('MakeTexture',window,scale);
                        fillscale= Screen('MakeTexture',window,fill);
                        balloonTex = Screen('MakeTexture',window,balloon);
                        Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                        Screen('DrawTexture',window,fillscale, [], destrect_fl);
                        Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                        DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                        Screen('Flip',window);
                    else
                        pumps =  num2str(rx);
                        destrect_fl=[510,pos,650,750];
                        %draw whole scale again with new fill and numbers
                        ratingscale= Screen('MakeTexture',window,scale);
                        fillscale= Screen('MakeTexture',window,fill);
                        balloonTex = Screen('MakeTexture',window,balloon);
                        Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                        Screen('DrawTexture',window,fillscale, [], destrect_fl);
                        Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                        DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                        Screen('Flip',window);
                    end
                end
            elseif buttons (7,1) == 1 %if confirm key is pressed
                RT_resp1(trialNum) = GetSecs- responseStart;
                confirm = 1;
                %paint ratingscale
                ratingscale= Screen('MakeTexture',window,scale);
                fillscale= Screen('MakeTexture',window,fill);
                balloonTex = Screen('MakeTexture',window,balloon);
                Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                Screen('DrawTexture',window,fillscale, [], destrect_fl);
                Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                %make black frame around rectangle
                Screen('FrameRect', window, [1 0 0], destrect_sc, penWidthPixels);
                Screen('Flip',window);
                save safetylog
                if GetSecs < (responseStart + respDur)
                    xy = stop - RT_resp1(trialNum)
                    ay=xy-responseStart;
                    WaitSecs(ay);
                end
                Screen('Close');

            end
        end
        
        resp1(trialNum,1)=rx;
        if confirm ~= 1
            resp1(trialNum,1)=9999;
            RT_resp1(trialNum)=9999;
            continue
        end
        clear pos
        clear rx
        clear pumps
        
        Response1End=GetSecs;
        
        %pretend to wait until all responses collected
        DrawFormattedText(window,waiting,'center','center',[1,1,1],40);
        Screen('Flip',window);
        WaitSecs(wait(count));
        Screen('Close');
        
        %see choices of others
        DrawFormattedText(window, teamchinfo,'center',300,[1,1,1],40);
        DrawFormattedText(window, teamch1,100,500,[255,0,0],40);
        DrawFormattedText(window, teamch2,100,600,[255,0,0],40);
        DrawFormattedText(window, teamch3,100,700,[255,0,0],40);
        Screen('Flip',window);
        OtherInfoStart=GetSecs;
        WaitSecs(3);
        Screen('Close');
        OtherInfoEnd=GetSecs;
        
        %draw fixation cross (jittered duration)
        DrawFormattedText(window, '+','center','center',[1,1,1],40);
        Screen('Flip',window);
        WaitSecs(jit2(count));
        Screen('Close');
        
        
        %starting values for scale
        pos = 500; %starting position of fil
        destrect_fl=[510,pos,650,750]; %create first fill location
        rx=64;
        pumps = '64';
        
        %create screen with first question
        responseStart = GetSecs;
        Response2Start=responseStart;
        confirm = 0;
        
        %draw first scale
        ratingscale= Screen('MakeTexture',window,scale);
        fillscale= Screen('MakeTexture',window,fill);
        balloonTex = Screen('MakeTexture',window,balloon);
        Screen('DrawTexture',window,ratingscale, [], destrect_sc);
        Screen('DrawTexture',window,fillscale, [], destrect_fl);
        Screen('DrawTexture',window,balloonTex, [], destrect_bl);
        DrawFormattedText(window, pumps,400,500,[1,1,1],40);
        Screen('Flip',window);
        
        
        thiskey=0;
        FlushEvents('keyDown');
        
        stop=responseStart+ respDur;
        
        while GetSecs < stop %wait for ckey press and make sure screen coordinates work
            
            %DisableKeysForKbCheck([87 46 34 6 54 162]); you  might need this
            %for controlling for input of scanner trigger
            
            
            % for scanner button box
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %             %wait for keypress
            %             thiskey = 0;
            %
            %             if s.bytesavailable
            %             serial_inputs = fscanf(s);
            %
            %             if any(strcmp(serial_inputs, ResponseKeys))
            %                 thiskey = str2num(serial_inputs);
            %
            %             end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % for keyboard
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %             %wait for keypress
            %             [a , b, keyCode] = KbCheck(-3);
            %             if a  %if keypress occurs
            %                 Key = find(keyCode); %% find keycode of key that was pressed
            %                 thiskey = KbName(Key(1)); %% figure out its name (taking only the first button if subjects hit more than one)
            %                 thiskey = str2double(thiskey(1)); %% make it a number, taking only the first (since KbName can return multiple e.g. 1! instead of 1)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            % for joystick
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [p,b] = mat_joy(0);
            y_start=p(2,1);
            [p,b] = mat_joy(0);
            y=p(2,1);
            buttons=b;
            thispress2(trialNum,1:16)=buttons;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %Joystick version:
            if (y > y_start) || (y > 0) %joystick moved backwards
                %  while pos < 725
                pos = pos + 3.5; %going DOWN!
                rx = rx - 1; %subtract x for each move that is made down
                %pos = pos + 3.5; %move cursor on screen
                if (pos >= 725) || (rx < 0)  %if limit reached stop moving
                    pos=725;
                    rx = 0;
                else
                    pumps =  num2str(rx);
                    destrect_fl=[510,pos,650,750];
                    %draw whole scale again with new fill and numbers
                    ratingscale= Screen('MakeTexture',window,scale);
                    fillscale= Screen('MakeTexture',window,fill);
                    balloonTex = Screen('MakeTexture',window,balloon);
                    Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                    Screen('DrawTexture',window,fillscale, [], destrect_fl);
                    Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                    DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                    Screen('Flip',window);
                    if ((pos >= 725) && (rx ~= 0))
                        pos=725;
                        rx = rx - 1;
                        pumps = num2str(rx);%change number of pumps on screen
                        destrect_fl=[510,pos,650,750];
                        %draw whole scale again with new fill and numbers
                        ratingscale= Screen('MakeTexture',window,scale);
                        fillscale= Screen('MakeTexture',window,fill);
                        balloonTex = Screen('MakeTexture',window,balloon);
                        Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                        Screen('DrawTexture',window,fillscale, [], destrect_fl);
                        Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                        DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                        Screen('Flip',window);
                    else
                        pumps = num2str(rx);%change number of pumps on screen
                        destrect_fl=[510,pos,650,750];
                        %draw whole scale again with new fill and numbers
                        ratingscale= Screen('MakeTexture',window,scale);
                        fillscale= Screen('MakeTexture',window,fill);
                        balloonTex = Screen('MakeTexture',window,balloon);
                        Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                        Screen('DrawTexture',window,fillscale, [], destrect_fl);
                        Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                        DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                        Screen('Flip',window);
                    end
                end
            elseif (y < y_start) || (y == -1) %if joystick is moved forward
                pos = pos - 3.5; %going UP!
                rx = rx + 1;
                if (pos <= 275) || (rx > 128)
                    pos=275;
                    rx = 128;
                else
                    pumps =  num2str(rx);
                    destrect_fl=[510,pos,650,750];
                    %draw whole scale again with new fill and numbers
                    ratingscale= Screen('MakeTexture',window,scale);
                    fillscale= Screen('MakeTexture',window,fill);
                    balloonTex = Screen('MakeTexture',window,balloon);
                    Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                    Screen('DrawTexture',window,fillscale, [], destrect_fl);
                    Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                    DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                    Screen('Flip',window);
                    if ((pos <= 275) && (rx ~= 128))
                        pos=275;
                        rx = rx + 1;
                        pumps =  num2str(rx);
                        destrect_fl=[510,pos,650,750];
                        %draw whole scale again with new fill and numbers
                        ratingscale= Screen('MakeTexture',window,scale);
                        fillscale= Screen('MakeTexture',window,fill);
                        balloonTex = Screen('MakeTexture',window,balloon);
                        Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                        Screen('DrawTexture',window,fillscale, [], destrect_fl);
                        Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                        DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                        Screen('Flip',window);
                    else
                        pumps =  num2str(rx);
                        destrect_fl=[510,pos,650,750];
                        %draw whole scale again with new fill and numbers
                        ratingscale= Screen('MakeTexture',window,scale);
                        fillscale= Screen('MakeTexture',window,fill);
                        balloonTex = Screen('MakeTexture',window,balloon);
                        Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                        Screen('DrawTexture',window,fillscale, [], destrect_fl);
                        Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                        DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                        Screen('Flip',window);
                    end
                end
            elseif buttons (7,1) == 1
                RT_resp2(trialNum) = GetSecs- responseStart;
                confirm = 1;
                %paint ratingscale
                ratingscale= Screen('MakeTexture',window,scale);
                fillscale= Screen('MakeTexture',window,fill);
                balloonTex = Screen('MakeTexture',window,balloon);
                Screen('DrawTexture',window,ratingscale, [], destrect_sc);
                Screen('DrawTexture',window,fillscale, [], destrect_fl);
                Screen('DrawTexture',window,balloonTex, [], destrect_bl);
                DrawFormattedText(window, pumps,400,500,[1,1,1],40);
                %make black frame around rectangle
                Screen('FrameRect', window, [1 0 0], destrect_sc, penWidthPixels);
                Screen('Flip',window);
                if GetSecs < stop
                    xy = stop - RT_resp2(trialNum)
                    ay=xy-responseStart;
                    WaitSecs(ay);
                end
                Screen('Close');

            end
        end
        
        resp2(trialNum,1)=rx;
        if confirm ~= 1
            resp2(trialNum,1)=9999;
            RT_resp2(trialNum)=9999;
            continue
        end
        clear pos
        clear rx
        clear pumps
        
        Response2End=GetSecs;
        
        %info about your final choice
        finchoice = ['Your choice:' num2str(resp2(trialNum))];
        DrawFormattedText(window, finchoice,'center',300,[1,1,1],40);
        Screen('Flip',window);
        ChoiceInfoStart=GetSecs;
        WaitSecs(1);
        Screen('Close');
        ChoiceInfoEnd=GetSecs;
        
        %blow up balloon
        balloonTex = Screen('MakeTexture',window,balloon); %initial size
        Screen('DrawTexture',window,balloonTex, [], destrect);
        Screen('Flip',window);
        BalloonStart=GetSecs;
        WaitSecs(1);
        SoundOut(1,inflate); %sound

 %skipping 2 sizes during inflation as it takes too  long (>3.5s)
 %for this design (goal here is 2s) - but the sizes can be added
 %in case the inflation duration should be longer
        
%         %size2
%         Screen('DrawTexture',window,balloonTex, [], destrect1);
%         Screen('Flip',window);
%         %WaitSecs(2);
%         SoundOut(1,inflate); %sound
        
        %size 3
        Screen('DrawTexture',window,balloonTex, [], destrect2);
        Screen('Flip',window);
        SoundOut(1,inflate); %sound
        
%         %size 4
%         Screen('DrawTexture',window,balloonTex, [], destrect3);
%         Screen('Flip',window);
%         %WaitSecs(2);
%         SoundOut(1,inflate); %sound
        
        BalloonEnd=GetSecs;
        
        if resp2(trialNum) > trialexpl(trialNum)
            outcome(trialNum)=2; %2=no win on this trial
            balloonTex = Screen('MakeTexture',window,poppedballoon);
            Screen('DrawTexture',window,balloonTex, [], destrect4);
            Screen('Flip',window);
            OutcomeStart=GetSecs;
            SoundOut(1,pop);
            WaitSecs(0.5);
            Screen('DrawTexture',window,balloonTex, [], destrect4);
            nowin = 'No win. No points.';
            DrawFormattedText(window, nowin,'center',100,[1,1,1],40);
            Screen('Flip',window);
            WaitSecs(0.5);
        else
            outcome(trialNum)=1; %1=win on this trial
            Screen('DrawTexture',window,balloonTex, [], destrect4);
            Screen('Flip',window);
            OutcomeStart=GetSecs;
            WaitSecs(0.5)
            win = ['You win!!! + ' num2str(resp2(trialNum)) 'points!!'];
            Screen('DrawTexture',window,balloonTex, [], destrect4);
            DrawFormattedText(window, win,'center',100,[1,1,1],40);
            SoundOut(1,cash);
            Screen('Flip',window);
            WaitSecs(0.5)
            
        end
        Screen('Close');
        OutcomeEnd=GetSecs;
        
        %log each trial in case of crash
        
        %behavioral log columns explained in names_log (outcome: 1=win,2=loss)
        names_log={'cond','chosen_pumps1','chosen_pumps2','response_time1','response_time2','outcome'}
        log(trialNum,1)=cond(trialNum); % 1= high risk, 2= low risk, 3= neutral
        log(trialNum,2)=resp1(trialNum);
        log(trialNum,3)=resp2(trialNum);
        log(trialNum,4)=RT_resp1(trialNum);
        log(trialNum,5)=RT_resp2(trialNum);
        log(trialNum,6)=outcome(trialNum);
        
        runlog(count,1)=jit1(count);
        runlog(count,2)=jit2(count);
        runlog(count,3)=wait(count);
        
        onsets_names={'experimentStart','trialStart', 'Response1Start', 'OtherInfoStart', 'Response2Start', 'ChoiceInfoStart', 'BalloonStart','OutcomeStart'};
        
        onsets(trialNum,1)=experimentStart;
        onsets(trialNum,2)=trialStart;
        onsets(trialNum,3)=Response1Start;
        onsets(trialNum,4)=OtherInfoStart;
        onsets(trialNum,5)=Response2Start;
        onsets(trialNum,6)=ChoiceInfoStart;
        onsets(trialNum,7)=BalloonStart;
        onsets(trialNum,8)=OutcomeStart;
        
        
        duration_resp1(trialNum)=Response1End-Response1Start; %this is not RT! just how long scale was on screen (RT is stored in variable RT_resp1)
        duration_other(trialNum)=OtherInfoEnd - OtherInfoStart;
        duration_resp2(trialNum)=Response2End-Response2Start; %this is not RT! just how long scale was on screen (RT is stored in variable RT_resp2)
        duration_choice(trialNum)=ChoiceInfoEnd-ChoiceInfoStart;
        duration_balloon(trialNum)=BalloonEnd-BalloonStart;
        duration_outcome(trialNum)=OutcomeEnd-OutcomeStart;
        
        trialEnd=GetSecs;
        trialDur(trialNum)=trialEnd-trialStart;
        
        
        save safetylog
        
        
    end
    %fixation cross at the end of each run
    DrawFormattedText(window, '+','center','center',[1,1,1],40);
    Screen('Flip',window);
    WaitSecs(10)
    Screen('Close');
    RunEnd=GetSecs;
    RunDur=RunEnd-RunStart;
    Screen('FillRect', window, [255,255,255])
    
    if strcmp(Keyboard,'cedrus')
        fclose(s)
    end
    
    %if last session display endtext
    if run == 1
        text2='End of team round.';
        text3='Thank you.';
        DrawFormattedText(window, text2,'center',100,[1,1,1],40);
        DrawFormattedText(window, text3,'center',200,[1,1,1],40);
        balloonTex = Screen('MakeTexture',window,balloon);
        Screen('DrawTexture',window,balloonTex, [], destrect);
        Screen('Flip',window);
        cd(subjectdir);
        save([subID '.sBART_fmri_run', num2str(run),'.mat']);
        cd ('Taskfolder') %insert full path to the task folder
        WaitSecs(6);
        Screen('Close');
        %if not last session display brake text
    else
        text2='End of this run. We will take a quick break.';
        Screen(window,'TextSize',30);
        DrawFormattedText(window, text2,'center',100,[1,1,1],40);
        balloonTex = Screen('MakeTexture',window,balloon);
        Screen('DrawTexture',window,balloonTex, [], destrect);
        Screen('Flip',window);
        cd(subjectdir);
        save([subID '.sBART_fmri_run', num2str(run),'.mat']);
        cd ('Taskfolder') %insert full path to the task folder
        KbWait;
        Screen('Close');
    end
    
    
end
Screen('CloseAll');
Priority(oldPriorityLevel);
warning on;
end

