#!/usr/bin/env zsh
setopt no_nomatch
setopt KSH_ARRAYS

COUNT=${1:-0}
SPEED=${2:-2}
SPREAD=${3:-40}
WARP=${4:-0}
TRAIL=${5:-0}

print -n "\e[?25l"
trap 'print -n "\e[?25h\e[0m"; exit' INT TERM

resize() {
  W=$COLUMNS
  H=$LINES
  CX=$((W/2))
  CY=$((H/2))
  (( COUNT == 0 )) && COUNT=$((W*H/25))
}
trap resize SIGWINCH
resize

typeset -a x y z px py

for ((i=0; i<COUNT; i++)); do
  x[$i]=$((RANDOM%200 - 100))
  y[$i]=$((RANDOM%200 - 100))
  z[$i]=$((RANDOM%200 + 50))
  px[$i]=0
  py[$i]=0
done

while true; do
  print -n "\e[H\e[2J"

  for ((i=0; i<COUNT; i++)); do
    px[$i]=$((CX + x[$i]*SPREAD/z[$i]))
    py[$i]=$((CY + y[$i]*SPREAD/z[$i]))

    z[$i]=$((z[$i]-SPEED-(WARP?RANDOM%2:0)))

    if (( z[$i] <= 1 )); then
      x[$i]=$((RANDOM%200 - 100))
      y[$i]=$((RANDOM%200 - 100))
      z[$i]=$((RANDOM%200 + 100))
      continue
    fi

    sx=$((CX + x[$i]*SPREAD/z[$i]))
    sy=$((CY + y[$i]*SPREAD/z[$i]))

    if (( sx>0 && sx<=W && sy>0 && sy<=H )); then
      c=$((232 + (200 - z[$i]) / 6))
      ch="·"
      (( z[$i] < 60 )) && ch="*"
      (( z[$i] < 30 )) && ch="✦"

      if (( TRAIL && px[$i]>0 && py[$i]>0 )); then
        print -Pn "\e[${py[$i]};${px[$i]}H%F{$c}·"
      fi

      print -Pn "\e[${sy};${sx}H%F{$c}$ch"
    fi
  done

  sleep 0.03
done
