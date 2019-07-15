function [ciphertext, x, k9, k10]= aes_cipher_full(plaintext, w, s_box, poly_mat,ind_matleft)

state = plaintext;
round_key = (w(1:4, :))';
state = bitxor(round_key,state);
for i_round = 1 : 9

    state = s_box (state + 1);

    state = state(ind_matleft);

    if (i_round == 9)
     % store intermediate value for faulting i.e. store the input x to the
     % MixColumn operation
     x = state;  
    end

    state = mix_columns(state, poly_mat);

    round_key = (w((1:4) + 4*i_round, :))';

    if (i_round == 9)
        % store K9
        k9 = round_key;    
    end

    state = bitxor (state, round_key);

end

state = s_box (state+1);
state = state(ind_matleft);
round_key = (w(41:44, :))';
% store K10
k10 = round_key;
ciphertext = bitxor (state, round_key);
 
 
end