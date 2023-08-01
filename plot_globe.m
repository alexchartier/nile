function plot_globe(cdata, alpha, az, el, rad, txt, climit, clabel)
%% 3D globe plotting

arguments
    cdata (:, :, :) double = [nan nan nan]
    alpha double = 1
    az double = 0
    el double = 30
    rad double = 6371008.7714
    txt string = ''
    climit (:, :) double = [nan nan]
    clabel string = ''
end

%%
npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
GMST0 = 4.89496121282306; % Set up a rotatable globe at J2000.0
if isnan(cdata)
    image_file = '1024px-Land_ocean_ice_2048.jpg';
    cdata = imread(image_file);
end

% Mean spherical earth
erad    = rad; % equatorial radius (meters)
prad    = rad; % polar radius (meters)

%% set up figure
set(gcf, 'Color', 'k');
hold on;

% Turn off the normal axes
set(gca, 'NextPlot','add', 'Visible','off');
axis equal;
axis auto;

% Set initial view
view(az,el);
axis vis3d;

%% Create wireframe globe

% Create a 3D meshgrid of the sphere points using the ellipsoid function

[x, y, z] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);

gl = surf(x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5 * [1 1 1]);

if ~isempty(GMST0)
    hgx = hgtransform;
    set(hgx,'Matrix', makehgtform('zrotate',GMST0));
    set(gl,'Parent',hgx);
end

set(gl, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');
if ~isnan(climit(1))
    h = colorbar;
    clim(gca, climit)
    pos = h.Position;
    set(h, 'Color', 'w', 'Position', [pos(1), pos(2)*2, pos(3)*1.5, pos(4) * 0.7])
    ylabel(h, clabel, 'fontsize', 40)
end
ht = text(-erad, -erad * 2.2, txt, 'color', 'w', 'fontsize', 40, 'FontWeight', 'bold');
rotate(ht, [0, 0, 1], az)
rotate(ht, [1, 0, 0], el)

hold off


