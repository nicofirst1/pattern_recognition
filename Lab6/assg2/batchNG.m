function [prototypes] = batchNG(Data, n, epochs, xdim, ydim)

% Batch Neural Gas
%   Data contains data,
%   n is the number of clusters,
%   epoch the number of iterations,
%   xdim and ydim are the dimensions to be plotted, default xdim=1,ydim=2

error(nargchk(3, 5, nargin));  % check the number of input arguments
if (nargin<4)
  xdim=1; ydim=2;   % default plot values
end

[dlen,dim] = size(Data);

%prototypes =  % small initial values
% % or
sbrace = @(x,y)(x{y});
fromfile = @(x)(sbrace(struct2cell(load(x)),1));
prototypes=fromfile('clusterCentroids.mat');
prot_len=size(prototypes,1);
lambda0 = n/2; %initial neighborhood value
% lambda
lambda = lambda0 * (0.01/lambda0).^([0:(epochs-1)]/epochs);
% note: the lecture slides refer to this parameter as sigma^2
%       instead of lambda

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Action

for ep=1:epochs
 
  % initialize distance matrix [data point, protos]
  dist_mat=zeros(dlen,prot_len);
  % get current lambda for epoch
  lambda_ep=lambda(ep);
  
  % for every proto
  for i=1:prot_len
      
      num=0;
      den=0;
      
      % get the proto
      wi=prototypes(i,:);
      % get distance between proto and every data point
      dist_mat(:,i)=d(wi,Data);
  end
  
  % initialize the rank mat
  rank_mat=zeros(dlen,prot_len);
  
  % for every row [i.e. data point]
  for row=1:dlen
     
      % get the row
      r=dist_mat(row,:);
      % get the rank for every proto
      [~,~,rank]=unique(r);
      % update the rank mat
      rank_mat(row,:)=rank;
      
  end
  
  % bring ranks in range 0-inf
  rank_mat=rank_mat-1;
  
  % compute the h function [exp(-t/lambda)] 
  H_mat=exp(-rank_mat/lambda_ep);
  
  % split in numerator and denominator mats
  den_mat=H_mat;
  % num has third dimension [data points, proto len, features]
  num_mat=zeros(dlen,prot_len,2);
  
  % for every datapoint
  for row=1:dlen
      
      % get the row 
      rank_row=H_mat(row,:);
      % multiply by the datapoint adn update
      num_mat(row,:,:)=rank_row'*Data(row,:);
      
  end
  
  % sum on colums [j for loop avoived]
  num_mat=sum(num_mat,1);
  den_mat=sum(den_mat,1);
  
  % remove third dimension 
  new_prot=reshape(num_mat,[prot_len,2]);

  % divide by denominator element wise for each feature
  new_prot(:,1)=new_prot(:,1)./den_mat';
  new_prot(:,2)=new_prot(:,2)./den_mat';
  
  
  % assign new protos
  prototypes=new_prot;
     
  fprintf(1,'%d / %d \r',ep,epochs);
       
  % track
  if 0   %plot each epoch
    hold off
    plot(Data(:,xdim),Data(:,ydim),'bo','markersize',3)
    hold on
    plot(prototypes(:,xdim),prototypes(:,ydim),'r.','markersize',10,'linewidth',3)
    
    voronoi(prototypes(:,xdim),prototypes(:,ydim));
    drawnow
  end
end
end


function k=k_i(x,idx,protos)
    
    dist=d(x,protos);
    [~,ranks]=sort(dist);
    k=find(ranks==idx);
    k=k-1;
    %smaller_ranks= ranks(1:find(ranks==idx));
    %smaller_protos=protos(smaller_ranks,:);
    
    
    
end

function dist=d(x,y)
    
    dist=sqrt((x(1)-y(:,1)).^2 + (x(2)-y(:,2)).^2);
    
end

function h=h(t,lambda)

    h=exp(-t/lambda);

end
