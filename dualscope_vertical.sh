  #!/bin/bash

# a little script i made to open two gamescope sessions of steam
# i SUCK at making bash script, so expect a lot of bugs or issues :<
# made for arch linux in mind
# you need another account on your device to use this

# if u use pipewire and your audio is not working, take a look at this:
# https://wiki.archlinux.org/title/PipeWire#Multi-user_audio_sharing

# The gamescope params for both of the processes
# Here, we split a 4k TV into two tall/skinny displays
GAMESCOPE_PARAMS="-e -b -w 960 -h 1080 -W 1920 -H 2160 -F fsr --fsr-sharpness 10"
# Params for both steams
# - steamos3 option permits killing the DualScope script by "switching to desktop" to fully avoid using a mouse/keyboard; appears to be linked to some bluetooth bugs though
STEAM_PARAMS="-gamepadui -steamos3"

# The primary andsecondary accounts you will use
PlayerOneAcc="$(whoami)"
PlayerTwoAcc="PlayerTwo"

GAMESCOPE_BIN="/usr/bin/gamescope"
RUNUSER_BIN="/usr/bin/runuser"
STEAM_BIN="/usr/bin/steam"

CHANGED_DEVICES=()
CHANGED_JS_DEVICES=()
GAMESCOPE_PRIMARY_PID=""
GAMESCOPE_SECONDARY_PID=""

cleanup() {
  echo -e "\e[31mReturning ownership to every device"
  return_devices_ownership

  if [[ -n "$GAMESCOPE_PRIMARY_PID" ]]; then
    echo -e "\e[31mKilling primary gamescope..."
    kill -TERM "$GAMESCOPE_PRIMARY_PID" 2>/dev/null || true
  fi

  if [[ -n "$GAMESCOPE_SECONDARY_PID" ]]; then
    echo -e "\e[31mKilling secondary gamescope..."
    kill -TERM "$GAMESCOPE_SECONDARY_PID" 2>/dev/null || true
  fi

#   return-to-gamemode
}

change_device_ownership() {
  local profile="$1"
  local device="$2"
  local device_path="/dev/input/event$device"

  chown "$profile" "$device_path"
  chmod 600 "$device_path"
}

return_devices_ownership() {
  local device
  for device in "${CHANGED_DEVICES[@]}"; do
    local device_path="/dev/input/event$device"
    chown root:input "$device_path"
    chmod 660 "$device_path"
  done
}

primary_gamescope() {
  eval "$RUNUSER_BIN -u $PlayerOneAcc -- env DISPLAY=$DISPLAY XDG_RUNTIME_DIR=/run/user/$(id -u $PlayerOneAcc) $GAMESCOPE_BIN $GAMESCOPE_PARAMS -- $STEAM_BIN $STEAM_PARAMS"
  GAMESCOPE_PRIMARY_PID=$!
}

secondary_gamescope() {
  eval "$RUNUSER_BIN -u $PlayerTwoAcc -- env DISPLAY=$DISPLAY XDG_RUNTIME_DIR=/run/user/$(id -u $PlayerTwoAcc) $GAMESCOPE_BIN $GAMESCOPE_PARAMS -- $STEAM_BIN $STEAM_PARAMS"
  GAMESCOPE_SECONDARY_PID=$!
}

trap cleanup EXIT INT TERM

main() {
  echo -e "\e[32mDualScope by NaviVani , edited for Bazzite-Deck by WhopperJr13"

  xhost +si:localuser:$PlayerOneAcc
  xhost +si:localuser:$PlayerTwoAcc
  mkdir -p /tmp/playerone-runtime && chown $PlayerOneAcc:$PlayerOneAcc /tmp/playerone-runtime && chmod 700 /tmp/playerone-runtime
  mkdir -p /tmp/playertwo-runtime && chown $PlayerTwoAcc:$PlayerTwoAcc /tmp/playertwo-runtime && chmod 700 /tmp/playertwo-runtime
  mkdir -p /run/user/1001
  mkdir -p /run/user/1003
  chown $PlayerOneAcc:$PlayerOneAcc /run/user/1003
  chown $PlayerTwoAcc:$PlayerTwoAcc /run/user/1001
  chmod 700 /run/user/1001
  chmod 700 /run/user/1003

  for bin in "$GAMESCOPE_BIN" "$STEAM_BIN" "$RUNUSER_BIN"; do
    if [[ ! -x "$bin" ]]; then
      echo -e "\e[31mThe $bin executable was not found, exiting..."
      exit 1
    fi
  done

# Define partial name targets; works best with two USB/2.4 GHz controllers, bluetooth was being routed to both windows. Use 'evtest' to see the names of the connected controllers
TARGET_1="8BitDo Ultimate 2C"
TARGET_2="8BitDo Ultimate Wireless"

for profile in "$PlayerOneAcc" "$PlayerTwoAcc"; do
    # Determine the target search string for the current profile
    [[ "$profile" == "$PlayerOneAcc" ]] && search_term="$TARGET_1" || search_term="$TARGET_2"
    
    # Scan /sys/class/input/ to find devices containing the search term
    MATCHED_DEVICES=()
    for dev_path in /sys/class/input/event*; do
        if [ -f "$dev_path/device/name" ]; then
            dev_name=$(cat "$dev_path/device/name")
            # Partial case-insensitive match
            if [[ "${dev_name,,}" == *"${search_term,,}"* ]]; then
                # Extract the event number (e.g., 'event3' -> '3')
                dev_id="${dev_path##*event}"
                MATCHED_DEVICES+=("$dev_id")
            fi
        fi
    done

    # Process discovered devices
    if [ ${#MATCHED_DEVICES[@]} -eq 0 ]; then
        echo -e "\e[31mNo devices found for $profile containing: $search_term"
    else
        for device in "${MATCHED_DEVICES[@]}"; do
            change_device_ownership "$profile" "$device"
            CHANGED_DEVICES+=("$device")
        done
    fi
done

# Using xdotool requires elevated permissions. If you want to avoid the pop-up everytime, adjust x11 security permissions: Settings -> Security & Privacy -> Application Permissions -> Legacy X11 App Support -> Control of pointer and keyboard -> Allow without asking for permission
xdotool key Super+Down
sleep 1

  echo -e "\e[32mKilling steam before starting..."
  pkill steam
  pkill firefox
  pkill kate

  while pgrep steam > /dev/null; do
    sleep 1 || break
    echo -e "\e[31mWaiting for steam to get killed..."
  done

  echo -e "\e[32mOpening gamescope sessions!"

  # For whatever reason, both windows only succeed if you call primary with the '&' after, but secondary without (I think because otherwise the script will terminate execution). Therefore, to automatically dock the windows, what I got to work was to trigger the commands before opening the windows with sleep timers. Very janky, please let me know if there is a better way. I was at least able to use xdotool to search for and grab the gamescope windows rather than other windows.
(
    sleep 10
    echo -e "\e[32mMoving primary window!"
    # Search for window belonging to PID, wait for it to exist, then tile left
    xdotool search --onlyvisible --class "gamescope" | head -n 1 | xargs xdotool windowactivate
    xdotool key Super+Left

    sleep 50
    echo -e "\e[32mMoving primary window!"
    # Search for window belonging to PID, wait for it to exist, then tile right
    xdotool search --onlyvisible --class "gamescope" | sed -n '2p' | xargs xdotool windowactivate
    xdotool key Super+Left

    echo -e "\e[32mMoving primary window!"
    # Search for window belonging to PID, wait for it to exist, then tile left
    xdotool search --onlyvisible --class "gamescope" | head -n 1 | xargs xdotool windowactivate
    xdotool key Super+Right

) &

  primary_gamescope &
  secondary_gamescope

}

main "$@"
