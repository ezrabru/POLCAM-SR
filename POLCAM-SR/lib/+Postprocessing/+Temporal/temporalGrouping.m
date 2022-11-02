function data = temporalGrouping(data,maxDist)
%TEMPORALGROUPING

[data,seed,tempGroupId,uniqueId] = Postprocessing.Temporal.temporalLinking(data,maxDist);

data = Postprocessing.Temporal.groupLocalisations(data,seed,tempGroupId,uniqueId);

end