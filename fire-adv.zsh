#!/usr/bin/env zsh
setopt no_nomatch
setopt KSH_ARRAYS

PALETTE_NAME=${1:-fire}
WIND=${2:-0}
SPARKS=${3:-2}

case "$PALETTE_NAME" in
  fire)   palette=(232 52 88 124 160 196 202 208 214 220 226 227 229 231) ;;
  blue)   palette=(232 17 18 19 20 21 27 33 39 45 51 87 123 159) ;;
  green)  palette=(232 22 28 34 40 46 82 118 154 190 226 227 229 231) ;;
  purple) palette=(232 53 54 55 56 57 93 129 165 201 207 213 219 225) ;;
  *) exit 1 ;;
esac

MAXVAL=$(( ${#palette[@]} - 1 ))

print -n "\e[?25l"
trap 'print -n "\e[?25h\e[0m"; exit' INT TERM

resize() { W=$COLUMNS; H=$LINES; }
trap resize SIGWINCH
resize

typeset -a fire smoke
for ((i=0; i<W*H; i++)); do fire[$i]=0; smoke[$i]=0; done

while true; do
  print -n "\e[H"

  for ((x=0; x<W; x++)); do
    fire[$(( (H-1)*W + x ))]=$((RANDOM % (MAXVAL+1)))
  done

  for ((i=0; i<SPARKS; i++)); do
    sx=$((RANDOM % W))
    sy=$((H - 2 - RANDOM % 4))
    fire[$(( sy*W + sx ))]=$MAXVAL
  done

  for ((y=0; y<H-1; y++)); do
    for ((x=0; x<W; x++)); do
      src_x=$(( (x + WIND + RANDOM % 3 - 1 + W) % W ))
      src=$(( (y+1)*W + src_x ))
      val=${fire[$src]}
      (( val > 0 )) && val=$((val - RANDOM % 2))
      fire[$(( y*W + x ))]=$val
      if (( val < 2 && RANDOM % 12 == 0 )); then
        smoke[$(( y*W + x ))]=3
      fi
    done
  done

  for ((i=0; i<W*H; i++)); do
    (( smoke[$i] > 0 )) && smoke[$i]=$((smoke[$i]-1))
  done

  for ((y=0; y<H; y++)); do
    line=""
    for ((x=0; x<W; x++)); do
      idx=$(( y*W + x ))
      if (( smoke[$idx] > 0 )); then
        line+="%F{245}░"
      else
        v=${fire[$idx]}
        line+="%F{${palette[$v]}}█"
      fi
    done
    print -P "$line"
  done

  sleep 0.03
done
