function FD = FDescriptor(a)

[p q]=size(a);
 if p/2 ~= round(p/2);
   a(end + 1, :) = a(end, :);
   p = p + 1;
 end
 t = 0:(p - 1);
 m = ((-1) .^ t)';
 a(:, 1) = m .* a(:, 1);
 a(:, 2) = m .* a(:, 2);
 FD = fft(a(:,1)+1i*a(:,2));
 
