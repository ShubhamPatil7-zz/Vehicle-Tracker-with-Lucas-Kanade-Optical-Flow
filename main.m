% Author: Shubham Patil

function main()
    videoFReader = vision.VideoFileReader('data/highway1.mp4'); 
    cont = ~isDone(videoFReader);
    while cont
        currRGB = videoFReader();
        nextRGB = videoFReader();
        currGray = rgb2gray(currRGB);
        nextGray = rgb2gray(nextRGB);
        [u, v] = LkOpticalFlow(currGray,nextGray, 45, 'Harris');
        imagesc(currRGB); axis image; axis off; 
        hold on;
        quiver(u, v, 25, 'g');
        cont = ~isDone(videoFReader);
        pause(0.0000000000001)
    end
    release(videoFReader);
end