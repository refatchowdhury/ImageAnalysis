% Create a detector object.

 	
faceDetector = vision.CascadeObjectDetector;

% Read input image.

I = imread('group.jpg');
% I= im2double(I);

% Detect faces.

bboxes = step(faceDetector, I);

[M N]=size(bboxes);%Assigning size of bboxes
x= bboxes(:,1);%Assigning all x co-ordinates of bboxes
y= bboxes(:,2);%Assigning all y co-ordinates of bboxes
w= bboxes(:,3);%Assigning all width of bboxes
h= bboxes(:,4);%Assigning all height of bboxes
% figure(1),title('Faces');
for i=1:M
 IFaces = imcrop(I,[x(i) y(i) w(i) h(i)]);%cropping images 
 subplot(2,3,i);
 imshow(IFaces);
end


