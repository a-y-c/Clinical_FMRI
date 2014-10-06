function StaglinPTB()

% FILENAME: StaglinPTB.m
%******************************************************************
% Description:
%
% 2014/09
%   Task is Modified for Clinical Scans - Polish VRNS
%
%
% 2012/02
% This program was written for for Dr Bookhiemers Lab 
% group on on Pyschtoolbox 3 on 2012/02/07. This was designed to be 
% template from which other code can be made. The StaglinPTB 
% program acts as a skeleton from which programs that run the Block 
% or Jitter design are called. The function Activate_Screens is 
% called to open screen(s)in PTB. RealTimeAnalysis displays the 
% captured data as a way to do a quick and dirty quality control of
% the run.    
%
%******************************************************************
%
% Written by Cameron Rodriguez cameron.rodrigue@gmail.com
% Last Modified 2012/02
% Modded by Andrew Cho	andrew.cho.52@gmail.com
% Last Modified 2014/06
%
%******************************************************************
%
%   Dependencies: 
%       ExampleParadigmBlock, ExampleParadigmJitter
%       Activate_Screens - Screen Input
%       RealTimeAnalysis 
%
%******************************************************************

%------------------------------------------------------------------
% SETUP -----------------------------------------------------------
disp('***** No Data Saving. *****')   
load('Data/DATA.mat')


%------------------------------------------------------------------
% Activate Keyboard -----------------------------------------------
KbName('UnifyKeyNames');
FlushEvents('keyDown');

OKKey = KbName('p');
KillKey = KbName('k');
TRKey1 = KbName('T'); % TR signal key
TRKey2 = KbName('5'); % TR signal key
TRKB = KbName('5%');  % Keyboard TR


%------------------------------------------------------------------
% Open Screens ----------------------------------------------------
[ScreenHandels, Screen_Parameters, PPD_DPP] = Activate_Screens;
WES = ScreenHandels.WES; % Window Handel Right Screen
RES = ScreenHandels.RES; % Window Rectangle Right Screen
WSS = ScreenHandels.WSS; % Window Handel Left Screen
RSS = ScreenHandels.RSS; % Window Rectangle Left Screen

Params.Screen_Parameters = Screen_Parameters;
Params.ScreenSize = Screen_Parameters.ResolutionSubject;
Params.ScreenCenter = Screen_Parameters.ResolutionSubject / 2;
Params.PPD_DPP = PPD_DPP;


%------------------------------------------------------------------
% START EXPERIMENT ------------------------------------------------
Escape = false;
while (~Escape)
    try % Start Try - Catch

        % Hide Mouse Cursor
        HideCursor

        % Run Experiment!
        Task_Paradigm(Params, ScreenHandels, DATA)

        % Experiment End
        % Draw Fixation Point
        Screen('FillRect', WSS, 128, RSS);
        Screen('DrawDots', WSS, [0, 0], 10, ...
                255*[1 0 0 1], [RSS(3)/2 RSS(4)/2], 1);
        Screen('DrawingFinished', WSS); 
        Screen('Flip',WSS);
        
            
    catch lasterr
        % this "catch" section executes in case of an error in the
        % "try" section above.  The error is captured in "lasterr". 
        % Importantly, it closes the onscreen window(s).
        
        Screen('CloseAll');
        
        % Restore the Keyboard
        olddisabledkeys = DisableKeysForKbCheck([]); 

        % Show the Cursor
        ShowCursor;
        rethrow(lasterr)

    end % End Try - Catch
   

%------------------------------------------------------------------
% FINISH/RESTART --------------------------------------------------
    Text = 'Task Finished [p]';
    DrawFormattedText(WSS, Text, 'center', 'center', 0 , 45);
    Screen('Flip',WSS);


    % Catch [p] key to move to finish
    KeyEscape = false;
    while ~KeyEscape
        WaitSecs(0.01);
        keyIsDown = 0;
        [keyIsDown, secs, keyCode] = KbCheck(-1);
        if ( keyIsDown == 1 ) & keyCode(OKKey)
            disp('Task is Finished')
            KeyEscape = true;
            Escape = true;
        end 
    end %End Loop
    
    %% Clear the Buffers
    olddisabledkeys = DisableKeysForKbCheck([]); 

    %% Close the Screen
    Screen('CloseAll');

end % End Escape Error
end % All Done, That's All she Wrote

