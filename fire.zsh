#!/usr/bin/env zsh

setopt no_nomatch
setopt KSH_ARRAYS

# ---- terminal control ----
print -n "\e[?25l"
trap 'print -n "\e[?25h\e[0m"; exit' INT TERM

resize() {
  W=$COLUMNS
  H=$LINES
}
trap resize SIGWINCH
resize

# ---- fire buffer ----
typeset -a fire
palette=(232 52 88 124 160 196 202 208 214 220 226 227 229 231)

init_fire() {
  fire=()
  for ((i=0; i<W*H; i++)); do
    fire[$i]=0
  done
}
init_fire

while true; do
  print -n "\e[H"

  for ((x=0; x<W; x++)); do
    fire[$(( (H-1)*W + x ))]=$((RANDOM % ${#palette[@]}))
  done

  for ((y=0; y<H-1; y++)); do
    for ((x=0; x<W; x++)); do
      src=$(( (y+1)*W + (x + RANDOM % 3 - 1 + W) % W ))
      decay=$((RANDOM % 2))
      val=${fire[$src]}
      (( val > 0 )) && val=$((val - decay))
      fire[$(( y*W + x ))]=$val
    done
  done

  for ((y=0; y<H; y++)); do
    line=""
    for ((x=0; x<W; x++)); do
      v=${fire[$(( y*W + x ))]}
      color=${palette[$v]}
      line+="%F{$color}█"
    done
    print -P "$line"
  done

  sleep 0.03
done
