%returns a matrix that is [time*events*breaths x chans]
%so lbc(i) returns all data for channel i.
%
% optionally specify:
% ev: vector of indexes of events to include
% br: vector of indexes of breaths to include
% ch: vector of indexes of channels to include
% the above will default to the entire data set for that dimension
% if set to 0 instead of an array
%
% the last three parameters are optional, but if used
% they must all be specified
% ex: linearize_bychan(wave_segs)
% ex: linearize(bychan(wave_segs,0,0,1:20)
% the above will include all breaths and events, but exclude chans 21-32
%
% Armen Enikolopov May 19, 2010

function lbc = linearize_bychan(data,ev,br,ch)

if isequal(ev,0) ev = 1:size(data,2); end
if isequal(br,0) br = 1:size(data,3); end
if isequal(ch,0) ch = 1:size(data,4); end

%ev,br,ch,

lbc = reshape(data(:,ev,br,ch),size(data,1)*length(ev)*length(br),length(ch));
end