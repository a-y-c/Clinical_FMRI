function [ScreenHandels, Screen_Parameters, PPD_DPP] = Activate_Screens(Constants, Params)
% [ScreenHandels, Screen_Parameters, PPD_DPP] = ...
% Activate_Screens(Constants,Params)
%
%******************************************************************
%
% Written by Cameron Rodriguez, base on code that can be found in
% PTB StereoDemo.m
%
% Last Modified 2012/02/08
%
%******************************************************************
%
% see also: StereoDemo
%******************************************************************

%% Set Defaults

if nargin < 2
    DrawFixationPt = 1;
    UseOneMonitor = 1;
else
    DrawFixationPt = Params.DrawFixationPt;
    UseOneMonitor  = Params.UseOneMonitor;
end

if nargin < 1
    SSE = 0;
    ESE = 0;
else
    SSE = Constants.SSE;
    ESE = Constants.ESE;
end

%% Set Up the Display Parameters

AssertOpenGL; 

AvailableScreens = Screen('Screens');

if IsOSX == 1
    % Select screen with maximum id for output window
    SubjectScreenID = max(AvailableScreens);
    ExperimenterScreenID = 0;
    rect=Screen('Rect', SubjectScreenID);
    if numel(AvailableScreens) == 1;
        %Srect = [rect(3)/2, rect(4)/2, rect(3), rect(4)];
        Srect = rect;
        OnlyOneScreen = 1;
    else
        Srect = rect;
        OnlyOneScreen = 0;
    end
else
    SubjectScreenID = max(AvailableScreens);
    ExperimenterScreenID = 1;
    rect=Screen('Rect', SubjectScreenID);
    if numel(AvailableScreens) == 2;
        %Srect = [rect(3)/2, rect(4)/2, rect(3), rect(4)];
        Srect = rect;
        OnlyOneScreen = 1;
    else
        Srect = rect;
        OnlyOneScreen = 0;
    end
end

PsychImaging('PrepareConfiguration');
% Open a fullscreen, onscreen window with gray background. Enable 
% 32bpc floating point framebuffer via imaging pipeline on it, if 
% this is possible on your hardware while alpha-blending is 
% enabled. Otherwise use a 16bpc precision framebuffer together 
% with alpha-blending. We need alpha-blending here to implement the
% nice superposition of overlapping gabors. The program will abort 
% if your graphics hardware is not capable of any of this.
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible'); 
                                                                   

                                                                    
[winSubjectScreen RectSubjectScreen] = ...
    PsychImaging('OpenWindow', SubjectScreenID, 128, Srect);
ifiS = Screen('GetFlipInterval', winSubjectScreen);

%***    Below maybe helpful to uncomment if drawing complex     ***
%***        graphics with many blended layers ie masks          ***
% Screen('BlendFunction', winSubjectScreen, GL_SRC_ALPHA, GL_ONE); 
% Enable alpha-blending, set it to a blend equation useable for 
% linear superposition with alpha-weighted source. This allows to 
% linearly superimpose gabor patches in the mathematically correct 
% manner, should they overlap. Alpha-weighted source means: The 
% 'globalAlpha' parameter in the 'DrawTextures' can be used to 
% modulate the intensity of each pixel of the drawn patch before it
% is superimposed to the framebuffer image, ie., it allows to 
% specify a global per-patch contrast value:

% Declare the Text Size for the screen
Screen('TextSize',winSubjectScreen, 32);
% Screen Width and Screen Height for the Left Screen Respectively
[SWS, SHS] = RectSize(RectSubjectScreen); 

if DrawFixationPt == 1
    Screen('FillRect', winSubjectScreen, 128, RectSubjectScreen);
    Screen('DrawDots', winSubjectScreen, [0, 0], 10, ...
            255*[1 0 0 1], ...
            [RectSubjectScreen(3)/2 RectSubjectScreen(4)/2], 2);
    Screen('DrawingFinished', winSubjectScreen); 
    Screen('Flip',winSubjectScreen);
end

if ((UseOneMonitor ~= 1) && (OnlyOneScreen == 0))
    
    ViewingDistance = 3; % in cm 
    
    PsychImaging('PrepareConfiguration');
    PsychImaging('AddTask', 'General', ...
                 'FloatingPoint32BitIfPossible');%See Above
    [winExperimenterScreen RectExperimenterScreen] = ...
             PsychImaging('OpenWindow', ExperimenterScreenID, 128);
    ifiE = Screen('GetFlipInterval', winExperimenterScreen);
    % Screen('BlendFunction', winExperimenterScreen, ...
    % GL_SRC_ALPHA, GL_ONE);
    Screen('TextSize',winExperimenterScreen, 24);
    
    [SWE, SHE] = RectSize(RectExperimenterScreen);
    % Screen Width and Height for the Experimenter Screen
    
    HideCursor;
    
else
    
    SWE = [];
    SHE = [];
    winExperimenterScreen = [];
    RectExperimenterScreen = [];
    ifiE = ifiS;
    
    ViewingDistance = 3; % in cm 
    
    disp('***** Test mode enabled. No data saving. *****')
    
end

ScreenHandels.WES = winExperimenterScreen;
ScreenHandels.RES = RectExperimenterScreen;
ScreenHandels.ifiS = ifiS;
ScreenHandels.WSS = winSubjectScreen;
ScreenHandels.RSS = RectSubjectScreen;
ScreenHandels.ifiE = ifiE;
% Subject Screen Center Ecentricity in Degrees visual angle
ScreenHandels.SSC_Ecentricity = SSE; 
% Expermenter Screen Center Ecentricity in Degrees visual angle
ScreenHandels.ESC_Ecentricity = ESE; 

if IsOSX == 1

%*** The below may need to be included if using Alpha Blending ***     
% OldTextRenderer=Screen('Preference','TextRenderer',1);
% OldTextAlphaBlending=Screen('Preference','TextAlphaBlending',1);

    ScreenSizeExperimenter = [33.1703 20.7314]; % in cm
    ScreenSizeSubject = [88.3307 49.6860]; % in cm    

    ExperimenterScreenModel = 'MacBook Pro 15';
    SubjectScreenModel = 'Samsung HDTV';

else
    
    ScreenSizeRight = [69.7708 39.4]; % in cm
    ScreenSizeLeft = [69.7708 39.4]; % in cm
    
    ExperimenterScreenModel = 'NEC LCD3215';
    SubjectScreenModel = 'NEC LCD3215';
    
end

Screen_Parameters.ViewingDistance = ViewingDistance;
Screen_Parameters.ExperimenterScreenModel=ExperimenterScreenModel;
Screen_Parameters.SubjectScreenModel = SubjectScreenModel;
Screen_Parameters.ResolutionExperimenter = [SWE, SHE];
Screen_Parameters.ResolutionSubject = [SWS, SHS];
Screen_Parameters.ScreenSizeExperimenter = ScreenSizeExperimenter;
Screen_Parameters.ScreenSizeSubject = ScreenSizeSubject;

% get the Pixels Per Degree visual angle and the Degrees Per Pixel
% visual angle
[PPD_Subject,DPP_Subject] = PPDE(ScreenSizeSubject, ...
                                 [SWS, SHS], ViewingDistance, SSE); 
PPD_DPP.PPD_Subject = PPD_Subject;
PPD_DPP.DPP_Subject = DPP_Subject;  

% Open only if there are 2 Screens and the boolian is fliped off
if ((UseOneMonitor ~= 1) && (OnlyOneScreen == 0)) 
    [PPD_Experimenter,DPP_Experimenter] = PPDE(ScreenSizeRight,...
                                 [SWE, SHE], ViewingDistance, ESE);
    PPD_DPP.PPD_Experimenter = PPD_Experimenter;
    PPD_DPP.DPP_Experimenter = DPP_Experimenter;
end

end

%% Sub functions

function [PPD,DPP] = PPDE(ScreenSize, Resolution, ViewingDistance, Eccentricity)

% calculate the size of a pixel (cm/pixel)
PixelSize=ScreenSize/Resolution; 

SizeInCmOneDeg = ...
    ViewingDistance * ...
    (tand(Eccentricity + 0.5) - tand(Eccentricity - 0.5));

% (cm/deg)/(cm/pixel) = Pixels/Deg
PPD = SizeInCmOneDeg ./ PixelSize;
DPP = 1./PPD;% Deg/Pixel
    
end
