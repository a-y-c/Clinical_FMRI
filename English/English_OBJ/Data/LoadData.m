function [ DATA ] = LoadData 

% Filename: LoadData.m
%******************************************************************
%
% Description:
%   Loads Data (sentences, pictures) to be used for each Task
%
% Output: Task
% 	
%******************************************************************
%
% Written by Andrew Cho
% Last Modified 2012/05/08
%
%******************************************************************
%
% Dependencies:
%	SoundLoader.m 	
%					Loads Sound Files into Task
%	ImageLoader.m
%					Loads Images Files into Task
% Used By:
%	StaglinPTB.m
% 	
%******************************************************************


% -----------------------------------------------------------------
% SETTINGS --------------------------------------------------------
% Image Directories
OBJDIR = 'OBJ';
% Instruction Directory 
INSTRDIR = 'INSTR';

% Timing Variables
DATA.BlockTotalNum = 12;
Intro_Time = .5;
First_Block_Time = 2.5;
Block_Time = 3;
Rest_Time = 12;


% -----------------------------------------------------------------
% DATA ------------------------------------------------------------
fprintf('Loading Timing ...\n\n')

% Timing - Beginning of Time
DATA.Timing(1) = 0;
% Timing - START REST 
DATA.Timing(2) = 6;
% DATA.Timing(COUNTER)
COUNTER = 2;

% Timing - Start of Block
for i = 1:DATA.BlockTotalNum
    % Timing - REST
    COUNTER = COUNTER+1;
    DATA.Timing(COUNTER) = DATA.Timing(COUNTER-1) + Rest_Time;

    % Timing - INTRO
    COUNTER = COUNTER+1;
    DATA.Timing(COUNTER) = DATA.Timing(COUNTER-1) + Intro_Time;

    % Timing - Image1
    COUNTER = COUNTER+1;
    DATA.Timing(COUNTER) = DATA.Timing(COUNTER-1) + First_Block_Time;

    % Timing - Image2
    COUNTER = COUNTER+1;
    DATA.Timing(COUNTER) = DATA.Timing(COUNTER-1) + Block_Time;
    
    % Timing - Image3
    COUNTER = COUNTER+1;
    DATA.Timing(COUNTER) = DATA.Timing(COUNTER-1) + Block_Time;

    % Timing - Image4
    COUNTER = COUNTER+1;
    DATA.Timing(COUNTER) = DATA.Timing(COUNTER-1) + Block_Time;
end
% TIME TOTAL = 245 seconds

% Message
fprintf('Timing Loaded.\n\n')


% ------------------------------------------------------------------
% Load Images ------------------------------------------------------
fprintf('Loading Images ...\n\n')

% Load Images
[ DATA.Images, DATA.ImageNames, DATA.ImageSizes ] = ImageLoader(OBJDIR);

% Message
fprintf('Images Loaded.\n\n')

% ------------------------------------------------------------------
% Load Instructions ------------------------------------------------
fprintf('Loading Instructions ...\n\n')

DATA.Instr.rest = 'rest now';
DATA.Instr.think = 'think now';

% Load Intstructions Sound
[ DATA.Instr.Sounds, DATA.Instr.Freqs, DATA.Instr.Channels ] = ...
    SoundLoader(INSTRDIR);

% Load Intstructions Images
[ DATA.Instr.Images, DATA.Instr.ImageNames, DATA.Instr.ImageSizes ] = ...
    ImageLoader(INSTRDIR);

% Message
fprintf('Instructions Loaded.\n\n')


% -------------------------------------------------------------------
% SAVE   ------------------------------------------------------------
fprintf('Saving ....\n\n')

% Save Data
save('DATA', 'DATA');

% Message
fprintf('Finished! \n\n')

