#!/bin/bash
#
# Name: teacup.sh
# Auth: Frank Cass
# Date: 20190618
# Desc: This is a thought experiment to help infosec professionals think outside of the box.
# 	Can you come up with 100 ways to remove tea from a cup?
# 	From https://youtu.be/kiHuaVYv5q0

echo "[*] Here are a 100 different ways to remove tea from a cup (Work in progress!): "; echo ""; method=1

OLDIFS="${IFS}"
IFS=$'\n'
message=`cat <<-EOF

Create a chemical that will destroy any non water particles and leaves nothing but pure h2o. Insert the chemical into the tea cup and wait for the process to complete.
Flip the cup by lifting it from underneath until the top rests flatly on the table, allowing the contents to pour out.
Push the cup on its side and then lift it until all of the contents pour out.
Pour another liquid into the cup until it reaches capacity and flows over, flushing the tea out of the cup.
Use a torch or hot plate to boil and evaporate all of the water.
Buy a humidifier and place an intake tube into the base of the cup. Power on the humidifier and wait untill the intake tube is no longer effective due to a lack of remaining suctionable water. Power off the humidifier and wait for evaporation to naturally occur. Wipe out the inner cup remaining tea leaves and particles with a paper towel.
Use a dehumidifier within the room where the cup of tea resides, decreasing the relative humidity and enabling the evaporation process to become more effective.
Use a flexible straw to siphon the tea out.
Take a spoon or ladel and scoop out the tea.
Take a towel or sponge and place it in the tea, allowing it to absorb.
Place the cup in a pressure cooker, allowing the tea to boil and eventually be released through steam / water vapor.
Break the cup with a hammer, allowing the tea to flow out of the cup.
Drink the tea.
Pay someone to remove the tea from the cup.
Use a high powered fan to blow the tea out of the cup, or the cup off of the surface, allowing it to flip over and pour out its contents.
Add polyethylene glycol to the tea, thoroughly mix it and tilt the cup, allowing it to begin self-pouring / siphoning the rest of the contents out.

EOF`

for i in $message
	do
	echo "[$method]: $i";
	method=$((method + 1))
done

