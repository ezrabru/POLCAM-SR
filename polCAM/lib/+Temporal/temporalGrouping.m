function data = temporalGrouping(data,maxDist)
%TEMPORALGROUPING

[data,seed,tempGroupId,uniqueId] = Temporal.temporalLinking(data,maxDist);

data = Temporal.groupLocalisations(data,seed,tempGroupId,uniqueId);

end