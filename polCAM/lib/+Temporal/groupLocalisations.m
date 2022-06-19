function dataGrouped = groupLocalisations(dataLinked,seed,tempGroupId,uniqueId)
%GROUPLOCALISATIONS

idx_seed = find(seed); % get index of all the seeds

% merge localisations, including a new column that shows how many
% localisations were combined (if any)
seedsOrToGroup = unique([[tempGroupId{:}]'; idx_seed]);
id_seedsOrToGroup = setdiff(uniqueId,seedsOrToGroup);
dataGrouped = dataLinked(id_seedsOrToGroup,:);
dataGrouped.len = ones(height(dataGrouped),1);

for id_seed = 1:numel(idx_seed) % append grouped localisations to 'dataGrouped'
    % find the indeces of the localisations that should be grouped with this seed
    seed_i = idx_seed(id_seed);
    id_toGroupWithSeed = tempGroupId{seed_i};

    toGroup = dataLinked(id_toGroupWithSeed,:);
    dataGrouped_i = table;

    if ismember('file_id', dataLinked.Properties.VariableNames)
        dataGrouped_i.file_id = dataLinked(seed_i,:).file_id;
    end
    if ismember('frame', dataLinked.Properties.VariableNames)
        dataGrouped_i.frame = dataLinked(seed_i,:).frame;
    end
    if ismember('frameGrouped', dataLinked.Properties.VariableNames)
        dataGrouped_i.frameGrouped = dataLinked(seed_i,:).frameGrouped;
    end
    if ismember('x', dataLinked.Properties.VariableNames)
        dataGrouped_i.x = mean(toGroup.x);
    end
    if ismember('y', dataLinked.Properties.VariableNames)
        dataGrouped_i.y = mean(toGroup.y);
    end
    if ismember('z', dataLinked.Properties.VariableNames)
        dataGrouped_i.z = mean(toGroup.z);
    end
    if ismember('photons', dataLinked.Properties.VariableNames)
        dataGrouped_i.photons = sum(toGroup.photons);
    end
    if ismember('amplitude', dataLinked.Properties.VariableNames)
        dataGrouped_i.amplitude = sum(toGroup.amplitude);
    end
    if ismember('sigmax', dataLinked.Properties.VariableNames)
        dataGrouped_i.sigmax = mean(toGroup.sigmax);
    end
    if ismember('sigmay', dataLinked.Properties.VariableNames)
        dataGrouped_i.sigmay = mean(toGroup.sigmay);
    end
    if ismember('rot', dataLinked.Properties.VariableNames)
        dataGrouped_i.rot = mean(toGroup.rot);
    end
    if ismember('bkgnd', dataLinked.Properties.VariableNames)
        dataGrouped_i.bkgnd = mean(toGroup.bkgnd);
    end
    if ismember('sigmaRatio', dataLinked.Properties.VariableNames)
        dataGrouped_i.sigmaRatio = mean(toGroup.sigmaRatio);
    end
    if ismember('uncertainty_photons', dataLinked.Properties.VariableNames)
        dataGrouped_i.uncertainty_photons = mean(toGroup.uncertainty_photons);
    end
    if ismember('uncertainty_photons', dataLinked.Properties.VariableNames)
        dataGrouped_i.uncertainty_photons = sqrt(sum(toGroup.uncertainty_photons.^2,'all'));
    end
    if ismember('uncertainty_xy', dataLinked.Properties.VariableNames)
        dataGrouped_i.uncertainty_xy = sqrt(sum(toGroup.uncertainty_xy.^2,'all'));
    end
    if ismember('angleGaus', dataLinked.Properties.VariableNames)
        dataGrouped_i.angleGaus = mean(toGroup.angleGaus);
    end
    if ismember('phi', dataLinked.Properties.VariableNames)
        dataGrouped_i.phi = mean(toGroup.phi);
    end
    if ismember('theta', dataLinked.Properties.VariableNames)
        dataGrouped_i.theta = mean(toGroup.theta);
    end
    if ismember('avgDoLP', dataLinked.Properties.VariableNames)
        dataGrouped_i.avgDoLP = mean(toGroup.avgDoLP);
    end
    if ismember('netDoLP', dataLinked.Properties.VariableNames)
        dataGrouped_i.netDoLP = mean(toGroup.netDoLP);
    end
    if ismember('filter', dataLinked.Properties.VariableNames)
        dataGrouped_i.filter = 1;
    end

    dataGrouped_i.len = numel(id_toGroupWithSeed) + 1;
    dataGrouped = [dataGrouped; dataGrouped_i];
    
end
end
