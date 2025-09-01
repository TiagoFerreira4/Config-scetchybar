#!/usr/bin/env sh

pct_raw() { pmset -g batt | awk 'NR==2{print $3}' | tr -d ';'; }   # ex: 79%
pct_num() { echo "$(pct_raw)" | tr -d '%' ; }                      # ex: 79 (número)
plugged() { pmset -g batt | grep -q 'AC Power'; }                  # 0/1

bat_icon() {
  p=$(pct_num)
  if plugged; then echo ""; return; fi            # carregando (Nerd Font)
  if   [ "$p" -ge 90 ]; then echo ""
  elif [ "$p" -ge 75 ]; then echo ""
  elif [ "$p" -ge 50 ]; then echo ""
  elif [ "$p" -ge 25 ]; then echo ""
  else                       echo ""
  fi
}

update() {
  sketchybar --set "$NAME" icon="$(bat_icon)" label="$(pct_raw)"
}

case "$SENDER" in
  "routine"|"system_woke"|"power_source_change") update ;;
  *)
    sketchybar --add item battery right \
               --set battery update_freq=60 script="$0" \
               --subscribe battery system_woke power_source_change
    update
    ;;
esac
