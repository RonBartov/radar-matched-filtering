function [targets,nonTargets] = classify_targets_from_th(signalAbs, th)
    if isscalar(th)
        targets = signalAbs .* (signalAbs >= th);
        nonTargets = signalAbs .* (signalAbs < th);
    else
        targets = NaN(size(signalAbs));
        nonTargets = NaN(size(signalAbs));

        % Assign values based on threshold comparison
        targetIdx = signalAbs >= th;
        nonTargetIdx = ~targetIdx;
    
        targets(targetIdx) = signalAbs(targetIdx);
        nonTargets(nonTargetIdx) = signalAbs(nonTargetIdx);
    
    end

    
end