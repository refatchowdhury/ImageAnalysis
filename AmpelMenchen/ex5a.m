I=imread('ampelmaennchen.png');
Ibw=im2bw(I,0);
% imshow(Ibw);
% b=bwboundaries(Ibw);
[B,L] = bwboundaries(Ibw,'noholes');

figure,subplot(1,2,1);
imshow(label2rgb(L, @jet, [.5 .5 .5]));
title('Boundary detection');
hold on
for k=1:length(B)
    boundary=B{1};
plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);
end

FDarray=FDescriptor(boundary);
z70=ifrdescp(FDarray,70);
subplot(1,2,2);
imshow(bound2im(z70,355,255));
title('Fourier descriptor(70)');
