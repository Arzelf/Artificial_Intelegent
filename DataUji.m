clc;clear;close all;
image_folder = 'Tubes';
total_images=27;
for n = 1:total_images
    full_name = fullfile(image_folder, strcat('Data_uji (',num2str(n),').jpg')) ;
    I = imread(full_name);
    J = I(:,:,1);
    K = im2bw(J,.6);
    L = imcomplement(K);
    str = strel('disk',1);
    M = imclose(K,str);
    N = imfill(M,'holes');
    O = bwareaopen(N,1000);
    stats = regionprops(N,'Area','Perimeter','Eccentricity');
    area(n) = stats.Area;
    perimeter(n) = stats.Perimeter;
    metric(n) = 4*pi*area(n)/(perimeter(n)^2);
    eccentricity(n) = stats.Eccentricity;
end
 
input = [metric;eccentricity];
target = zeros(1,17);
target(:,1:3) = 1;
target(:,4:5) = 2;
target(:,6) = 6;
target(:,7) = 2;
target(:,8:9) = 3;
target(:,10:11) = 4;
target(:,12:13) = 5;
target(:,14:15) = 6;
target(:,16:17) = 7;
target(:,18:21) = 8;
target(:,22:23) = 9;
target(:,14:27) = 10;



 
load net
output = round(sim(net,input));
 
[m,n] = find(output==target);
akurasi = sum(m)/total_images*100