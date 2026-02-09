#!/usr/bin/env zsh

setopt no_nomatch
setopt KSH_ARRAYS

# ---- terminal setup ----
print -n "\e[?25l"
trap 'print -n "\e[?25h\e[0m"; exit' INT TERM

integer W H
typeset -a drops speeds

resize() {
  W=$COLUMNS
  H=$LINES
  drops=()
  speeds=()
  for ((i=0; i<W; i++)); do
    drops[i]=$((RANDOM % H))
    speeds[i]=$((1 + RANDOM % 3))
  done
}
trap resize SIGWINCH
resize

chars=(ア イ ウ エ オ カ キ ク ケ コ サ シ ス セ ソ タ チ ツ テ ト ナ ニ ヌ ネ ノ)

while true; do
  print -n "\e[H"

  for ((x=0; x<W; x++)); do
    ((drops[x] += speeds[x]))
    if (( drops[x] >= H + RANDOM % 10 )); then
      drops[x]=$((RANDOM % H))
      speeds[x]=$((1 + RANDOM % 3))
    fi
  done

  for ((y=0; y<H; y++)); do
    line=""
    for ((x=0; x<W; x++)); do
      d=${drops[x]}
      if (( y == d )); then
        line+="%F{46}${chars[RANDOM % ${#chars[@]}]}"
      elif (( y == d-1 )); then
        line+="%F{40}${chars[RANDOM % ${#chars[@]}]}"
      elif (( y == d-2 )); then
        line+="%F{34}${chars[RANDOM % ${#chars[@]}]}"
      else
        line+=" "
      fi
    done
    print -P "$line"
  done

  sleep 0.05
done
