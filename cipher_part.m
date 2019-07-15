function [ciphertext, x, k9, k10] = cipher_part(input, part)

% import AES tables
ssi;

% the true key of the cipher
key = ['1' '2' '3' '4' '5' '6' '7' '8' '9' '1' '2' '3' '4' '5' '6' '7'];
key=abs(key);

% perform the key expansion
w = key_expansion (key, s_box, rcon);




    
% Full AES computation
if (part==1)
    ciphertext = zeros(4,4,size(input,1));
    x = zeros(4,4,size(input,1));
    
    for i=1:size(input,1)
        plain=reshape(input(i,:),4,4);
        [ciphertext(:,:,i), x(:,:,i), k9, k10] = aes_cipher_full(plain, w, s_box, poly_mat,ind_matleft);    
    end
end

% Final steps of AES computation
if (part==2)
    ciphertext = zeros(4,4,size(input,3));

    for i=1:size(input,3)
        [ciphertext(:,:,i) ] = aes_cipher_finalsteps(input(:,:,i), w, s_box, poly_mat,ind_matleft);   
    end
end
 

end