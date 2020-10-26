% (C) Copyright 2019 CPP BIDS SPM-pipeline developpers

function bidsFFX(action, opt, funcFWHM)
    % bidsFFX(action, funcFWHM, opt, isMVPA)
    %
    % This scripts builds up the design matrix for each subject.
    % It has to be run in 2 separate steps (action):
    %
    % Inputes
    % - action (string)
    %   - case specifyAndEstimate = fMRI design and estimate
    %   - case contrasts = contrasts
    % - funcFWHM (scalar) is the number of the mm smoothing used in the
    %   normalized functional files.
    %     for unsmoothed data  funcFWHM = 0
    %     for smoothed data = ... mm
    % In this way we can make multiple ffx for different smoothing degrees

    % if input has no opt, load the opt.mat file
    if nargin < 3
        opt = [];
    end
    opt = loadAndCheckOptions(opt);

    % load the subjects/Groups information and the task name
    [group, opt, BIDS] = getData(opt);

    %% Loop through the groups, subjects, and sessions
    for iGroup = 1:length(group)

        groupName = group(iGroup).name;

        for iSub = 1:group(iGroup).numSub

            subID = group(iGroup).subNumber{iSub};

            printProcessingSubject(groupName, iSub, subID);

            switch action

                case 'specifyAndEstimate'

                    fprintf(1, 'BUILDING JOB : FMRI design\n');

                    matlabbatch = setBatchSubjectLevelGLMSpec( ...
                                                              BIDS, opt, subID, funcFWHM);

                    fprintf(1, 'BUILDING JOB : FMRI estimate\n');

                    matlabbatch = setFmriEstimateBatch(matlabbatch);

                    saveMatlabBatch(matlabbatch, ...
                                    ['specify_estimate_ffx_task-', opt.taskName, ...
                                     '_space-', opt.space, ...
                                     '_FWHM-', num2str(funcFWHM)], ...
                                    opt, subID);

                case 'contrasts'

                    fprintf(1, 'BUILDING JOB : FMRI contrasts\n');

                    matlabbatch = setBatchSubjectLevelContrasts(opt, subID, funcFWHM);

                    saveMatlabBatch(matlabbatch, ...
                                    ['contrasts_ffx_task-', opt.taskName, ...
                                     '_space-', opt.space, ...
                                     '_FWHM-', num2str(funcFWHM)], ...
                                    opt, subID);

            end

            spm_jobman('run', matlabbatch);

        end
    end

end

function matlabbatch = setFmriEstimateBatch(matlabbatch)
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep( ...
                                                          'fMRI model specification SPM file', ...
                                                          substruct( ...
                                                                    '.', 'val', '{}', {1}, ...
                                                                    '.', 'val', '{}', {1}, ...
                                                                    '.', 'val', '{}', {1}), ...
                                                          substruct('.', 'spmmat'));

    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 1;
end