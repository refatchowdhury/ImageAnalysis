clc
clear
I=imread('ampelmaennchen.png');
S1=imread('ampelwelt.jpg');
S2=imread('cultural_notes.jpg');

% *****find the Fourier Descriptor of the image I*****
 Ibw=im2bw(I,0);
 B = bwboundaries(Ibw,'noholes');
 FDampelman=FDescriptor(B{1});
 
 H=abs(FDampelman);%rotation invariant
 D=abs(FDampelman(2));
 C=H/D;  %scale invariant
%  translation invariant
 for k=3:30
     Fcomp(k-2)=C(k);
 end

% work with scene1:ampelwelt.jpg
S1gray=rgb2gray(S1);
S1bw=im2bw(S1,0.2);
figure(1),subplot(2,2,1);
imshow(S1bw);
title('B&W image');
[B,L] = bwboundaries(S1bw,'noholes');
subplot(2,2,2);
imshow(label2rgb(L, @jet, [.5 .5 .5]));
title('Boundary detection of objects');
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
subplot(2,2,3);
imshow(S1);
title('RGB image');

for k=1:length(B)
%  b = B{1};
 FDs1array=FDescriptor(B{k});
 FDs1array=abs(FDs1array);
 D=FDs1array(2);
 C=FDs1array/D;  %scale invariant
%  translation invariant
 for l=3:length(C)
     FDs1comp(l-2)=C(l);
 end
  for i=1:28
 Fdiff(k,1)=sum(abs((FDs1comp(i)-Fcomp(i))^2));
 end
end

[v c]=min(Fdiff);
y=B{c};
subplot(2,2,4);
% imshow(label2rgb(L, @jet, [.5 .5 .5]));
imshow(S1);
title('Detected target object(FD=28)');
hold on
plot(y(:,2),y(:,1),'r', 'LineWidth', 2);

% ****************************************
% work with scene2:cultural_notes.jpg
S2gray=rgb2gray(S2);
S2bw=im2bw(S2,0.2);
figure(2),subplot(2,2,1);
imshow(S2bw);
title('B&W image');
[B,L] = bwboundaries(S2bw,'noholes');
subplot(2,2,2);
 imshow(label2rgb(L, @summer, [.5 .5 .5]));
title('Boundary detection of objects');
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end
subplot(2,2,3);
imshow(S2);
title('RGB image');

for k=1:length(B)
%  b = B{1};
 FDs1array=FDescriptor(B{k});
 FDs1array=abs(FDs1array);
 D=FDs1array(2);
 C=FDs1array/D;  %scale invariant
%  translation invariant
 for l=3:length(C)
     FDs1comp(l-2)=C(l);
 end
  for i=1:28
 Fdiff(k,1)=sum(abs((FDs1comp(i)-Fcomp(i))^2));
 end
end

[v c]=min(Fdiff);
y=B{c};
subplot(2,2,4);
% imshow(label2rgb(L, @jet, [.5 .5 .5]));
imshow(S2);
title('Detected target object(FD=28)');
hold on
plot(y(:,2),y(:,1),'r', 'LineWidth', 2);
