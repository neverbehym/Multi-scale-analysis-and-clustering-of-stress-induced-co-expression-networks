function [D,W]=GPdist(data,... % ngenes*timepoints data matrix 
              timepoints)      % vector with timepoints                      


    
  %%  
  % ----------------------------------------------------------------------
  %                 Format data to pass to C++ code
  % ----------------------------------------------------------------------
   
  nDataItems=length(data(:,1));
  nFeatures = length(data(1,:));
  
  data_transp=data'; % transpose so the C++ code understands it 
  data_transp_vetc=reshape(data_transp,length(data_transp(:,1))*length(data_transp(1,:)),1);
  
  %%
  % ------------------------------------------------------------------------
  %                         Compute distance matrix in C++
  % ------------------------------------------------------------------------
            
  [GPdistvect]=RunGPdist(data_transp_vetc,...   % 0. transpose of ngenes*timepoints data matrix and resized into [ngenes*timepoints] vector 
              timepoints,...    % 1. vector with timepoints
              nDataItems,...    % 2. number of genes
              nFeatures);...    % 3. number of timepoints 
        
          
  %%
  
  % ------------------------------------------------------------------------
  %                         Export matrix 
  % ------------------------------------------------------------------------
     
  
GPdistMat=zeros(nDataItems);
          
         
start=0;
          
          
GPdistMat=zeros(nDataItems);
          
    for i=2:nDataItems
        
              GPdistMat(i,:)=[GPdistvect(start+1:start+(i-1))' zeros(1,nDataItems-(i-1))];
          
              start=start+(i-1);    
    end
    
GPdistMat=GPdistMat+GPdistMat';


W=1./(1+(exp(-GPdistMat))); % Weights matrix for stability analysis on W.*E, where E is the Relaxed Minimum Spanning Tree to be created


D=1-W; % Distance matrix for creating E

D=D-diag(diag(D)); % Enforce diagonal elements to be 0


W=W-diag(diag(W)); % Remove self-weights

  
  
end 
