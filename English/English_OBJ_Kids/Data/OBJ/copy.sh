
x=39
for i in $( ls ); do 
    x=$((x+1))
    cp $i $x.png
done
