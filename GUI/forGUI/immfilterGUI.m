function mobile = immfilterGUI(ax,movie);

cla(ax)
ylim(ax,[0,1])
xlim(ax,[0,1])
ph = patch(ax,[0 0 0 0],[0 0 1 1],[0.67578 1 0.18359]); %greenyellow
th = text(ax,1,1,'Filtering Data...0%','VerticalAlignment','bottom','HorizontalAlignment','right');
moviefft = zeros(size(movie));
ph.XData = [0 1/3 1/3 0];
th.String = sprintf('%Filtering Data....0f%%',round((1/3)*100));
drawnow %update graphics
moviefft = fft(double(movie),[],3);
ph.XData = [0 2/3 2/3 0];
th.String = sprintf('%Filtering Data....0f%%',round((2/3)*100));
drawnow %update graphics
moviefft(:,:,1) = 0;
mobile = real(ifft(moviefft,[],3));

ph.XData = [0 3/3 3/3 0];
th.String = sprintf('%Filtering Data....0f%%',round((3/3)*100));
drawnow %update graphics