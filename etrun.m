function data = etrun(sock, dur)
data = [];
tic
while toc < dur
    val = etgetval(sock);
    data = [data, val];
end
end