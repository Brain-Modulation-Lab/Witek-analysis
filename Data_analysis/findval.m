function range = findval(startf, stopf, f)

range = find(f>startf,1,'first'):1:find(f<stopf,1,'last');
