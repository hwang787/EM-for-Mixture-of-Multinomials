function [ class ] = mycluster( T, K )
     
%
% My goal of this Project is implementing my own text clustering algo.
%
% Input:
%     bow: data set. Bag of words representation of text document as
%     described in the assignment.
%
%     K: the number of desired topics/clusters. 
%
% Output:
%     class: the assignment of each topic. The
%     assignment should be 1, 2, 3, etc. 
%


% Initialization over parameters of distribution
%expectation__Di_to_c=[]
        % Initialize clusters (K clusters in total)
        %R=randperm(size(T,1),K);
        [m,n] = size(T);
        clusters=zeros(K,n);
        for i = 1:K
            clusters(i,:)=rand(1, n);
            clusters(i,:) = clusters(i,:)/sum(clusters(i,:));
        end
        pi_c=repmat(1/K,K,1);
        class=zeros(m,1);
        iteration=0;
        ExpectMatrix=zeros(m,K);
        recompute = true;
        compute = true;
  while recompute == true
      compute = true;
      clusters=zeros(K,n);
        for i = 1:K
            clusters(i,:)=rand(1, n);
            clusters(i,:) = clusters(i,:)/sum(clusters(i,:));
        end
        pi_c=repmat(1/K,K,1);
        class=zeros(m,1);
        iteration=0;
        ExpectMatrix=zeros(m,K);
   while compute == true
       ExpectMatrix_p=ExpectationCompute(T,K,clusters,pi_c);
       [clusters_p,pi_c_p] = maximizationCompute(ExpectMatrix_p,T);
       clusters=clusters_p;
       pi_c=pi_c_p;
       %[~, class_p] = max(ExpectMatrix_p, [], 2); 
       if iteration >1000
           
           compute = false;
           
       end
       
       if ExpectMatrix_p==ExpectMatrix
               [~, class] = max(ExpectMatrix_p, [], 2);
               recompute = false;
               compute = false;
           break
       end
       ExpectMatrix=ExpectMatrix_p;
       %class=class_p;
       iteration=iteration+1
   end
   
  end
        
  
        %Expectation
        %Compute the expectation of document Di belonging to cluster c:
        %ExpectMatrix_p=ExpectationCompute(T,K,clusters,pi_c);
        %ExpectMatrix=ExpectMatrix_p;
    function[ExpectMatrix]=ExpectationCompute(T,K,clusters,pi_c)
        [m,n] = size(T);
        ExpectMatrix=zeros(m,K);
        for i = 1:size(T,1)
            D=T(i,:);
            if D==zeros(1,n)
               ExpectMatrix(i,:)=pi_c;
            end
            for clusterindex = 1:K
                cluster = clusters(clusterindex,:);
                
                ExpectMatrix(i,clusterindex)=pi_c(clusterindex)*prod(cluster.^D,"all");
            end
            ExpectMatrix(i,:)= ExpectMatrix(i,:)/sum(ExpectMatrix(i,:));
        end
        
    end
        %Update the mixture parameters; cluster 
        % the probability of a word being Wj in cluster (topic) c, 
        % as well as prior probability of each cluster.
        %[clusters_p,pi_c_p] = maximizationCompute(ExpectMatrix,T)
    function[clusters_p,pi_c_p]=maximizationCompute(ExpectMatrix,T)
        [m,n] = size(T);
        clusters_p=zeros(K,n);
        for i = 1:K
            for j=1:n
                clusters_p(i,j)=sum(ExpectMatrix(:,i).*T(:,j));
            end
           
            clusters_p(i,:) = clusters_p(i,:)/sum(clusters_p(i,:));
        end
        %Update the mixture parameters; pi_c
        pi_c_p=mean(ExpectMatrix);
    end
    
        


end

