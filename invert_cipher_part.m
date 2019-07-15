function [result, iv1] = invert_cipher_part(ciphertext_byte1, key_guess)

% import AES tables
ssi;


result = zeros(4,4,size(ciphertext_byte1,3));

for i=1:size(ciphertext_byte1,3)
    

    % addround key
    iv1 = bitxor(ciphertext_byte1, key_guess);
    
    % no need for shift rows   
    result = inv_s_box(iv1+1);

end


end