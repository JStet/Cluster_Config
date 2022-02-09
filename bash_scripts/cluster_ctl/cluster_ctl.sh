#!/bin/bash
############################################################
# Set variables
me=`basename "$0"`
valid_machines=(raspi1 raspi2 raspi3 raspi4 old-pc)

#######################################
# Help                                                     #
############################################################
help()
{
   # Display Help
   echo
   echo "Syntax: $me [power] [additional arguments]"
   echo
   echo "options:"
   echo
   echo "Turn specified machines on or off with:"
   echo "power [all/'machine1 machine2 ...']  [on/off]"
   echo "Valid machines: [${valid_machines[@]}]. If you choose a selection of machines, use quotation marks."
   echo
   echo "This script requires local domains of the form machine.lan to be set up. It also needs passwordless sudo to be configured"
}

############################################################
############################################################
# Main program                                             #
############################################################
################# Helper Functions #########################
ping_test()
{
  ping -c1 "$1.lan" &>/dev/null #hide output of command
  if [ $? -eq 0 ] #check exit status of command
  then
    ping=0
  else
    ping=1
  fi
}

on_off()
{
  ping_test $1
  if [[ $2 == "off" ]]
  then
    if [ $ping -eq 1 ]
    then
      echo "$1 already powered off"
    else
      echo "Powering $2 $1..."
      ssh user@"$1.lan" -i /home/user/Gits/Cluster_Config/ansible/.ssh/cluster.key 'sudo shutdown now'
    fi
  elif [[ $2 == "on" ]]
  then
    if [ $ping -eq 0 ]
    then
      echo "$1 already powered on"
    else
      echo "Powering $2 $1..."
      ssh user@router.lan -i /home/user/Gits/Cluster_Config/ansible/.ssh/cluster.key "sudo python3 /home/user/power.py $1"
    fi
  fi
}
############################################################
################# Power on off ###################################

power()
{
if [[ $1 =~ "all" ]]
then
  for machine in ${valid_machines[*]}
    do
      on_off $machine $2
  done
else
  for machine in $1
    do
      if [[ ${valid_machines[*]} =~ (^|[[:space:]])"$machine"($|[[:space:]]) ]]; then
        on_off $machine $2
      else
        echo "$machine not a valid machine";
      fi
  done
fi
}

###########################################################
###########################################################

############################################################
# Process the input options.
############################################################
case "$1" in
  p)
    power "$2" $3 #second argument passed to bash script becomes first argument passed to function etc.
    ;;
  *)
    help
    ;;
esac


