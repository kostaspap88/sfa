% Statistical Fault Analysis - SFA
% Author : Kostas Papagiannopoulos -- kpcrypto.net
% Based on "Fault attacks on AES with faulty ciphertexts only, Fuhr et
% al.", focusing on the 9th-round fault, i.e. 10th-round attack

% CAROLINE DELETED...GOODBYE CAROLINE
clear all;
close all;


% probability of successful FI probility
prob_fi = 0.8;
% choose the fault model to simulate
fault_model = 'random_and';
% fault_model = 'stuckat_50';

% we obtain 'no_attack_traces' ciphertext values
% Subsequently we use them to perform SFA on the last round
no_attack_traces = 50;




% PART1: COLLECTING CIPHERTEXTS

% import AES tables
ssi;

no_bits = 8; % bits in AES state elements
state_size = 16; % number of elements in AES state
no_inputs = no_attack_traces; % number of AES encryptions
range = 2^no_bits;


% generate the input to the AES cipher 
plaintext = randi(range, no_inputs, state_size)-1;

% compute the intermediate value x where we will inject the fault.
% compute as well the correct ciphertext and the rounds keys 9 and 10
[correct_ciphertext, x, k9, k10] = cipher_part(plaintext, 1);


% perform the fault injection on x based on the probability of faults and 
% the specified fault model.
% this produces faulty intermediate value y

y = fault_injection(x, fault_model, prob_fi, range);


% subsequently the faulted intermediate value y gets mixed with the key and
% we finally obtain the faulty ciphertext 
faulty_ciphertext = cipher_part(y, 2); 
faulty_ciphertext_byte1 = squeeze(faulty_ciphertext(1,1,:));

% estimate the statistical distribution faulty intermediate value 
% i.e. estimate the "perfect control" scenario using value y. 
% note that y may also contain unsuccessful faults i.e. it can be diluted
y_byte1 = squeeze(y(1,1,:));
faulty_value_distribution = histcounts(y_byte1,0:256,'Normalization', 'probability');




% PART2: KEY GUESSING

ml_distinguisher = zeros(range,1);
hw_distinguisher = zeros(range,1);
x_guess = cell(range,1);
iv1 = cell(range,1);

% for all possible keys
for i=1:range
    
    % compute the intermediate value guess on a single byte
    key_guess = i-1;
    [x_guess{i} iv1{i}] = invert_cipher_part(faulty_ciphertext_byte1, key_guess);
    
    % Maximum likelihood distinguisher (use sum of logs to avoid
    % multiplication by zero. Or just use sum)
    ml_distinguisher(i)=sum(faulty_value_distribution(x_guess{i}+1));
    
    % Hamming weight distinguisher
    hw_x = hw(x_guess{i});
    hw_distinguisher(i) = sum(hw_x);
    
    % Squared Euclidean Imbalance: it is not possible to deploy this
    % distinguisher in the last-round attack
    

end

[mld_val, mld_index] = max(ml_distinguisher);
[hwd_val, hwd_index] = min(hw_distinguisher);
top_candidate_mldist = mld_index-1
top_candidate_hwdist = hwd_index-1




