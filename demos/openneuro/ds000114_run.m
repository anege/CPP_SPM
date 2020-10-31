% (C) Copyright 2020 CPP BIDS SPM-pipeline developpers

% runDs00014

clear;
clc;

% Smoothing to apply
FWHM = 6;

% directory with this script becomes the current directory
WD = fileparts(mfilename('fullpath'));

% we add all the subfunctions that are in the sub directories
addpath(genpath(fullfile(WD, '..', '..', 'src')));
addpath(genpath(fullfile(WD, '..', '..', 'lib')));

%% Set options
opt = ds000114_getOption();

checkDependencies();

%% Run batches

reportBIDS(opt);

% bidsCopyRawFolder(opt, 1);
%
% bidsSTC(opt);

bidsSpatialPrepro(opt);

anatomicalQA(opt);
bidsResliceTpmToFunc(opt);
functionalQA(opt);

bidsSmoothing(FWHM, opt);

bidsFFX('specifyAndEstimate', opt, FWHM);
bidsFFX('contrasts', opt, FWHM);
bidsResults(opt, FWHM);
