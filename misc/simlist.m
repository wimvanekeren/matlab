function [r,p] = simlist(simfcn,pList,pBase)
% [r,p] = simlist(simfcn,pList,pExtra)
% executes permutation of simulations all parameter combinations in pList,
% with extra (constant) parameters pExtra
% simfcn,pList,pExtra

    
fn_pList = fieldnames(pList);
fn_pBase = fieldnames(pBase);
fn_p     = unique({fn_pList{:},fn_pBase{:}});

n_param = length(fn_pList);

% make size
p_size = ones(1,n_param);
for i=1:n_param
    p_size(i) = length(pList.(fn_pList{i}));
end

% initialize result cell // parameter cell
if length(p_size)==1
    r = cell(p_size,1);
    p = struct;
else
    r = cell(p_size);
    
    p =  struct;
    
    % make fieldnames from pList and pExtra
    for j=1:length(fn_p)
        p.(fn_p{j}) = cell(p_size);   
    end
    
end
    
for i=1:numel(r)

    % the simulation iterator i is converted to a subidx with ind2sub. each
    % elemend of subidx corresponds to a parameter list index. because i
    % walks from 1 to the total number of elements, with subidx all
    % different parameter possibilities are created.
    subidx = deal_n_out(@ind2sub,n_param,p_size,i);

    % first set parameters to equal Base parameters
    this_p = pBase;
    
    % then overwrite parameters with List parameters
    for j=1:n_param
        this_p.(fn_pList{j}) = pList.(fn_pList{j})(subidx{j});
    end
    
    disp(['Sim ' num2str(i) '/' num2str(numel(r))]) 
    this_r = simfcn(this_p);

    % store output
    r{i} = this_r;
    
    % store parameters
    for j=1:length(fn_p)
        p.(fn_p{j}){i} = this_p.(fn_p{j});   
    end

end

