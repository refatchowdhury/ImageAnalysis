RGB = imread('cube.jpg');

% Convert to intensity.
I  = rgb2gray(RGB);

% Extract edges.
BW = edge(I,'canny');
[H,T,R] = hough(BW,'RhoResolution',0.5,'Theta',-90:0.5:89.5);

% Display the original image.
subplot(2,2,1);
imshow(RGB);
title('Cube Image');
subplot(2,2,2);
imshow(BW);
title('Canny Image');

% Display the Hough matrix.
subplot(2,2,[3 4]);
imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough Transform of Cube Image');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(hot);
P= houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));%detect peaks
x=T(P(:,2));
y=R(P(:,1));
plot(x,y,'s','color','blue');
%find lines & plot them
lines=houghlines(BW,T,R,P,'FillGap',5,'Minlength',7);
figure,imshow(RGB),hold on
max_len=0;
for k=1:length(lines)
     xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'linewidth',2,'color','green');
    %plot begining and ends of lines
    plot(xy(1,1),xy(1,2),'x','Linewidth',2,'color','yellow');
    plot(xy(2,1),xy(2,2),'x','Linewidth',2,'color','red');
    %determine the end points of longer line segments
    len = norm(lines(k).point1 - lines(k).point2);
    if (len>max_len) max_len=len;
        xy_long=xy;
    end
end


