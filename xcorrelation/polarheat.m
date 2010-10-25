%polarheat(corr_breath,1:32,coordinates,19,11)

function [bx by x y] = polarheat(corr_breath,event,breath)
chans = 1:32;
coors1 = repmat([0:200:600], [8 1]);
coors2 = repmat([0:200:1400]', [4 1]);
coordinates = [coors1(:) coors2];

myx=repmat(coordinates(chans,1),1,length(chans));
myy=repmat(coordinates(chans,2),1,length(chans));
dist = sqrt((myx' -  myx).^2 + (myy' -  myy).^2);
angles = atan((myy' -  myy) ./ (myx' -  myx));

%dist and angles are both 32x32, so dist(4,12) is distance from 
%electrode 4 to 12. same for angles. We convert these to x,y below.

figure
polar(angles(1,:),dist(1,:),'bo')
[x y] = pol2cart(angles,dist);
%might as well convert these to xy coord


%since the angles and lengths are limited, we really just
%recreate the layout of the array. Since we don't want
%to keep 
bx = blur(x);
by = blur(y);

cb = corr_breath(:,:,event,breath);
figure
scatter3(x(:),y(:),cb(:))
figure
%scatter3(bx(:),by(:),cb(:))
figure; 
for i=1:length(x(:)) 
    col = cb(i); 
        if isnan(col) 
            col=0; 
        end; 
    plot(bx(i),by(i),'Color',[col*0.9 0 0 ],'Marker','.','MarkerSize',20); hold on; 
end
axis image


function blurred=blur(m)
blurred = m + (rand(size(m)) -0.5)*std(m(~isnan(m)))/5;
blurred = m + (rand(size(m))*2 -1)*50;
end

end
