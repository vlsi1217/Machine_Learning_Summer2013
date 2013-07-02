function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% calculate nodes' value for each layer
a1 = [ones(m,1) X]; 
z2 = Theta1 * a1';
a2 = sigmoid(z2);
a2 = [ones(1,m);a2];
z3 = Theta2 * a2;
a3 = sigmoid(z3);

% according to the guideline PDF, need to transform y into separate sets of matrices
y_vector = zeros(num_labels, m);
for i = 1:m
	y_vector(y(i),i) = 1;
end;

% then we can calculate the cost function for all 10 num_labels with 5000 test data
% note that h_theta(x(i))_k = a(3)_k [check in PDF]
for i=1:m
	J +=  sum(-y_vector(:,i) .* log(a3(:,i)) - ...
		(1-y_vector(:,i)) .* log(1 - a3(:,i)));
end;
J = (1/m) * J;

% regularized cost function  (I use Theta1(:,2:401) but it shows A(I) exceeds...)
J = J + (lambda/(2*m)) * (sum(sum(Theta1(:,2:end) .^ 2)) + ...
	sum(sum(Theta2(:,2:end) .^ 2)));

% backpropagation: need to calculate small delta and big Delta
Delta1 = zeros(size(Theta1));
Delta2 = zeros(size(Theta2));
for i = 1:m
	% why delta3 is so simple while delta2 is complicated?
	delta3 = a3(:,i) - y_vector(:,i);   
	delta2 = (Theta2' * delta3)(2:end, :) .* sigmoidGradient(z2(:,i));
	%
	Delta2 += delta3 * a2(:,i)';
	Delta1 += delta2 * a1(i,:);
end

%
Theta2_grad = Delta2/m;
Theta1_grad = Delta1/m;

%regularization gradient

Theta2_grad(:,2:end) = Theta2_grad(:,2:end) .+ lambda * Theta2(:,2:end) /m;
Theta1_grad(:,2:end) = Theta1_grad(:,2:end) .+ lambda * Theta1(:,2:end) /m;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end