function locs = cluster_dbscan(locs,maxRadius,minPoints)
%CLUSTER_DBSCAN

if ismember('z',locs.Properties.VariableNames)
    X = [locs.x locs.y locs.z];
else
    X = [locs.x locs.y];    
end

locs.cluster_id = dbscan(X,maxRadius,minPoints);

end
