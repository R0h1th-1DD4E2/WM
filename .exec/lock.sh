#!/bin/sh

background=$(find ~/Pictures/Wall/ -type f | shuf -n 1)

# Run i3lock with custom settings
i3lock --image "$background" \
  --ringcolor=000000AA --insidecolor=000000AA --linecolor=00000000 --separatorcolor=00000000 \
  --ringvercolor=000000FF --ringwrongcolor=FF0000FF --keyhlcolor=00FF00FF --bshlcolor=FF0000FF \
  --verifcolor=00FF00FF --wrongcolor=FF0000FF --timecolor=00FF00FF --datecolor=00FF00FF --layoutcolor=00FF00FF --blur 5
