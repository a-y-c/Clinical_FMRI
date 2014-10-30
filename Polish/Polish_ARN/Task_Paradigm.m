function Task_Paradigm( Params, ScreenHandels, DATA )

% Filename: Task_Paradigm(Params, ScreenHandels, DATA)
%******************************************************************
% Description:
%   Runs TaskBlock based on given Task 
%       Runs Polish Audio 
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
INT = zeros(size(DATA.Instr.Images));

% Make Textures for Images
for i = 1:size(DATA.Instr.Images,2)
    INT(i)=Screen('MakeTexture', WSS, DATA.Instr.Images{i});
end 
 

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

% Start Looping for Each Block
for i = 1:DATA.BlockTotalNum

    %% Rest Now - Block Rest
    % Display RestNow Image
    %DrawImageCenter(WSS, INT(1), DATA.Instr.ImageSizes{1});
    % Play RestNow Sound
    [Handel_RestNow] = PlaySound(DATA.Instr.Sounds{1}, ...
                            DATA.Instr.Channels{1}, DATA.Instr.Freqs{1});
    % Draw White Screen after 3 Seconds
    WaitSecs(2.5);
    DrawWhiteScreen(WSS, RSS);
    % Wait till Block
    COUNTER = COUNTER+1;
    WaitSecs(DATA.Timing(COUNTER) - (GetSecs - StartTime)); 


    %% Instructions 
    % Display Image One
    %DrawImageCenter(WSS, INT(2), DATA.Instr.ImageSizes{2});
    % Play RestNow Sound
    [Handel_Instr] = PlaySound(DATA.Instr.Sounds{2}, ...
                            DATA.Instr.Channels{2}, DATA.Instr.Freqs{2});
    % Draw White Screen after 3 Seconds
    WaitSecs(2.5);
    DrawWhiteScreen(WSS, RSS);
    % Wait till Block
    COUNTER = COUNTER+1;
    WaitSecs(DATA.Timing(COUNTER) - (GetSecs - StartTime)); 

    %% Sound One
    ii = i*2 - 1;
    [Handel_One] = PlaySound(DATA.Sounds{ii}, ...
                            DATA.Channels{ii}, DATA.Freqs{ii});
    % Wait till Block
    COUNTER = COUNTER+1;
    WaitSecs(DATA.Timing(COUNTER) - (GetSecs - StartTime)); 

    %% Sound Two
    ii = i*2;
    [Handel_Two] = PlaySound(DATA.Sounds{ii}, ...
                        DATA.Channels{ii}, DATA.Freqs{ii});
    % Wait till Block
    COUNTER = COUNTER+1;
    WaitSecs(DATA.Timing(COUNTER) - (GetSecs - StartTime)); 


    % Close Sound RestNow
    PsychPortAudio('Stop', Handel_RestNow); 
    PsychPortAudio('Close', Handel_RestNow); 
    % Close Sound Instruction
    PsychPortAudio('Stop', Handel_Instr); 
    PsychPortAudio('Close', Handel_Instr); 
    % Close Sound One
    PsychPortAudio('Stop', Handel_One); 
    PsychPortAudio('Close', Handel_One); 
    % Close Sound Two
    PsychPortAudio('Stop', Handel_Two); 
    PsychPortAudio('Close', Handel_Two); 
    % Delay is Captured by Block Rest in the Beginning
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


