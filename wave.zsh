#!/usr/bin/env zsh
zmodload zsh/mathfunc

integer w=$COLUMNS h=20
typeset -A pos
typeset -F t=0

while true; do
  print -n "\e[H\e[J"

  pos=()
  for ((x=0; x<w; x++)); do
    pos[$x]=$(( int(h/2 + (h/2-2)*sin(x*0.18 + t)) ))
  done

  for ((y=0; y<h; y++)); do
    r=""
    for ((x=0; x<w; x++)); do
      if (( pos[$x] == y )); then
        r+="%F{$((16 + (x*3)%216))}█%f"
      else
        r+=" "
      fi
    done
    print -P "$r"
  done

  t+=0.15
  sleep 0.03
done
