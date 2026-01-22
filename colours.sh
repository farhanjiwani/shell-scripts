#!/bin/bash
if [ -n "$COLOURS_LOADED" ]; then
    return
fi
declare -g COLOURS_LOADED=1

##
# `source` this file to add quick ANSI style + colour variables to your scripts,
# such as bold + red in one variable, e.g., $bRED.
#
# Colours may vary depending on your terminal emulator & settings.
# Individual style "tags" are also available for dim, underline, blink, etc...
#
# Usage:
# See style vars and $COLORS list for var names, w/ certain prefixes:
#   - b   (bold*)
#   - i   (italic*)
#   - u   (underline)
#   - h   (high-intensity), also hb(*), hi(*), hu
#   - bg  (background), also hbg
# (*) If supported
#
# Run `sh colours.sh -t` to test the variables with your terminal & theme.
#   - `-t all` will include nested style tests.
#   - `-b` will test the bell (`\a`)
#
# Examples:
# printf "${bRED}[ERR]${RESET} ${CYAN}Item not found${RESET}\n"
# printf "${RED}${BOLD}${BLINK}[ERR]${UNBOLD}${UNBLINK} Item not found${RESET}\n"
#
# **NOTE:**
# This script uses `eval` so do not alter it to accept user input!
#
# ANSI Escape Sequence reference:
# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
##

# Lists of available colours, and prefixes for each style
COLORS=("BLACK" "RED" "GREEN" "YELLOW" "BLUE" "MAGENTA" "CYAN" "WHITE")
STYLE_PREFIXES=("" "b" "i" "u" "h" "hb" "hi" "hu" "bg" "hbg")

# Opening and closing "tags", as well as $RESET
eval "declare -g BOLD=$'\e[1m'";      eval "declare -g UNBOLD=$'\e[22m'"
eval "declare -g DIM=$'\e[2m'";       eval "declare -g UNDIM=$'\e[22m'"
eval "declare -g ITALIC=$'\e[3m'";    eval "declare -g UNITALIC=$'\e[23m'"
eval "declare -g ULINE=$'\e[4m'";     eval "declare -g UNULINE=$'\e[24m'"
eval "declare -g BLINK=$'\e[5m'";     eval "declare -g UNBLINK=$'\e[25m'"
eval "declare -g INVERT=$'\e[7m'";    eval "declare -g UNINVERT=$'\e[27m'"
eval "declare -g HIDE=$'\e[8m'";      eval "declare -g UNHIDE=$'\e[28m'"
eval "declare -g STRIKE=$'\e[9m'";    eval "declare -g UNSTRIKE=$'\e[29m'"
eval "declare -g FBLINK=$'\e[6m'";    eval "declare -g RESET=$'\e[0m'"

# Generate style + colour combo variables
for i in "${!COLORS[@]}"; do
    NAME="${COLORS[$i]}"
    
    FG=$((i + 30))      BG=$((i + 40))
    H_FG=$((i + 90))    H_BG=$((i + 100))

    eval "declare -g ${NAME}=$'\e[${FG}m'"             # Regular
    eval "declare -g b${NAME}=$'\e[1m\e[${FG}m'"       # Bold + Color
    eval "declare -g i${NAME}=$'\e[3m\e[${FG}m'"       # Italic + Color
    eval "declare -g u${NAME}=$'\e[4m\e[${FG}m'"       # Underline + Color
    eval "declare -g h${NAME}=$'\e[${H_FG}m'"          # High Intensity Text
    eval "declare -g hb${NAME}=$'\e[1m\e[${H_FG}m'"    # Bold + HI-Color
    eval "declare -g hi${NAME}=$'\e[3m\e[${H_FG}m'"    # Italic + HI-Color
    eval "declare -g hu${NAME}=$'\e[4m\e[${H_FG}m'"    # Underline + HI-Color
    eval "declare -g bg${NAME}=$'\e[${BG}m'"           # Background
    eval "declare -g hbg${NAME}=$'\e[${H_BG}m'"        # High Intensity BG
done

# Used in ansi_test() to display foreground/background ANSI colours
# $1: Foreground colour escape code prefix (3 or 9)
# $2: Background colour escape code prefix (4 or 10)
# $3: Foreground colour 1's column of escape code (0 - 7)
show_combos() {
    local fgType="$1"
    local bgType="$2"
    local i="$3"
    local j=0

    while [ $j -lt 8 ]; do
        printf "\e[0;${fgType}${i};${bgType}${j}m"
        printf "  ${fgType}${i} %-5s" "${bgType}${j} "
        j=$((j + 1))
    done
}

# Test ANSI colour combinations for your terminal emulator & theme
ansi_test() {
    local i=0
    while [ $i -lt 8 ]; do
        show_combos "3" "4" "$i"
        printf "\e[0m\n"

        show_combos "3" "10" "$i"
        printf "\e[0m\n"

        show_combos "9" "4" "$i"
        printf "\e[0m\n"

        show_combos "9"  "10" "$i"
        printf "\e[0m\n"

        i=$((i + 1));
    done
}

# Test colours.sh variables
test_colors() {
    local PRE NAME S_NAME

    printf $'\n\e[4mPFx '
    printf "${COLORS[*]}"
    printf $'\e[0m\n'

    for PRE in "${STYLE_PREFIXES[@]}"; do
        printf "%3s " $PRE

        for NAME in "${COLORS[@]}"; do
            S_NAME=${PRE}${NAME}
            printf "${!S_NAME}%-${#NAME}s${RESET} " "$NAME"
        done
        printf "\n"
    done

    printf "\n"
    ansi_test
}

if [ "$1" == "-t" ]; then
    test_colors
    printf "\n"
fi

if [ "$2" == "all" ]; then
    printf $'\e[4mSetting + Unsetting Styles Test\e[0m\n'
    printf "%-25s" "${BOLD}Bold${UNBOLD} NOT "
    printf "%-25s" "${ITALIC}Ital${UNITALIC} NOT "
    printf "%-25s" "${BLINK}Blink${UNBLINK} NOT "
    printf "%-25s\n" "${INVERT}Invert${UNINVERT} NOT "

    printf "%-25s" "${DIM}DIM${UNDIM} NOT "
    printf "%-25s" "${ULINE}U-Line${UNULINE} NOT "
    printf "%-25s" "${FBLINK}FBlink${UNBLINK} NOT "
    printf "%-25s\n" "${STRIKE}Strike${UNSTRIKE} NOT "

    printf "%-25s\n" "${HIDE}Hidden${UNHIDE} NOT (hidden) "


    printf $'\n\e[4mColour Nesting Test\e[0m\n'
    printf "${MAGENTA}${bgYELLOW} MAGENTA on bgYELLOW ${RESET} "
    printf "${YELLOW}${bgMAGENTA} YELLOW on bgMAGENTA "
    printf "${INVERT} INVERT ${RESET}\n"
    printf "${hMAGENTA}${hbgYELLOW} hMAGENTA on hbgYELLOW ${RESET} "
    printf "${hYELLOW}${hbgMAGENTA} hYELLOW on hbgMAGENTA "
    printf "${INVERT} INVERT ${RESET}\n\n"


    printf $'\e[4mStyle Nesting Test\e[0m\n'
    printf "Normal+${ITALIC}Italic+${ULINE}Underline+${BLINK}Blink+${INVERT}Invert+${STRIKE}Strikethrough+${HIDE}Hidden${UNHIDE}(unhidden)${RESET}\n"
    printf "${BOLD}Bold+${ITALIC}Italic+${ULINE}Underline+${FBLINK}Fast-Blink+${INVERT}Invert+${STRIKE}Strikethrough+${HIDE}Hidden${UNHIDE}(unhidden)${RESET}\n"
    printf "${DIM}Dim+${ITALIC}Italic+${ULINE}Underline+${BLINK}Blink(❌)+${INVERT}Invert+${STRIKE}Strikethrough+${HIDE}Hidden${UNHIDE}(unhidden)${RESET}\n\n"
fi

if [ "$1" == "-b" ]; then
    printf "\a [Did you hear the bell?]\n\n"
fi
