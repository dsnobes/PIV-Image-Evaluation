function mask=pivTubeMask(image,settings)
% makes a mask for the inner boundaries of the tube given mean image.
% Settings are vector of integers values for:
% initial threshold scaling
% initial edge dilation
% initial edge erosion
% initial mask erosion
% initial mask dilation
% vertical mask erosion
% display trigger (1 to display)

% make sure no open figures so we don't overload RAM
%close all
%load a test image if we're running the code as a test
% if nargin<1
%     image=loadvec('B00001_avg.im7');
% else
%     image=loadvec(fileLoc);
% end

% settings
if nargin<2 || length(settings)~=7
    % defaults
    thresh=20;
    dE=15;
    eE=17;
    eM1=11;
    dM1=5;
    eM2=200;
    display=1;
    warning('Using default settings')
else
    thresh=settings(1);
    dE=settings(2);
    eE =settings(3);
    eM1=settings(4);
    dM1=settings(5);
    eM2=settings(6);
    display=settings(7);
end

% thresholding
% im1=image/max(max(image))*thresh;
% im1(im1>1)=1;
im1 = image;

% vertical filtering
im=imfilter(im1,ones(2048*2,1)/2048/2);

%edge detection
edges=edge(im,'Prewitt','Vertical');

% change edges to mask. This is complicated and requires much testing.
edges2=imerode(imdilate(edges,ones(1,dE)),ones(1,eE));
mask=imerode(imdilate(imerode(imfill(edges2,[1024,1024]),ones(1,eM1)),ones(1,dM1)),ones(eM2,1));
if max(max(mask))==0 || min(min(mask))==1
    error(['Mask did not generate for ' sprintf([fileLoc '.\n']) 'Filter adjustment needed.'])
end
% display if asked to when calling the function
if display==1
    figure
    imshow(im1);

    figure
    imshow(im);

    figure
    imshow(edges);

    figure
    imshow(edges2);

    figure
    imshow(mask);

end
% write figures to current directory if we're testing the code
if nargin==0
    imwrite(im1,'Startim.png');
    imwrite(im,'Filtim.png');
    imwrite(edges,'Initialedges.png');
    imwrite(edges2,'Finaledges.png');
    imwrite(mask,'mask.png');
    imwrite(mask.*im1,'masked.png');
end