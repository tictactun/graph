function draw_surf(surf, f, alpha)

% function draw_surf draws a 3D surface with signal on its vertices.
%
% Input: 
%	surf: surface (vertices and faces)
%	f: function value at each vertex
%   alpha: controls opacity
%
% run camlight after the this code to see a better figure
%
% Coded by Won Hwa Kim, 2015
% Dept. of Computer Sciences, University of Wisconsin
%

if nargin < 2
    n = length(surf.vertices);
    f = ones(n,1);
    alpha = 1;
elseif nargin < 3
    alpha = 1;        
end

trisurf(surf.faces, surf.vertices(:,1), surf.vertices(:,2), surf.vertices(:,3), f, 'FaceAlpha', alpha);

daspect([1 1 1]);
axis vis3d;
axis image;
axis off;
view([-1 -1 1]);

lighting gouraud;
material metal;

shading interp;


% camlight