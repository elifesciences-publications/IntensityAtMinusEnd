%% MEASURE INTENSITY OF PUNCTUM AT MINUS-END OVER TIME AFTER ABLATION
% 
% 'ablatTraceData' input: A struct containing information about the position of the
% k-fiber minus-end over time. 
% ablatTraceData.xyfXYTd contains the x- and y-coordinates of the
% minus-end (manually tracked) in its first two columns; the movie frame
% number in its third column 'f'; the time since ablation in its sixth
% column 'T'. The fourth, fifth, and seventh columns were not used in this
% particular analysis.

% 'tracesToAnalyze': a vector specifying which traces (i.e. which rows in
% ablatTraceData.xyfXYTd correspond to the movie you have currently loaded
% into 'imageIntensityMatrix'.

% 'imageIntensityMatrix': a matrix representing the movie you want to
% analyze, where values are intensity, the 1st and 2nd dimensions are pixel
% positions, and the third dimension is time/frames. In this case, movies
% were of GFP-Arp1A, GFP-NuMA, or GFP-CAMSAP1 puncta and their recruitment
% to minus-ends after ablation.

% 'ablatTraceData' output: This function will add to the ablatTraceData struct:
% the intensity of a punctum (e.g., GFP-NuMA)at that minus-end over time. 

function [ablatTraceData] = punctaMeasure(ablatTraceData,tracesToAnalyze,imageIntensityMatrix)
%se and se2 are the structural elements, in pixels. se = square of interest, 
%se2 = expansion outward (donut) to measure local background

bin=input('Enter bin size');

se=strel('square',14/bin);
se2=strel('square',26/bin);

% this does intensity measurements only for traces chosen
% ('tracesToAnalyze')
for i=tracesToAnalyze(1):tracesToAnalyze(end)
    ablatTraceData(i).timeSinceAblation=ablatTraceData(i).xyfXYTd(:,6);
    frames=ablatTraceData(i).xyfXYTd(:,3);
     
    intden=zeros(size(frames,1),1);
    BGLocal=zeros(size(frames,1),1);
    sBGLocal=zeros(size(frames,1),1);

    imgsiz=imageIntensityMatrix(:,:,frames);
    
        %Creates a binary array of zeros and puts a 1 at the manually
        % chosen coordinates for each frame, q
    for q=1:size(frames,1)
        mask=zeros(512/bin); %set for 512x512 camera chip
        mask=logical(mask);

        mask(round(ablatTraceData(i).xyfXYTd(q,2)),round(ablatTraceData(i).xyfXYTd(q,1)))=1;
        %mark the spot where the punctum is in frame i
        maskPuncta=imdilate(mask,se);
        maskLocal=imdilate(mask,se2);
        %the line below subtracts the chosen 7x7 from a 9x9 to leave a
        %donut of background
        maskLocal=maskLocal-maskPuncta;
        %Make 7X7 or 14x14 (bin1) mask over which I will measure intensity, centered at
        %the punctum trace point
        slice=imgsiz(:,:,q);
        comp=masker(slice,maskPuncta);
        complocal=masker(slice,maskLocal);
        complocal(complocal==0)=[];
        %the line below sums up intensities for background donut
        BGLocal(q)=sum(complocal);
        sBGLocal(q,1)=BGLocal(q)/120*49;

        %Set everything outside this mask in the punctum image to zero
        comp(comp==0)=[];
        intden(q)=sum(comp);
       
    end
  
    % The below was written for a data set where tracking began 3 frames
    % before ablation (so 4,1 = first frame after ablation)
    
    ablatTraceData(i).rawIntDen=intden; %raw intensity at minus-end
    ablatTraceData(i).BGIntDen=sBGLocal; %intensity in background donut
    ablatTraceData(i).IntDenSubtract=intden-sBGLocal; %intensity at end, minus background
    ablatTraceData(i).IntDenSubtractMinusNegOne=ablatTraceData(i).IntDenSubtract-ablatTraceData(i).IntDenSubtract(3,1);

end

