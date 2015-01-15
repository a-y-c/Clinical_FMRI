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
VRNSDIR = 'VRNS';
% Instruction Directory 
VRNS_INSTRDIR = 'INSTR';

% Timing Variables
DATA.BlockTotalNum = 9;
Intro_Time = .5;
First_Block_Time = 2.5;
Block_Time = 3;
Rest_Time = 10;


% -----------------------------------------------------------------
% DATA ------------------------------------------------------------
fprintf('Loading Timing ...\n\n')

% Timing - Beginning of Time
DATA.Timing(1) = 0;
% Timing - START REST 
DATA.Timing(2) = 5;
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

    % Timing - SOUND1
    COUNTER = COUNTER+1;
    DATA.Timing(COUNTER) = DATA.Timing(COUNTER-1) + First_Block_Time;

    % Timing - SOUND2
    COUNTER = COUNTER+1;
    DATA.Timing(COUNTER) = DATA.Timing(COUNTER-1) + Block_Time;

    % Timing - SOUND3
    COUNTER = COUNTER+1;
    DATA.Timing(COUNTER) = DATA.Timing(COUNTER-1) + Block_Time;

    % Timing - SOUND4
    COUNTER = COUNTER+1;
    DATA.Timing(COUNTER) = DATA.Timing(COUNTER-1) + Block_Time;

end
% TIME TOTAL = 245 seconds

% Message
fprintf('Timing Loaded.\n\n')


% ------------------------------------------------------------------
% Load Intro -------------------------------------------------------
DATA.Instr.rest = 'rest now';
DATA.Instr.think = 'think now';

% ------------------------------------------------------------------
% Load Intro -------------------------------------------------------
DATA.Sentence = {
'tall pink bird';
'write with it';
'criminals go there';
'smell with it';
'jewelry for finger';
'you read them';
'winter holiday';
'sit on them';
'they lay eggs';
 'color of the sky'; 
 'people worship here';
 'hear with them'; 
 'people live in it';
 'purring housepet';
 'keeps hands warm';
 'eat with it';
 'fly in them';
 'they make wool';
 'it tells time';
 'color of coal';
 'animal that gives milk'; 
 'color of grass';
 'people sit on them';
 'animal that quacks';
 'a long yellow fruit';
 'people write with it';
 'keeps pants up';
 'wear on feet';
 'shines in the sky';
 'police car sound';
 'a barking animal'; 
 'color of snow';
 'long orange vegetable';
 'a flying animal';
 'used for cutting wood';
 'a white sweetener'};


% -------------------------------------------------------------------
% SAVE   ------------------------------------------------------------
fprintf('Saving ....\n\n')

% Save Data
save('DATA', 'DATA');

% Message
fprintf('Finished! \n\n')

