#!/bin/bash
if [ -n "$COLOURS_LOADED" ]; then
    return
fi
declare -g COLOURS_LOADED=1

##
# `source` this file to add ANSI colour variables to your script.
# Colours may vary depending on your terminal emulator settings.
#
# Usage:
# See $RESET var and $COLORS list for var names, w/ certain prefixes:
#   - b   (bold*)
#   - i   (italic*)
#   - u   (underline)
#   - h   (high-intensity)
#   - bg  (background)
#   - hbg (high-intensity background)
# (*) If supported
#
# Run `sh colours.sh -t` to test the variables with your terminal theme.
#
# Example:
# printf "${RED}[ERR]${RESET} ${hWHITE}Item not found${RESET}\n"
#
# NOTE:
# This script uses `eval` so do not alter it to accept user input!
##

eval "declare -g RESET=$'\e[0m'"
COLORS=("BLACK" "RED" "GREEN" "YELLOW" "BLUE" "MAGENTA" "CYAN" "WHITE")

for i in "${!COLORS[@]}"; do
    NAME="${COLORS[$i]}"
    
    FG=$((i + 30))
    BG=$((i + 40))
    H_FG=$((i + 90))
    H_BG=$((i + 100))

    eval "declare -g ${NAME}=$'\e[0;${FG}m'"        # Regular
    eval "declare -g b${NAME}=$'\e[1m\e[${FG}m'"    # Bold + Color
    eval "declare -g i${NAME}=$'\e[3m\e[${FG}m'"    # Italic + Color
    eval "declare -g u${NAME}=$'\e[4m\e[${FG}m'"    # Underline + Color
    eval "declare -g h${NAME}=$'\e[0;${H_FG}m'"     # High Intensity Text
    eval "declare -g bg${NAME}=$'\e[0;${BG}m'"      # Background
    eval "declare -g hbg${NAME}=$'\e[${H_BG}m'"     # High Intensity Background (The Block)
done

test_colors() {
    printf "\n%-8s %-4s %-4s %-6s %-7s %-8s %-7s %-8s\n" \
           "COLOR" "NORM" "BOLD" "ITALIC" "U-LINE" "BG" "HI-FG" "HI-BG"
    echo "-----------------------------------------------------------"

    for NAME in "${COLORS[@]}"; do
        NORM=${!NAME};
	BOLD="b$NAME"; BOLD=${!BOLD};
	ITAL="i$NAME"; ITAL=${!ITAL}
        UNDR="u$NAME"; UNDR=${!UNDR};
	BGC="bg$NAME"; BGC=${!BGC};
	HFG="h$NAME"; HFG=${!HFG};
	HBGC="hbg$NAME"; HBGC=${!HBGC};

        printf "%-8s " "$NAME"
        printf "${NORM}%-4s${RESET} " "Text"
        printf "${BOLD}%-4s${RESET} " "Bold"
        printf "${ITAL}%-6s${RESET} " "Italic"
        printf "${UNDR}%-6s${RESET} " "UnderLn"
        printf "${BGC}%-8s${RESET} " ".  BG  ."
        printf "${HFG}%-7s${RESET} " "HighInt"
        printf "${HBGC}%-8s${RESET}\n" ".  BG  ."
    done
    printf "\n"
}

if [ "$1" == "-t" ]; then
    test_colors
fi
