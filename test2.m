function [] = test2( )
load('data');
T = X(:,1:100);
label = X(:,101);
%display(T)
%K=4
%R=randperm(size(T,1),K);
%%for i = 1:K
    %clusters(i,:) = clusters(i,:)/sum(clusters(i,:))
%end
IDX = mycluster(T,4);
display(IDX)


acc=AccMeasure(label,IDX)


% ======================== uncomment the following for extra task ========================
% n_topics = None # TODO specify num topics yourself
load('nips','wl')
raw_count = X(:,1:100);

n_topics=10;
[W] = mycluster_extra(raw_count, n_topics);
% use show_topics to display your result
show_topics(W,wl);
%cc_extra=AccMeasure(wl,W);


end
