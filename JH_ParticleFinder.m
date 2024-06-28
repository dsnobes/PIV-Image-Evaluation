function [cnt,focIm, p2, pImg]=JH_ParticleFinder(settings, focIm)
% Finds particles in 3D from light field focused image + depth data.
% Expects one focused image and 3 depth images.
% Inputs:
% imID - Image file name (eg, Image_0001)
% imFmt - Image file extension (eg, .png)
% path - Image file location
% CalLoc - Calibration file location
% Display - how much display to do (integer, 0 to 2)
% Outputs:
% particles - 3D particle field, in the same units as the calibration file

% Settings
pkthresh = settings(1);
psize = settings(2);
noisescale = settings(3);
noisethresh = settings(4);
intThresh = settings(5);
%drt = app.settings(6);
if intThresh == 0
    if max(max(focIm)) > 255 && max(max(focIm)) < 4096
        focIm = uint16(focIm);
        R = [0:4095];
        G = [0:4095];
        B = [0:4095];
        map = [R',G',B']/4095;
        [counts, bins] = imhist(focIm, map);
    elseif max(max(focIm)) > 4096
        focIm = uint16(focIm);
        [counts, bins] = imhist(focIm);
    else
        [counts, bins] = imhist(focIm);
    end
    if ~iscolumn(bins)
        bins = bins';
    end
    intThresh = sum(counts.*bins)/sum(counts);
    intThresh = 1.5*intThresh;
end

% 2D Centroid Location
% FILTER IMAGE
% IMAGE : Threshold : size of particle (longer)
binIm = bpass(focIm,noisescale,psize,noisethresh);     %%%% Pr0cessed images  %%%%%

% figure
% imagesc(binIm);

pImg = binIm/max(max(binIm));
%imshow(pImg);

% FIND PARTICLES
% IMAGE : Image Threshold : size of particle (longer)
pk = pkfnd(binIm,pkthresh,psize);

% Do again to sub-pixel
cnt = cntrd(double(focIm),pk,psize, intThresh);
p2 = cnt;
% hold on
% if handles.pd_particles_cbox.Value
%     sPlot = scatter(cnt(:,1),cnt(:,2),pi*handles.pd_fpr*handles.pd_fpr,...
%         'MarkerEdgeColor', handles.pd_fpc, 'Marker', handles.pd_fpm);
% end
% hold off

% JITTER CORRECTIO
ncs=0;
nrs=0;

cnt=[cnt(:,1)-ncs,cnt(:,2)-nrs,zeros(length(cnt),1)];