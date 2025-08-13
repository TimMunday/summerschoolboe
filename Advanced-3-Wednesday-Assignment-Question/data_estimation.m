

load rGDP

Tr      = hpfilter(log(rGDP),6.23);
Ycyc    = log(rGDP) - Tr;
