function [p, t] = SmoothPrice(price, block_size)

%block_size = 2000;
block_num = floor(size(price) / block_size);

time = PriceTime(price);
pr = price(:, end);

%y = price;
p = zeros(block_num, 1);
t = zeros(block_num, 1);

for i = 1:block_num
    bg = (i - 1) * block_size + 1;
    ed = i * block_size;
    p(i) = mean(pr(bg:ed));
    t(i) = time(floor((bg + ed) / 2));
end

%tmp = repmat(p, block_size, 1);
%y(1:block_size * block_num) = tmp(:);

%if block_size * block_num < size(y) 
%    y(block_size * block_num:end) = mean(y(block_size * block_num:end));
%end

end;
