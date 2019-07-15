function [ciphertext]= aes_cipher_finalsteps(plaintext, w, s_box, poly_mat,ind_matleft)

state = plaintext;


state = s_box (state+1);
state = state(ind_matleft);
round_key = (w(41:44, :))';
ciphertext = bitxor (state, round_key);
 
 
end