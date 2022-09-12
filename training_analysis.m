load('simin1.mat')
simin1 = simin.Data;
load('simin2.mat')
simin2 = simin.Data;
load('simin3.mat')
simin3 = simin.Data;
load('simin4.mat')
simin4 = simin.Data;
load('simin5.mat')
simin5 = simin.Data;

clear simin
simin = [simin1;simin2;simin3;simin4;simin5];
figure(1)
histogram(simin(:,1))
title('Histogram of irradiance')
figure(2)
histogram(simin(:,2))
title('Histogram of ambient temp')
figure(3)
histogram(simin(:,3))
title('Histogram of cell temp')
figure(4)
histogram(gradient(simin(:,1)))
title('Histogram of irradiance gradient')