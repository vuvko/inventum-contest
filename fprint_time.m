function fprint_time(fid, time)

t_struct = gmtime(time);
%fprintf(fid, ctime(time));

fprintf(fid, "[%02d.%02d %02d:%02d:%02d] : ", t_struct.mday, t_struct.mon + 1,
    mod(t_struct.hour + 4, 24), t_struct.min, t_struct.sec);
