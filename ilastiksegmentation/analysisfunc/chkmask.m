
%% checking probability maps
for i = 1:21
    figure;
    imshow(pnuc(:,:,i));
end

%% checking raw images
for i = 1:6
    figure;
    imshow(inuc(:,:,i));
end
%%
for i = 1:21
    figure;
    imshow(pmasks(:,:,i));
end
%%
for i = 1:21
    figure;
    imshow(smasks(:,:,i));
end