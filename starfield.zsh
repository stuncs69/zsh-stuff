#!/usr/bin/env zsh
setopt no_nomatch
setopt KSH_ARRAYS

print -n "\e[?25l"
trap 'print -n "\e[?25h\e[0m"; exit' INT TERM

resize() { W=$COLUMNS; H=$LINES; }
trap resize SIGWINCH
resize

N=$((W*H/20))
typeset -a x y z

for ((i=0; i<N; i++)); do
  x[$i]=$((RANDOM%W - W/2))
  y[$i]=$((RANDOM%H - H/2))
  z[$i]=$((RANDOM%100 + 1))
done

while true; do
  print -n "\e[H"

  for ((r=0; r<H; r++)); do print ""; done

  for ((i=0; i<N; i++)); do
    z[$i]=$((z[$i]-1))
    if (( z[$i] <= 0 )); then
      x[$i]=$((RANDOM%W - W/2))
      y[$i]=$((RANDOM%H - H/2))
      z[$i]=100
    fi

    sx=$(( W/2 + x[$i]*50/z[$i] ))
    sy=$(( H/2 + y[$i]*50/z[$i] ))

    if (( sx>0 && sx<=W && sy>0 && sy<=H )); then
      c=$((232 + (100 - z[$i]) / 7))
      print -Pn "\e[${sy};${sx}H%F{$c}*"
    fi
  done

  sleep 0.03
done
