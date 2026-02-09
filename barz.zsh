#!/usr/bin/env zsh

setopt no_nomatch

# ---- terminal control ----
print -n "\e[?25l"
trap 'print -n "\e[?25h\e[0m"; exit' INT TERM

# ---- state ----
integer tick=0
integer W H

resize() {
  W=$COLUMNS
  H=$LINES
}
trap resize SIGWINCH
resize

while true; do
  print -n "\e[H"

  for ((row=0; row<H; row++)); do
    line=""
    for ((x=0; x<W; x++)); do
      # simple animated pattern
      v=$(( (x + tick + row*2) % 12 ))
      if (( v < 6 )); then
        color=$((16 + (x + tick) % 216))
        line+="%F{$color}█"
      else
        line+=" "
      fi
    done
    print -P "$line"
  done

  ((tick++))
  sleep 0.04
done
