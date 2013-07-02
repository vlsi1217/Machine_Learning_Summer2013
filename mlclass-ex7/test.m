clear;
for i = 1: 3
	T = [];
	X = [1 2; 3 0.7; 3.14 6];
	for j = 1 : 5,
		T = [T ; X(i,:)];
	end
	a(i) = sum(T,2);
end