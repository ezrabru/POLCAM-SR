function [data,seed,tempGroupId,uniqueId] = temporalLinking(data,maxDist)
%TEMPORALLinking

% sort by increasing frame number
data = sortrows(data,'frame');

% get data from table
frame = data.frame;
x = data.x;
y = data.y;
% z = data.z;

% make frame start at 1
frame = frame - min(frame) + 1;

% create array with a unique id for each localisation
numLocs = numel(frame);
uniqueId = (1:numLocs)';

% initialise an all-zeros column that will be contain a '1' for
% localisations that are a seed (i.e., the first localisation in a of a
% series of localistions that will be grouped)
seed = zeros(numel(frame),1);

tempGroupId = cell(size(frame));

lastFrame = max(frame);
for id_frame = 1:lastFrame-1 % loop over frames (including empty frames)

    % get localisations from the current and next frame, and their unique ids
    % [X1,idx1] = getCoordinatesInFrame(id_frame,frame,[x,y,z]);
    % [X2,idx2] = getCoordinatesInFrame(id_frame+1,frame,[x,y,z]);
    [X1,idx1] = getCoordinatesInFrame(id_frame,frame,[x,y]);
    [X2,idx2] = getCoordinatesInFrame(id_frame+1,frame,[x,y]);
    uniqueId1 = uniqueId(idx1);
    uniqueId2 = uniqueId(idx2);

    % find all points that are a distance < maxDist removed from each other
    distances = pdist2(X1,X2,'euclidean');
    [row,col] = ind2sub(size(distances),find(distances < maxDist));
    numGrouped = numel(row); % number of pairs that should be grouped
    
    if numGrouped % if there are localisations between the frames that can be grouped
        for id_grouped = 1:numGrouped % loop over the different pairs that will be grouped

            % get the unique indeces of the two localisations that should be grouped
            uniqueIdCurrentFrame = uniqueId1(row(id_grouped));
            uniqueIdNextFrame    = uniqueId2(col(id_grouped));

            % register indeces for both points
            tempGroupId{uniqueIdCurrentFrame} = [tempGroupId{uniqueIdCurrentFrame} uniqueIdNextFrame];
            
            % check if this is a new grouping, or if it should be appended
            % to an existing grouping (there will be zeros at the indeces
            % of localisations that are not grouped, and a positive integer
            % at those where there is grouping)
            updateIdx = cellfun(@(x) sum(x == uniqueIdCurrentFrame), tempGroupId, 'uniform', false);

            % get index of the first non-zero cell
            updateIdx = cell2mat(updateIdx);
            updateIdx = find(updateIdx);

            if isempty(updateIdx)
                % if the localisation corresponding to uniqueIdCurrentFrame
                % is not linked yet to any previous localisations, it
                % should be marked as a seed (i.e. first appearance of the emitter)
                seed(uniqueIdCurrentFrame) = 1;
            else
                seedIdx = min(updateIdx);
                tempGroupId{seedIdx} = [tempGroupId{seedIdx} uniqueIdNextFrame];
            end
        end
    end
end

end

function [X,idx] = getCoordinatesInFrame(frame_query,frame,X)
%GETCOORDINATESINFRAME
idx = (frame == frame_query);
X = X(idx,:);
end