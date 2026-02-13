#!/bin/bash

sketchybar --add item volume right \
           --set volume script="$PLUGIN_DIR/volume.sh" \
                        click_script="sketchybar --set volume popup.drawing=toggle" \
                        popup.background.color=$ITEM_BG_COLOR \
                        popup.background.corner_radius=5 \
                        popup.background.border_width=0 \
           --subscribe volume volume_change

# Volume slider popup: minus button, visual bar, plus button
sketchybar --add item volume.down popup.volume \
           --set volume.down \
                 icon="󰝞" \
                 icon.font="Iosevka Nerd Font:Bold:14.0" \
                 icon.color=$ACCENT_COLOR \
                 label.drawing=off \
                 icon.padding_left=8 \
                 icon.padding_right=8 \
                 click_script="$PLUGIN_DIR/volume_adjust.sh down"

sketchybar --add item volume.slider popup.volume \
           --set volume.slider \
                 icon.drawing=off \
                 label="████████░░" \
                 label.font="Iosevka Nerd Font:Regular:11.0" \
                 label.color=$ACCENT_COLOR \
                 label.padding_left=4 \
                 label.padding_right=4

sketchybar --add item volume.up popup.volume \
           --set volume.up \
                 icon="󰝝" \
                 icon.font="Iosevka Nerd Font:Bold:14.0" \
                 icon.color=$ACCENT_COLOR \
                 label.drawing=off \
                 icon.padding_left=8 \
                 icon.padding_right=8 \
                 click_script="$PLUGIN_DIR/volume_adjust.sh up"
