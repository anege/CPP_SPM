% (C) Copyright 2019 CPP BIDS SPM-pipeline developers

function ffxDir = getFFXdir(subID, funcFWFM, opt)
  %
  % Short description of what the function does goes here.
  %
  % USAGE::
  %
  %   [argout1, argout2] = templateFunction(argin1, [argin2 == default,] [argin3])
  %
  % :param argin1: (dimension) obligatory argument. Lorem ipsum dolor sit amet,
  %                consectetur adipiscing elit. Ut congue nec est ac lacinia.
  % :type argin1: type
  % :param argin2: optional argument and its default value. And some of the
  %               options can be shown in litteral like ``this`` or ``that``.
  % :type argin2: string
  % :param argin3: (dimension) optional argument
  %
  % :returns: - :argout1: (type) (dimension)
  %           - :argout2: (type) (dimension)
  %
  % ffxDir = getFFXdir(subID, funcFWFM, opt)
  %
  % sets the name the FFX directory and creates it if it does not exist
  %
  %

  ffxDir = fullfile(opt.derivativesDir, ...
                    ['sub-', subID], ...
                    'stats', ...
                    ['ffx_task-', opt.taskName], ...
                    ['ffx_space-' opt.space '_FWHM-', num2str(funcFWFM)]);

  if ~exist(ffxDir, 'dir')
    mkdir(ffxDir);
  end
end
