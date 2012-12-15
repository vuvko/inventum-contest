function Visualize(th, yh, tf, yf, remainder)

len = length(th);
tail_len = floor(len / remainder);
tail = yh(end - tail_len + 1:end);
block_size = 3;
block_num = floor(2 * len / block_size) - 1;
blocks = zeros(1, block_num);
mins = zeros(1, block_num);
maxs = zeros(1, block_num);
times = zeros(2, block_num);

for i = 0:block_num-1
    ed = len - i * floor(block_size / 2);
    bg = ed - block_size + 1;
    blocks(block_num - i) = mean(yh(bg:ed));
    times(1, block_num - i) = th(bg);
    times(2, block_num - i) = th(ed);
    mins(block_num - i) = min(yh(bg:ed));
    maxs(block_num - i) = max(yh(bg:ed));
    %plot([th(bg) th(ed)], [mean(yh(bg:ed)) mean(yh(bg:ed))], 'g');
end

hold on;
plot(times(2, :), blocks, 'g');
plot(times(2, :), mins, 'c');
plot(times(2, :), maxs, 'c');
plot([th(end - tail_len + 1) th(end)], [mean(tail) mean(tail)], 'm');
plot(th, yh, 'r');
plot(tf, yf, 'b');
