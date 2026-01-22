# Shell Scripts

A collection of helpers and tools I make and use from time to time.

## Suite Usage

- Clone repo
- (_optional_) create symlinks in your desired directory to the repo files you are using, such as `/usr/local/bin`
    - This way you just have to pull (or rebase) the latest and you'll have all the updates, if any.

> **WARNING**
> The `colours` script uses `eval` and is sourced by the other scripts, so if
> you are altering these files, make sure not to let them accept user input!

### `colours.sh` - Colours and Styles

- `source` this file to add quick ANSI style + colour combo variables to your scripts.
- **Bonus:** No need to remember escape codes!
- Individual style "tags" are also available, such as dim, underline, blink, etc...
- Reset your styles with `$RESET`.
- **NOTE:** Colours may vary depending on your terminal emulator & theme settings.
- **Accessibility:** If a background colour is being used, make sure there is a high contrast between the background, and the foreground text.

#### TIP: Colours and Styles Test

```bash
# Style + colour combo tests
sh colours.sh -t

# Same as above, with nested styles test
sh colours.sh -t all

# Test your bell sound
sh colours.sh -b
```

- Running the above command outputs a demo table showing how all of the styles display in your terminal.
- The _Color_ (yes, US spelling. _Oops!_) column can help you remember the main colour variable names.
- The styles can be accessed just by adding the corresponding prefix:
    - `b` (bold — _if available_)
    - `i` (italic — _if available_)
    - `u` (underline)
    - `h` (high-intensity)
    - `bg` (background)
    - `hbg` (high-intensity background)

```bash
# Examples
printf "${bRED}[ERR]${RESET} ${CYAN}Item not found${RESET}\n"
printf "${RED}${BOLD}${BLINK}[ERR]${UNBOLD}${UNBLINK} Item not found${RESET}\n"
```

#### Combo Variables

| **Color**  | Bold        | Italic      | Underline   | Background   | High Intensity | HI-Background |
| :--------- | :---------- | :---------- | :---------- | :----------- | :------------- | :------------ |
| `$BLACK`   | `$bBLACK`   | `$iBLACK`   | `$uBLACK`   | `$bgBLACK`   | `$hBLACK`      | `$hbgBLACK`   |
| `$RED`     | `$bRED`     | `$iRED`     | `$uRED`     | `$bgRED`     | `$hRED`        | `$hbgRED`     |
| `$GREEN`   | `$bGREEN`   | `$iGREEN`   | `$uGREEN`   | `$bgGREEN`   | `$hGREEN`      | `$hbgGREEN`   |
| `$YELLOW`  | `$bYELLOW`  | `$iYELLOW`  | `$uYELLOW`  | `$bgYELLOW`  | `$hYELLOW`     | `$hbgYELLOW`  |
| `$BLUE`    | `$bBLUE`    | `$iBLUE`    | `$uBLUE`    | `$bgBLUE`    | `$hBLUE`       | `$hbgBLUE`    |
| `$MAGENTA` | `$bMAGENTA` | `$iMAGENTA` | `$uMAGENTA` | `$bgMAGENTA` | `$hMAGENTA`    | `$hbgMAGENTA` |
| `$CYAN`    | `$bCYAN`    | `$iCYAN`    | `$uCYAN`    | `$bgCYAN`    | `$hCYAN`       | `$hbgCYAN`    |
| `$WHITE`   | `$bWHITE`   | `$iWHITE`   | `$uWHITE`   | `$bgWHITE`   | `$hWHITE`      | `$hbgWHITE`   |

#### Nestable Style Tags

| **Style**     | Open      | Close\*     |
| :------------ | :-------- | :---------- |
| Bold          | `$BOLD`   | `$UNBOLD`   |
| Dim           | `$DIM`    | `$UNDIM`    |
| Italic        | `$ITALIC` | `$UNITALIC` |
| Underline     | `$ULINE`  | `$UNULINE`  |
| Slow Blink    | `$BLINK`  | `$UNBLINK`  |
| Fast Blink    | `$FBLINK` | `$UNBLINK`  |
| Invert        | `$INVERT` | `$UNINVERT` |
| Hidden        | `$HIDE`   | `$UNHIDE`   |
| Strikethrough | `$STRIKE` | `$UNSTRIKE` |

---

### Logger - `log.sh`

- `source` this to access `log()` for a basic logging function with
    - timestamp
    - 4 levels w/ high-intensity ANSI colours
        - _"info"_ (green, `${hGREEN}`)
        - _"warn"_ (yellow, `${hYELLOW}`)
        - _"error"_ (red, `${hRED}`)
        - _"msg"/CUSTOM_LABEL_ (grey label, `${hBLACK}`)

#### Logger Usage

- Update source path to `colours.sh`, if needed.

```bash
# Example
# `log LOG_LEVEL MESSAGE`
log "warn" "They're on to you..."
log "error" "The system is down."`
log "GOT HERE" "This is a custom message level (`msg`) log"

# Output format: TIMESTAMP LOG_LEVEL MESSAGE
# e.g., [01:42:24] [WARN] They're on to you...
```

#### Arguments

| Parameter   |                          Type                          | Default | Notes                                          |
| :---------- | :----------------------------------------------------: | :------ | :--------------------------------------------- |
| `LOG_LEVEL` | `[(CUSTOM_LABEL), "", "msg", "info", "warn", "error"]` | `"msg"` | `""` is same as the default. Case insensitive. |
| `MESSAGE`   |                        _string_                        | `""`    |                                                |

#### Dependencies

- `colour.sh`
