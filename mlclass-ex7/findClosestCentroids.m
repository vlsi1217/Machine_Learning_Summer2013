function idx = findClosestCentroids(X, centroids)
%FINDCLOSESTCENTROIDS computes the centroid memberships for every example
%   idx = FINDCLOSESTCENTROIDS (X, centroids) returns the closest centroids
%   in idx for a dataset X where each row is a single example. idx = m x 1 
%   vector of centroid assignments (i.e. each entry in range [1..K])
%

% Set K
K = size(centroids, 1);

% You need to return the following variables correctly.
idx = zeros(size(X,1), 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Go over every example, find its closest centroid, and store
%               the index inside idx at the appropriate location.
%               Concretely, idx(i) should contain the index of the centroid
%               closest to example i. Hence, it should be a value in the 
%               range 1..K
%
% Note: You can use a for-loop over the examples to compute this.
%

% X_k = idx; %选择这种算法是因为不想计算m，给了m的话，肯定就做2层循环了
% for i = 1:K,
%     X_item = X - centroids(i, :);
%     X_item = X_item.*X_item;
%     X_item = sum(X_item, 2);%计算出每个点距离k中心点的距离平方
%     if i == 1,
%         X_k = X_item;
%     else
%         X_k = [X_k X_item];%最终每行排列的是K个数字，每个数字代表第i个点距离第k个点的距离平方
%     end;
% end;    

% [val, ind] = min(X_k, [], 2); %返回每行的最小值和index
% idx = ind;

m = size(X,1); % find how many rows do X have

for i = 1: m
	T = []; % need to clear T every time we duplicate it in order to 
			% get matrix size match (nice trick)
	for j = 1:K
		T = [T ; X(i,:)];   % duplicate X(i) to match size as centroids
	end
	[MIN, idx(i)] = min(sum((T-centroids) .^ 2 , 2)); % find the min and idx		
end
% =============================================================

end

