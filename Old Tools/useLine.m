function pt = useLine(line, xval)

x = xval;
y = (line(1)*xval) + line(2);

pt = [x,y];


end