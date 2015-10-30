%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:N
    P.cliqueList(i).var = C.nodes{i};
end
P.edges = C.edges;

% Assign a factor to a clique
factorToClique = zeros(length(C.factorList), 1);
for i = 1:length(C.factorList)
    for j = 1:N
        aFactor = C.factorList(i).var;
        aClique = C.nodes{j};
        if all(ismember(aFactor, aClique))
            factorToClique(i) = j;
            break;
        end
    end
end

% Compute the initial potentials
for i = 1:N
    fIndices = find(factorToClique == i);
    prodFactor = C.factorList(fIndices(1));
    for j = 2:length(fIndices)
        prodFactor = FactorProduct(prodFactor, C.factorList(fIndices(j)));
    end
    
    [V, I] = sort(prodFactor.var);
    out.card = prodFactor.card(I);
    allAssignmentsIn = IndexToAssignment(1:prod(prodFactor.card), prodFactor.card);
    allAssignmentsOut = allAssignmentsIn(:,I);
    out.val(AssignmentToIndex(allAssignmentsOut, out.card)) = prodFactor.val;
    P.cliqueList(i).card = prodFactor.card(I);
    P.cliqueList(i).val = out.val;
end

end

