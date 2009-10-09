function [specificbreath_per_event_corr]= Specific_breath_per_event(wave_segs,event,breath)

%function outputs a 1537 X 32 matrix that corresponds to the specific
%breath at the specific event samples for all 32 channels. this goes into
%the call_all function_correlationdistance_specificbreath function to graph
%correlations for the same breath over many events and see variability

for chan=1:32
    for i=1:length(wave_segs(1,:,1,1))                                          %go through all events
        wave_seg_specificbreath_per_event(:,i,chan)=wave_segs(:,i,breath,chan);   %go through all events and pick the breath you want
    end
end

for Chan=1:32

    specificbreath_per_event_corr(:,Chan)=wave_seg_specificbreath_per_event(:,event,Chan);             %now pick event you want to analyze to input into correlation call_all
end


