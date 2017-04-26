function [Z, totalPotential, parents] = PHA_Clustering(dMatrix, S)
%PHA_Clustering Performs hierarchical clustering using the PHA method
% 
% [Z, totalPotential, parents] = PHA_Clustering(dMatrix, S)
% 
% ---Purpose--- 
% Performs hierarchical clustering using the PHA method
% The function will produce a hierarchical cluster tree (Z) from the input distance matrix
% The output Z is similar to the output by the Matlab function 'linkage'
%
% ---INPUT---
% dMatrix: distance matrix (numPts X numPts) defining distances between objects
% S: (optional) Scale factor for determining parameter delta. The default value is S=10.
%     If two points are closer than delta, they don't have attractive force. 
%
% ---OUTPUT---
% Z: hierarchical cluster tree  which is represented as a matrix with size (numPts-1 X 3) 
% totalPotential: total potential values 
% parents: the parent index of each data
%
% ---HOW TO USE---
% Z = PHA_Clustering(dMatrix);
% T = cluster(Z,'maxclust',k);
% 
% ---Author---
% Yonggang Lu (ylu@lzu.edu.cn)
%
% ---Reference---
% Yonggang Lu, Yi Wan. (2013). PHA: A Fast Potential-based Hierarchical Agglomerative 
% Clustering Method, Pattern Recognition, Vol. 46(5), pp. 1227-1239.
%


[numPts,numPts2] = size(dMatrix); % numPts is the number of points
if (numPts ~= numPts2)
    error(' PotentialHierachyWDistMatrix: distance matrix should be a square matrix! ');
end
if (nargin < 2) 
    S = 10; 
end

% compute the dalta automatically
minDist = zeros(numPts, 1);
for i = 1:numPts
    mask = (dMatrix(i,:)~=0); 
    minDist(i) = min(dMatrix(i, mask));
end
delta = mean(minDist)/S;

totalPotential = zeros(1, numPts);
for i = 1:numPts  % for each point
    distToAll = dMatrix(i, :);    
    selIdxes  = find(distToAll >= delta); 
    totalP = sum(1./dMatrix(i, selIdxes));
    totalP = totalP + (numPts-length(selIdxes)-1)*(1/delta); % for points within delta, potential = 1/delta
    totalPotential(i)= - totalP;
end

[sortedP, sortedIdx] = sort(totalPotential);

parents = [1:numPts]; % stores the parent information
distToParent = zeros(1, numPts); % stores the distance to the parent point

for pi = 2:numPts   
    centerIdx = sortedIdx(pi);
    visitedPtsIdx = sortedIdx(1:pi-1);       
    distToVisited = dMatrix(centerIdx, visitedPtsIdx);
    
    [minDist, minIdx] = min(distToVisited); 
    parents(centerIdx) = visitedPtsIdx(minIdx);
    distToParent(centerIdx) = minDist;   
end

% Z returns a (numPts-1) by 3 Matrix (same as linkage)
Z = zeros(numPts-1, 3);
[sortedDist, sortedIdx2] = sort(distToParent);
linkIdx = [1:numPts]; % remember the index after each layer of merging
for i = 1:numPts-1
    mergeIdx = sortedIdx2(i+1);
    Z(i, 1) = linkIdx(parents(mergeIdx));
    Z(i, 2) = linkIdx(mergeIdx);
    Z(i, 3) = sortedDist(i+1);
    linkIdx(linkIdx==Z(i, 2)) = numPts+i;
    linkIdx(linkIdx==Z(i, 1)) = numPts+i;
end


end
