function Task_Paradigm( Params, ScreenHandels, DATA )

% Filename: Task_Paradigm(Params, ScreenHandels, DATA)
%******************************************************************
% Description:
%   Runs TaskBlock based on given Task 
%       Run Polish Visuals Sentences
%
% Inputs:
%   Params: is Parameters of the Project
%   ScreenHandels: is the variable for Montior output
%   Task: is Task with all the information
%
% Output:
%   TrialVariables: all recorded information during Test	
%
%******************************************************************
%
% Written by Cameron Rodriguez
% Last Modified 2012/02
% Modded by Andrew Cho
% Last Modified 2014/09
%
%******************************************************************
%
% Dependecies:
%   None
% Used By:
%   StaglinPTB.m
%
%   see also: StaglinPTB, ExampleParadigmJitter, ...
%           Activate_Screens, RealTimeAnalysis 
%           [ 0 0 1280 1024 ] Horizontal, Vertical
%
%******************************************************************

%------------------------------------------------------------------
% SETUP -----------------------------------------------------------
%% Activate Keyboard
KbName('UnifyKeyNames');
FlushEvents('keyDown');

Keys.OKKey      = KbName('p');
Keys.KillKey    = KbName('k');
Keys.TRKey1     = KbName('t'); % TR signal key
Keys.TRKey2     = KbName('5'); % TR signal key
Keys.TRKB       = KbName('5%');  % Keyboard TR

%% Unpack Stucts
WES = ScreenHandels.WES;   % Window Handel Experimenter
RES = ScreenHandels.RES;   % Window Rectangle Experimenter
ifiE = ScreenHandels.ifiE; % interframe interval Experimenter
WSS = ScreenHandels.WSS;   % Window Handel Subject
RSS = ScreenHandels.RSS;   % Window Rectangle Subject
ifiS = ScreenHandels.ifiS; % interframe interval Subject

%% Sound Initiate
InitializePsychSound;

%% Texture Index
% Create Buffer
%TI = zeros(size(DATA.Images));
%INT = zeros(size(DATA.Instr.Images));
%
%% Make Textures for Images
%for i = 1:size(DATA.Images,2)
%    TI(i)=Screen('MakeTexture', WSS, DATA.Images{i});
%end 
%for i = 1:size(DATA.Instr.Images,2)
%    INT(i)=Screen('MakeTexture', WSS, DATA.Instr.Images{i});
%end 
 

% ----------------------------------------------------------------
% START SCAN -----------------------------------------------------
% Waiting for Scan to Begin
IntroText = 'Waiting for Scan to Begin ...';
DrawFormattedText(WSS, IntroText, 'center', 'center', 0 , 45);
Screen('Flip',WSS);

%% Wait for Trigger
while KbCheck(-1); end % clear keyboard queue
Scanning = 0;
while Scanning ~= 1
    [keyIsDown, TimePt, keyCode] = KbCheck(-1);
    if ( keyCode(Keys.TRKey1) | keyCode(Keys.TRKey2) | ... 
            keyCode(Keys.TRKB) )
        Scanning = 1; 
        disp('Scan Has Begun');
        StartTime = GetSecs;
    end 
end

% Keep KbCheck for looking for the TR signals
olddisabledkeys = DisableKeysForKbCheck([KbName('T'),KbName('5')]); 


% ----------------------------------------------------------------
% START TASK -----------------------------------------------------
%% Rest - Start Rest
% Draw White Screen
DrawWhiteScreen(WSS, RSS);

% Wait till Block
WaitSecs(DATA.Timing(2) - (GetSecs - StartTime)); 

% DATA.Timing(Counter)
COUNTER = 2;

% Text Size
Screen('TextSize', WSS, 70);

% Start Looping for Each Block
for i = 1:DATA.BlockTotalNum

    %% Rest Now - Block Rest
    % Display RestNow Image
    DrawFormattedText(WSS, DATA.Instr.rest, 'center', 'center', 0 , 45);
    Screen('Flip', WSS);

    %DrawImageCenter(WSS, INT(1), DATA.Instr.ImageSizes{1});
    % Play RestNow Sound
    %[Handel_RestNow] = PlaySound(DATA.Instr.Sounds{1}, ...
    %                        DATA.Instr.Channels{1}, DATA.Instr.Freqs{1});
    % Draw White Screen after 2.5 Seconds
    WaitSecs(2.5);
    DrawWhiteScreen(WSS, RSS);
    % Wait till Block
    COUNTER = COUNTER+1;
    WaitSecs(DATA.Timing(COUNTER) - (GetSecs - StartTime)); 


    %% Instructions 
    % Display Image One
    %DrawImageCenter(WSS, INT(2), DATA.Instr.ImageSizes{2});
    DrawFormattedText(WSS, DATA.Instr.think, 'center', 'center', 0 , 45);
    Screen('Flip', WSS);

    % Play RestNow Sound
    %[Handel_Instr] = PlaySound(DATA.Instr.Sounds{2}, ...
    %                        DATA.Instr.Channels{2}, DATA.Instr.Freqs{2});
    % Draw White Screen after 2.5 Seconds
    WaitSecs(.45);
    DrawWhiteScreen(WSS, RSS);
    % Wait till Block
    COUNTER = COUNTER+1;
    WaitSecs(DATA.Timing(COUNTER) - (GetSecs - StartTime)); 


    %% Image One
    % Display Image One
    %DrawImageCenter(WSS, TI(2*i-1), DATA.ImageSizes{2*i-1});
    DrawFormattedText(WSS, DATA.Sentence{4*i-3}, 'center', 'center', 0, 45);
    Screen('Flip', WSS);
    % Draw White Screen after 3 Seconds
    WaitSecs(2);
    DrawWhiteScreen(WSS, RSS);
    % Wait till Block
    COUNTER = COUNTER+1;
    WaitSecs(DATA.Timing(COUNTER) - (GetSecs - StartTime)); 

    %% Image Two
    % Display Image Two
    %DrawImageCenter(WSS, TI(2*i), DATA.ImageSizes{2*i});
    DrawFormattedText(WSS, DATA.Sentence{4*i-2}, 'center', 'center', 0, 45);
    Screen('Flip', WSS);
    % Draw White Screen after 3 Seconds
    WaitSecs(2.5);
    DrawWhiteScreen(WSS, RSS);
    % Wait till Block
    COUNTER = COUNTER+1;
    WaitSecs(DATA.Timing(COUNTER) - (GetSecs - StartTime)); 

    %% Image Three
    % Display Image Three 
    %DrawImageCenter(WSS, TI(2*i), DATA.ImageSizes{2*i});
    DrawFormattedText(WSS, DATA.Sentence{4*i-1}, 'center', 'center', 0, 45);
    Screen('Flip', WSS);
    % Draw White Screen after 3 Seconds
    WaitSecs(2.5);
    DrawWhiteScreen(WSS, RSS);
    % Wait till Block
    COUNTER = COUNTER+1;
    WaitSecs(DATA.Timing(COUNTER) - (GetSecs - StartTime)); 

    %% Image Four
    % Display Image Four
    %DrawImageCenter(WSS, TI(2*i), DATA.ImageSizes{2*i});
    DrawFormattedText(WSS, DATA.Sentence{4*i}, 'center', 'center', 0, 45);
    Screen('Flip', WSS);
    % Draw White Screen after 3 Seconds
    WaitSecs(2.5);
    DrawWhiteScreen(WSS, RSS);
    % Wait till Block
    COUNTER = COUNTER+1;
    WaitSecs(DATA.Timing(COUNTER) - (GetSecs - StartTime)); 


    %% Cleanup Block
    % Close Sound Instruction
    %PsychPortAudio('Stop', Handel_RestNow); 
    %PsychPortAudio('Close', Handel_RestNow); 
    %PsychPortAudio('Stop', Handel_Instr); 
    %PsychPortAudio('Close', Handel_Instr); 
end


% -----------------------------------------------------------------
% Finish Up -------------------------------------------------------
% Draw a White Screen
DrawWhiteScreen(WSS, RSS);

% End Function
end


% ----------------------------------------------------------------- 
% Subfunctions ----------------------------------------------------
% Function: Play Sound
function [ SoundHandel ] = PlaySound( SoundData, Channel, SoundFreq )
    SoundHandel = PsychPortAudio('Open', [], [], 0, SoundFreq, Channel);
    PsychPortAudio('FillBuffer', SoundHandel, SoundData');
    StartMusic = PsychPortAudio('Start', SoundHandel, 1, 0, 1);
end

% Function: Draw Text
function [ TimeStamp ] = DrawText(WSS, DisplayText)
    % Draw / Display Text            
    DrawFormattedText(WSS, DisplayText, 'center', 'center', 0 , 45);
    TimeStamp = Screen('Flip',WSS);
end

% Function: Draw White Screen
function [ TimeStamp ] = DrawWhiteScreen(WSS, RSS)
    % Draw / Display Fixation Point              
    white = WhiteIndex(WSS);
    Screen('FillRect', WSS, white , RSS);
    Screen('DrawingFinished', WSS);
    TimeStamp = Screen('Flip',WSS);
end

% Function: Draw Image Center
function [TimeStamp] = DrawImageCenter(WSS, Image, ImageSize)
    % Set Image Size     
    SourceImageSize = [0 0 ImageSize(2) ImageSize(1)];
    
    % Image Destination
    Screen('DrawTexture', WSS, Image, SourceImageSize);
    
    % Flip Screen
    TimeStamp = Screen('Flip',WSS);
end

