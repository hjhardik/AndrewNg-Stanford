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
X=[ones(m,1) X];
a=(sigmoid((Theta1*(X)')))';
a=[ones(m,1) a];
b=sigmoid((Theta2*(a)'));
[prob,iprob]= max(b);
p=(iprob)';
y_t=eye(num_labels);


for i=1:m
	c=y(i);
	J= J+  (((y_t(:,c))'*(log(b(:,i))))+((1.-y_t(:,c))'*log(1.-b(:,i))));
end
J=((-1)/m)*J;


temp1=Theta1(:,2:end);
temp2=Theta2(:,2:end);

th1=0;
th2=0;
for j=1:hidden_layer_size
	for v=1:input_layer_size
		th1= th1+ (temp1(j,v))^2;
	end
end
for j=1:num_labels
	for v=1:hidden_layer_size
		th2= th2+ (temp2(j,v))^2;
	end
end
J=J+ (((lambda)/(2*m))*(th1+th2));


l=zeros(input_layer_size+1,1);		
del3=zeros(num_labels,m);
del2=zeros(hidden_layer_size,m);
Delta1=zeros(hidden_layer_size,input_layer_size+1);
Delta2=zeros(num_labels,hidden_layer_size+1);
for i=1:m
	c=y(i);
	l=(X(i,:))';
	del3(:,i)=b(:,i)-y_t(:,c);
	del2(:,i)=(((Theta2(:,2:end))')*(del3(:,i))).*((a(i,2:end)').*(1.-(a(i,2:end))'));
	Delta2=Delta2+ (del3(:,i)*(a(i,:)));
	Delta1=Delta1+ (del2(:,i)*(l)');
end




Theta2_grad(:,2:end)=((1/m).*Delta2(:,2:end)) + (((lambda/m).*(Theta2(:,2:end))));	
Theta1_grad(:,2:end)=((1/m).*Delta1(:,2:end)) + (((lambda/m).*(Theta1(:,2:end))));

Theta1_grad(:,1)=((1/m).*Delta1(:,1));
Theta2_grad(:,1)=((1/m).*Delta2(:,1));











% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
