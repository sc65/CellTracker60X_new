function [ fileinfo, start] = readdirectory(dir1)
fileinfo = dir(dir1);
nelem = size(fileinfo, 1);

for i = 1:nelem
    fn = fileinfo(i).name;
    
    if(fn(1)~= '.')
        start = i;
        break;
    end
end
end