#!/bin/bash

while true
do
  State=`docker exec -ti shardeum-dashboard  operator-cli status | grep state | awk -F":" '{print $2}'`
  State=`echo "${State}" | sed -e "s/^.//;s/.$//"`

  case "${State}" in
    "standby")
        echo "==> "`date` "Node standby"
        ;;

    "stopped")
        echo "---------------------------------------" 
        echo `date` "Node stopped."
        echo `date` "Start node."
        docker exec -ti shardeum-dashboard operator-cli start
        echo "==>" `date` "Node started."
        echo "----------------------------------------"
        ;;
        
     "null")
        echo "---------------------------------------" 
        echo `date` "Node unknown state."
        docker exec -ti shardeum-dashboard operator-cli stop
        docker exec -ti shardeum-dashboard operator-cli start
        echo "==>" `date` "Node restarted."
        echo "----------------------------------------"
        ;;

    *) echo "INFO: State not corrected."
       echo "${State}";;
  esac

  sleep 60
done
