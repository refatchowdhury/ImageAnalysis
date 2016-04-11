
I = imread('group.jpg');
% Detects upper body
bodyDetector = vision.CascadeObjectDetector('Nose'); 
bodyDetector.MinSize = [60 60];
bodyDetector.ScaleFactor = 1.05;

bboxes_ub = step(bodyDetector, I);

[M N]=size(bboxes_ub);%Assigning size of bboxes
x= bboxes_ub(:,1);%Assigning all x co-ordinates of bboxes
y= bboxes_ub(:,2);%Assigning all y co-ordinates of bboxes
w= bboxes_ub(:,3);%Assigning all width of bboxes
h= bboxes_ub(:,4);%Assigning all height of bboxes
% figure(1),title('Faces');
for i=1:M
 I_ub = imcrop(I,[x(i) y(i) w(i) h(i)]);%cropping images 
 subplot(4,3,i);
 imshow(I_ub);
end