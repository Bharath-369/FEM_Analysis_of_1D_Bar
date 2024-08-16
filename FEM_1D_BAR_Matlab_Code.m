%................................................................
% MATLAB codes for Finite Element Analysis
% Discrete_Systems.m

% clear memory

clear all  

% elementNodes: connections at elements

elementNodes=[1 2;2 3;3 4];

% numberElements: number of Elements

numberElements=size(elementNodes,1); 

% By using the MATLAB function size, that returns the number 
%of lines and columns of a rectangular matrix, we can detect 
%the number of elements by inspecting the number of lines of 
%matrix elementNodes.

% numberNodes: number of nodes

numberNodes=4;

% for structure:
% displacements: displacement vector
% force : force vector
% stiffness: stiffness matrix

% initializing the matrices

displacements=zeros(numberNodes,1);
force=zeros(numberNodes,1);
stiffness=zeros(numberNodes);

% applied load at node 4
force(4)=100.0;

% computation of the system stiffness matrix
% We compute now the stiffness matrix for each element in turn and then assemble
% it in the global stiffness matrix.
k_1=(2.67*10*200000/(100/3));
k_2=(2*10*200000/(100/3));
k_3=(1.33*10*200000/(100/3));
Ke=[k_1 -k_1 0 0 0 0;-k_1 k_1 0 0 0 0;0 0 k_2 -k_2 0 0;0 0 -k_2 k_2 0 0;0 0 0 0 k_3 -k_3;0 0 0 0 -k_3 k_3];
for e=1:numberElements;
% elementDof: element degrees of freedom (Dof)
elementDof=elementNodes(e,:) ;

stiffness(elementDof,elementDof)=...
stiffness(elementDof,elementDof)+Ke(2*e-1: 2*e,2*e-1: 2*e);
end


% boundary conditions and solution
% prescribed dofs
prescribedDof=[1];
% free Dof : activeDof
activeDof=setdiff([1:numberNodes],[prescribedDof]);

% solution
displacements=stiffness(activeDof,activeDof)\force(activeDof);
% positioning all displacements
displacements1=zeros(numberNodes,1);
displacements1(activeDof)=displacements;
% output displacements/reactions
outputDisplacementsReactions(displacements1,stiffness,numberNodes,prescribedDof)


%..............................................................
function outputDisplacementsReactions(displacements1,stiffness,GDof,prescribedDof)
% output of displacements and reactions in
% tabular form
% GDof: total number of degrees of freedom of
% the problem
% displacements
%displacements=displacements1;
GDof=4;
jj=[1:GDof]; 
disp('displacements')
 [ jj.' displacements1]

% reactions
F=stiffness*displacements1;
reactions=F(prescribedDof);
disp('reactions')
[prescribedDof reactions]
end
%...................................................................