
%%
dirn = 'data/';
plot_fn_fmt = 'plots/{YYYYmmmdd_HHMM}.png';
in_fnames = dir(sprintf('%s*nc', dirn)); % NIMO_AQ_2017248.nc';
cm = colormap;
close

%% Loop over times and files
for f = 1:length(in_fnames)
    D = load_sami(sprintf('%s%s', dirn, in_fnames(f).name), ...
        {'year', 'day', 'alt', 'lat', 'lon', 'hrut', 'tec'});
    for t = 1:length(D.time)
        %% create the cdata
        vals = D.tec(:, :, t)';
        vals = vals(:);
        levs = linspace(min(vals), max(vals), 256);

        idx = imquantize(vals, levs);
        cdata = reshape(cm(idx, :), length(D.lat), length(D.lon), 3);


        %%
        set(gcf,'position',[10, 10, 1200, 1200]);
        plot_globe;
        hold on
        plot_globe(cdata, 0.8, 280, 30, 67E5, ...
            datestr(D.time(t), 'yyyy-mmm-dd HH:MM UT'), [0, 70], 'TEC (TECU)')
            % datestr(D.time(t), 'yyyy-mmm-dd HH:MM UT'), [0, 5E6], 'NmF2 (el. cm^{-3})')

        
        export_fig(filename(plot_fn_fmt, D.time(t)))
        pause(0.1)
        close
    end

end






