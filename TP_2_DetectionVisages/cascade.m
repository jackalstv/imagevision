function output = cascade(classifiers,img,thresh)
result = 0;
px = size(classifiers,1);
weightSum = sum(classifiers(:,12));
for i = 1:px % iterate through each classifier
    classifier = classifiers(i,:);
    haar = classifier(1);
    pixelX = classifier(2); pixelY = classifier(3);
    haarX = classifier(4); haarY = classifier(5);
    % calculate the feature value for the subwindow using the current classifier
    haarVal = calcHaarVal(img,haar,pixelX,pixelY,haarX,haarY);
    if haarVal >= classifier(9) && haarVal <= classifier(10) % increase score by the weight of the corresponding classifier
        score = classifier(12);
    else
        score = 0;
    end
    result = result + score;
end
% compare resulting weighted success rate to the threshold value
if result >= weightSum*thresh
    output = 1; % hit
else
    output = 0; % miss
end

end