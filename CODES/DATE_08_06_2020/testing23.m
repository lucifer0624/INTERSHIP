clc;clear all;close all;

%Taking input
TorT = input('Enter 1 or 2 for Train and Test respectively ');
im_name = input('Enter the image number you want to find Circles between 1 and 15 ');
im_cno = input('Enter the No of circles ');

if(TorT == 1)
    name = strcat('Train/train_',int2str(im_name),'.png');
else
    name = strcat('Test/test_',int2str(im_name),'.png');
end

im_cno2 = im_cno;
im_cno3 = im_cno;

%Reading
H = imread(name);
H = rgb2gray(H);

%using Phase code method
[centers_1, radii_1, metric_1] = imfindcircles(H,[1 7],'ObjectPolarity','bright','Method','PhaseCode','Sensitivity',0.85);
if(size(radii_1) < im_cno)
    [im_cno,h] = size(radii_1);
end
centersStrong_1 = centers_1(1:im_cno,:); 
metricStrong_1 = metric_1(1:im_cno);
radiiStrong_1 = radii_1(1:im_cno);
print_metric_1 = metric_1;
%using Two Stage method
[centers_2, radii_2, metric_2] = imfindcircles(H,[1 7],'ObjectPolarity','bright','Method','TwoStage','Sensitivity',0.85);
if(size(radii_2) < im_cno2)
    [im_cno2,h] = size(radii_2);
end
centersStrong_2 = centers_2(1:im_cno2,:); 
metricStrong_2 = metric_2(1:im_cno2);
radiiStrong_2 = radii_2(1:im_cno2);
print_metric_2 = metric_2;
%plotting
figure;
subplot(1,3,1);imshow(H);
viscircles(centersStrong_1, radiiStrong_1,'EdgeColor','b');%using Phase code method
subplot(1,3,2);imshow(H);
subplot(1,3,3);imshow(H);
viscircles(centersStrong_2, radiiStrong_2,'EdgeColor','r');%using Two Stage method

%Displaying Results

%printing centers and radius
fprintf('\n Centers of the circles and their radius By Phase Code method \n')
for i = 1:im_cno
    fprintf('Circle %d: center ( %.4f , %.4f ) and radius is %.4f \n',i,centersStrong_1(i,1),centersStrong_1(i,2),radiiStrong_1(i));
end
fprintf('\n Centers of the circles and their radius By Two Stage method \n')
for i = 1:im_cno2
    fprintf('Circle %d: center ( %.4f , %.4f ) and radius is %.4f \n',i,centersStrong_2(i,1),centersStrong_2(i,2),radiiStrong_2(i));
end

%circles detetcted
fprintf('\n circles detected By Phase Code-: %d \n',im_cno);
fprintf('\n circles detected By Two Stage-: %d \n',im_cno2);
fprintf('\n Given No of circles to Detect-: %d \n',im_cno3);

[m,h] = size(print_metric_1);
[n,h] = size(print_metric_2);
print_metric_1(m+1)=0;
print_metric_2(n+1)=0;

%Printing all circles ananlysis
%fprintf('\n Metric analysis of the circles By Phase Code method \n')
for i = 1:m
    diff = (print_metric_1(i)-print_metric_1(i+1));
    diff_1(i) = (diff/print_metric_1(i))*100;
    %fprintf('Circle %d: Metric ( %.4f ) and Difference is %.4f and metric change %.4f per \n',i,print_metric_1(i),diff,(diff_1(i)));
end
%fprintf('\n Metric Analysis of the circles s By Two Stage method \n')
for i = 1:n
    diff = (print_metric_2(i)-print_metric_2(i+1));
    diff_2(i) = (diff/print_metric_2(i))*100;
    %fprintf('Circle %d: Metric ( %.4f ) and Difference is %.4f and metric change %.4f per \n',i,print_metric_2(i),diff,(diff_2(i)));
end

%stregnth variation plotting
figure;
subplot(1,2,1);plot(1:m,diff_1);grid on;axis tight;
subplot(1,2,2);plot(1:n,diff_2);grid on;axis tight;

Threshold_1 = 15;
Threshold_2 = 15;
if m<15 
    Threshold_1 = m-1;
end
if n<15 
    Threshold_2 = n-1;
end
[h,Metric_thre_1] = max(diff_1(2:Threshold_1));
[h,Metric_thre_2] = max(diff_2(2:Threshold_2));

%leaving 1st one
Metric_thre_1 = Metric_thre_1+1;
Metric_thre_2 = Metric_thre_2+1;

%Displaying Analysis Results

%printing centers and radius
fprintf('\n Metric analysis of the circles By Phase Code method \n')
for i = 1:Metric_thre_1
    diff = (print_metric_1(i)-print_metric_1(i+1));
    diff_1(i) = (diff/print_metric_1(i))*100;
    fprintf('Circle %d: Metric ( %.4f ) and Difference is %.4f and metric change %.4f per \n',i,print_metric_1(i),diff,(diff_1(i)));
end
fprintf('\n Metric Analysis of the circles s By Two Stage method \n')
for i = 1:Metric_thre_2
    diff = (print_metric_2(i)-print_metric_2(i+1));
    diff_2(i) = (diff/print_metric_2(i))*100;
    fprintf('Circle %d: Metric ( %.4f ) and Difference is %.4f and metric change %.4f per \n',i,print_metric_2(i),diff,(diff_2(i)));
end

%circles detetcted
fprintf('\n circles detected By Phase Code By Metric Analysis-: %d \n',Metric_thre_1);
fprintf('\n circles detected By Two Stage By Metric Analysis-: %d \n',Metric_thre_2);
fprintf('\n Setted No of circles Threshold-: 15 \n');

%plotting after metric analaysis
figure;
subplot(1,3,1);imshow(H);
viscircles(centers_1(1:Metric_thre_1,:), radii_1(1:Metric_thre_1),'EdgeColor','b');%using Phase code method
subplot(1,3,2);imshow(H);
subplot(1,3,3);imshow(H);
viscircles(centers_2(1:Metric_thre_2,:), radii_2(1:Metric_thre_2),'EdgeColor','r');%using Two Stage method

