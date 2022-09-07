#!/bin/sh
# Experiments probability of fliping a coin n time (with multiple outcome) just to confirm the likelihood of getting a Head

echo "What is number of tests will be executed "
read N

HEADS=0
array=()

for n in `seq "$N"`
do
Result=$(((RANDOM%3) + 1))
if [[ ${Result} -eq 1 ]]; then
    HEADS=$((HEADS+1))
    # echo "count head: $HEADS"
    # echo "count total: $n"
    z=`echo "scale=2; $HEADS / $n" | bc -l`
    array+=("$n: $z")
fi
done

printf '%s\n' "${array[@]}" > toss-coin-probability.txt