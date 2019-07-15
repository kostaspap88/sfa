function y = fault_injection(x, fault_model, prob_fi, range)


fi = rand(size(x,3),1);
fi_index = fi<=prob_fi;
len_fi_index = sum(fi_index);
 index = find(fi_index==1);
 
 
% compute the faulted value using x and fault model
% note that we fault only some of the intermediate values, based on the 
% probability of successful FI
% note also that we fault 1 byte of the intermediate value which is the
% input to the last Sbox. Here we fault the 1st byte of the state producing
% value y. The fault could have been produced earlier, as long as it
% affects the 1st byte. The attack can be repeateated in other bytes=.


if (strcmp(fault_model, 'random_and')==1)
    
    % random-and fault model
    
    % generate a random error due to fault injection 
    e = randi(range, len_fi_index, 1)-1; 
    
    % place it only in the injected intermediates x
    
    y = x;
    y(1,1,index) = bitand(squeeze(x(1,1,index)), e);
    
    
else
    if (strcmp(fault_model, 'stuckat_50')==1)
        
    % stuck-at-50 model
        
    y = x;
    y(1,1,index) = 50;

else
        
    disp('unsupported fault model')
    
end


end