clc
clear all
close all

resultsDir = 'H:\Tez\CALISMA\VREAD\RESULTS';
mkdir(resultsDir);
%%
%%read video file
%inFile = fullfile(dataDir,'baby.avi');
evmvid = VideoReader('H:\Tez\CALISMA\VREAD\DSC_0037_cutted_gray_resized480_rectified_rescaled360-FIRWindowBP-band1.00-5.00-sr50-alpha100-mp0-sigma0-scale0.50-frames1-9063-octave.avi'); 
vidHeight = evmvid.Height;
vidWidth = evmvid.Width;
fr=evmvid.FrameRate;
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
vidinfo=[vidHeight vidWidth fr clock];
dlmwrite('H:\Tez\CALISMA\VREAD\RESULTS\vidinfo_h_w_fr_t.txt', vidinfo);   

%%
%%decompose frames
numFrames = get(evmvid,'NumberOfFrames');
for k=1:numFrames
    s(k).cdata = read(evmvid,k);
    %whos s;
    image(s(k).cdata);
    
    %%define desired pixel location
    c = [175];
    r = [142];
    
    %%create color matrix
    pixels(k,:) = impixel(s(k).cdata,c,r);
    %impixelinfo;
    frames(k,:)=k;
    
    a=k
    saveas(image,'H:\Tez\CALISMA\VREAD\RESULTS\frame1.png')
end

%%
%%decompose color matrix columns
saveas(image,'H:\Tez\CALISMA\VREAD\RESULTS\frame.png')
red=pixels(:, 1);
redmatrix=[frames, red];
xlswrite('H:\Tez\CALISMA\VREAD\RESULTS\red matrix.xls', redmatrix);
green=pixels(:, 2);
greenmatrix=[frames, green];
xlswrite('H:\Tez\CALISMA\VREAD\RESULTS\green matrix.xls', greenmatrix);
blue=pixels(:, 3);
bluematrix=[frames, blue];
xlswrite('H:\Tez\CALISMA\VREAD\RESULTS\blue matrix.xls', bluematrix);
I=(0.2989*red)+(0.5870*green)+(0.1140*blue);
intensitymatrix=[frames, I];
xlswrite('H:\Tez\CALISMA\VREAD\RESULTS\intensity matrix.xls', intensitymatrix);
tt=frames/fr;
dplot=[tt,I];
xlswrite('H:\Tez\CALISMA\VREAD\RESULTS\dplot.xls', dplot);

%%
%%plot color-frame graphs
figure(2)
plot(frames, red), xlabel('frame'), ylabel('color value');
title('red color values by frame for selected pixel')
%outNameRED = fullfile(resultsDir,['video-framerate' fr '- pixel column' c '-pixel row-' r '.jpg']);
saveas(2,'H:\Tez\CALISMA\VREAD\RESULTS\red vgraph.png');
figure(3)
plot(frames, green), xlabel('frame'), ylabel('color value');       
title('green color values by frame for selected pixel')
saveas(3,'H:\Tez\CALISMA\VREAD\RESULTS\green vgraph.png');
figure(4)
plot(frames, blue), xlabel('frame'), ylabel('color value');
title('blue color values by frame for selected pixel')
saveas(4,'H:\Tez\CALISMA\VREAD\RESULTS\blue vgraph.png');
figure(5)
plot(frames, I), xlabel('frame'), ylabel('intensity value');
title('intensity(0,29R+0,58G+0,11B) values by frame for selected pixel')
saveas(5,'H:\Tez\CALISMA\VREAD\RESULTS\intensity vgraph.png');


%%
%calculate frequency of vibration using fft
dt=1/fr;
acc=I;
nn=length(acc);  %nn=2^(ceil(log2(nn)));
nn2=floor(nn/2);
f=[1:1:nn2]/(nn*dt);
accfft=fft(acc(1:nn));
accFAS=abs(accfft(1:nn2))/nn*2;
accPHASE=angle(accfft(1:nn2));
figure(6)
plot(f,accFAS),xlabel('frequency(hz)'), ylabel('FAS')
title('fourier amplitude')
saveas(6,'H:\Tez\CALISMA\VREAD\RESULTS\fourier amplitude graph.png');
fouriermatrix=[f, accFAS];
xlswrite('H:\Tez\CALISMA\160212\matlab\RESULTS\fourier matrix.xls', fouriermatrix);
figure(7)
plot(f,accPHASE), xlabel('frequency(hz)'), ylabel('phase')
title('phase spectra for corrected acceleration')
saveas(7,'H:\Tez\CALISMA\VREAD\RESULTS\phase spectra graph.png');
phasematrix=[f, accPHASE];
xlswrite('H:\Tez\CALISMA\160212\matlab\RESULTS\phase matrix.xls', phasematrix);

%%
%close all
