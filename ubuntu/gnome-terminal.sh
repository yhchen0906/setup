#! /bin/sh
dconf load /org/gnome/terminal/legacy/profiles:/ << EOF
[:$(gsettings get org.gnome.Terminal.ProfilesList default | xargs)]
foreground-color='#F8F8F2'
palette=['#262626', '#E356A7', '#42E66C', '#E4F34A', '#9B6BDF', '#E64747', '#75D7EC', '#EFA554', '#7A7A7A', '#FF79C6', '#50FA7B', '#F1FA8C', '#BD93F9', '#FF5555', '#8BE9FD', '#FFB86C']
use-system-font=false
use-theme-colors=false
use-transparent-background=true
use-theme-transparency=false
scrollback-unlimited=true
bold-color-same-as-fg=false
bold-color='#6E46A4'
background-color='#282A36'
background-transparency-percent=10
scrollbar-policy='never'
EOF
