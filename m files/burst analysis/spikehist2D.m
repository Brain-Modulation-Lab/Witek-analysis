function [vpos, vneg, S] = spikehist2D(Hneg, Hpos, dur)

nbins = 200;
negindex = find(Hneg~=0);
posindex = find(Hpos~=0);

if(posindex(1) < negindex(1))
    posindex = posindex(2:length(posindex));
end

if(negindex(length(negindex)) > posindex(length(posindex)))
    negindex = negindex(1:length(negindex)-1);
end

negspike = Hneg(negindex);
posspike = Hpos(posindex);

S = zeros(nbins);
negstep = (max(negspike)-min(negspike))/nbins;
vneg = (max(negspike)-min(negspike))*(1:nbins)/nbins + min(negspike);
vpos = (max(posspike)-min(posspike))*(1:nbins)/nbins + min(posspike);

for i=1:nbins
    z = posspike(find(negspike>=(i-1)*negstep & negspike<i*negstep));
    S(i,:) = hist(z,nbins);
end