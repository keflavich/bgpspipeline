#for i in $( ls -d */ ); do
for i in $( cat /home/milkyway/student/ginsbura/pointing/0506_sources ); do
        cd $i
#       pwd
        name=${i:0:${#i}-1}
#       echo $name $i
        ls `pwd`/0506*_raw.nc > ${name}_0506_rawlist.txt
        cd ..
#       read tempvariable
done
