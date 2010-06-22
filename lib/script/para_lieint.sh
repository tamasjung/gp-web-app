#!/usr/bin/env bash


SEQUENCES=

function create_seq(){
  SEQUENCES=$SEQUENCES" $1 $2 $3"
}


LIEINT_ARGS=""
while [ $# -gt 0 ]
do 
  arg=$1
  case $arg in
    -seq)
      echo "sequence"
      create_seq $2 $3 $4
      shift 3
      ;;
  
    *)
      LIEINT_ARGS=$LIEINT_ARGS" $1"
      ;;
  esac
  shift
done

echo $LIEINT_ARGS


