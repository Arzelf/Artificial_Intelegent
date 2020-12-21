clc;clear;close all;
image_folder = 'Tubes';
total_images=88;
for n = 1:total_images
    full_name = fullfile(image_folder, strcat('Data_latih (',num2str(n),').jpg')) ;
    I = imread(full_name);
    J = I(:,:,1);
    K = im2bw(J,.6);
    L = imcomplement(K);
    str = strel('disk',1);
    M = imclose(L,str);
    N = imfill(M,'holes');
    O = bwareaopen(N,1000);
    stats = regionprops(N,'Area','Perimeter','Eccentricity');
    area(n) = stats.Area;
    perimeter(n) = stats.Perimeter;
    metric(n) = 4*pi*area(n)/(perimeter(n)^2);
    eccentricity(n) = stats.Eccentricity;
end
 
input = [metric;eccentricity];
target = zeros(1,88);
target(:,1:7) = 1;
target(:,8:15) = 2;
target(:,16:25) = 3;
target(:,26:33) = 4;
target(:,34:41) = 5;
target(:,42:49) = 6;
target(:,50:58) = 7;
target(:,59:66) = 2;
target(:,67:73) = 8;
target(:,74:80) = 9;
target(:,81:88) = 10;

net = newff(input,target,[10 5],{'logsig','logsig'},'trainlm');
net.trainParam.epochs = 1000;
net.trainParam.goal = 1e-6;
net = train(net,input,target);
output = round(sim(net,input));
save net.mat net
 
[m,n] = find(output==target);
akurasi = sum(m)/total_images*100