#!/bin/sh
clear

which bc > /dev/null || echo "Error: bc isn't installed in the system"
which figlet > /dev/null || echo "Error: figlet isn't installed in the system"

cat ./linuxupc.ascii 
sleep 2s

time_1st=$( cat ./leaderboard/1st/time )
name_1st=$( cat ./leaderboard/1st/name )
time_2nd=$( cat ./leaderboard/2nd/time )
name_2nd=$( cat ./leaderboard/2nd/name )
time_3rd=$( cat ./leaderboard/3rd/time )
name_3rd=$( cat ./leaderboard/3rd/name )
time_latest=$( cat ./leaderboard/latest/time )
name_latest=$( cat ./leaderboard/latest/name )

clear
echo " "
echo "L e a d e r     B o a r d:"
echo " "
echo "1st: $name_1st - $time_1st"
echo " "
echo "2nd: $name_2nd - $time_2nd"
echo " "
echo "3rd: $name_3rd - $time_3rd"
echo " "
echo "Latest: $name_latest - $time_latest"
echo " "
echo " "
echo " "
read -p "\$ Enter your username: " username
clear
echo "You will now have to close a bunch of classic text editors in order, try to go as fast as you can!"
echo "But keep in mind that you can't close the terminal (or kill this process)"
read -n 1 -s -p "Press any key to continue..." dummy
clear
figlet 3
sleep 1s
clear
figlet 2
sleep 1s
clear
figlet 1
sleep 1s
clear
figlet GOOOO!!!! > ./go.ascii
for editor in $(cat ./editors); do
	clear
	st=$(date +%s.%N)
	$editor ./go.ascii
	et=$(date +%s.%N)
	echo "$et - $st" | bc > "./times/${editor}"
done
clear
figlet Congratulations
figlet $username 
echo "Your times were:"
total=0
for editor in $(cat ./editors); do
	t=$(cat "./times/${editor}")
	echo "$editor: $t"
	total=$( echo "$total + $t" | bc)
done
echo "============="
echo "Total Time: $total"
echo $username > ./leaderboard/latest/name 
echo $total > ./leaderboard/latest/time 
sleep 1
comp=$(echo "$total < $time_1st" | bc )
if [  "$comp" -eq "1" ]; then
	figlet Hold my beer, You are first!
	cp ./leaderboard/2nd/* ./leaderboard/3rd/
	cp ./leaderboard/1st/* ./leaderboard/2nd/
	echo $username > ./leaderboard/1st/name 
	echo $total > ./leaderboard/1st/time 
	exit
fi
comp=$(echo "$total < $time_2nd" | bc )
if [ "$comp" -eq "1" ]; then
	figlet Oh dear, You are second!
	cp ./leaderboard/2nd/* ./leaderboard/3rd/
	echo $username > ./leaderboard/2nd/name 
	echo $total > ./leaderboard/2nd/time 
	exit
fi
comp=$(echo "$total < $time_3rd" | bc )
if [ "$comp" -eq "1" ]; then
	figlet Oh wow, You are third!
	echo $username > ./leaderboard/3rd/name 
	echo $total > ./leaderboard/3rd/time 
	exit
fi
