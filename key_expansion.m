function w = key_expansion (key, s_box, rcon)
 w = (reshape (key, 4, 4))';
 for i = 5 : 44
 temp = w(i - 1, :);
 if mod (i, 4) == 1
 temp =  temp([2 3 4 1]);
 temp = s_box(temp+1);
 r = rcon ((i - 1)/4, :);
 temp = bitxor (temp, r);
end
 w(i, :) = bitxor (w(i - 4, :), temp);
end