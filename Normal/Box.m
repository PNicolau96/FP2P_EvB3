function bfig = Box(S,n)

bfig=figure(4);hold on;

for i=16:23
    plot(S.IE(i).concentration)
end
hold off


figure(5);
hold on;
for i=16:23
plot(S.IE(i).residence);
plot(S.IE(i).diff);
end
hold off