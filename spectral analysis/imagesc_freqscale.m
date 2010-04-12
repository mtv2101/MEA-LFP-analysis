function [image_scaled] = imagesc_freqscale(image)

dyn_range = max(image,[],1)-min(image,[],1);
for i=1:size(image,2) %2nd dim should be frequency (columns)
   image_scaled(:,i) = image(:,i)/dyn_range(i);
end
end