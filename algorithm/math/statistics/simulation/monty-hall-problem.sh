# Monty Hall Problem
echo "What is number of tests will be executed "
read N

SWITCH=0
NOSWITCH=0
switch_array=()
noswitch_array=()

for n in `seq "$N"`
do
Result=$(((RANDOM%3) + 1))
Choice=$(((RANDOM%3) + 1))

if [[ ${Result} -ne ${Choice} ]]; then
    SWITCH=$((SWITCH+1))
    z=`echo "scale=2; $SWITCH / $n" | bc -l`
    switch_array+=("$n: $z")
else
    NOSWITCH=$((NOSWITCH+1))
    z=`echo "scale=2; $NOSWITCH / $n" | bc -l`
    noswitch_array+=("$n: $z")
fi
done

printf '%s\n' "${switch_array[@]}" > monty-hall-switch.txt
printf '%s\n' "${noswitch_array[@]}" > monty-hall-noswitch.txt