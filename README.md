# 🎮 Sudoku — x86 Assembly (DOS Real Mode)

A fully playable **Sudoku game** written entirely in **x86 16-bit Assembly language**, running in DOS real mode. Features a dual-page scrollable grid, blinking cursor navigation, big number rendering using box-drawing characters, sound effects, a live timer, notes mode, difficulty selection, theme switching, and an animated ASCII art game-over screen — all built with raw hardware-level programming.

---

## 🖥️ Preview

### Welcome / Difficulty Selection Screen
```
                  Welcome to Sudoku!
       "A game designed to sharpen your Intelligence!!"

                   Difficulty Levels
                   -----------------
        Beginner        Intermediate        Expert

           Theme:Cyan Background   Theme:White Background
```

### Game Screen (Page 0 — Rows 1–5)
```
Timer: 00:00                              Notes:
                                          -----
1 ┌───┬───┬───╥───┬───┬───╥───┬───┬───┐  ┌─┐ ┌─┐ ┌─┐
  │   │   │   ║   │   │   ║   │   │   │  └─┘ └─┘ └─┘
  ├───┼───┼───╫───┼───┼───╫───┼───┼───┤  ┌─┐ ┌─┐ ┌─┐
2 │   │   │   ║   │   │   ║   │   │   │  └─┘ └─┘ └─┘
  ├───┼───┼───╫───┼───┼───╫───┼───┼───┤  ┌─┐ ┌─┐ ┌─┐
3 │   │   │   ║   │   │   ║   │   │   │  └─┘ └─┘ └─┘
  ╠───┼───┼───╬───┼───┼───╬───┼───┼───╡
4 │   │   │   ║   │   │   ║   │   │   │  Press (u) for
  ├───┼───┼───╫───┼───┼───╫───┼───┼───┤  undo
5 │   │   │   ║   │   │   ║   │   │   │  Press (e) for
  └───┴───┴───╨───┴───┴───╨───┴───┴───┘  erase
                                          Press (n) to
  Beginner   Mistakes: 0/3   Score: 000   enable notes &
                                          (m) to disable
```

### Game Screen (Page 1 — Rows 6–9, scrolled into view)
```
Timer: 00:23                              Notes:
                                          -----
6 ┌───┬───┬───╥───┬───┬───╥───┬───┬───┐  ┌─┐ ┌─┐ ┌─┐
  ├───┼───┼───╫───┼───┼───╫───┼───┼───┤  └─┘ └─┘ └─┘
7 │   │   │   ║   │   │   ║   │   │   │  ...
  ╠───┼───┼───╬───┼───┼───╬───┼───┼───╡
8 │   │   │   ║   │   │   ║   │   │   │
  ├───┼───┼───╫───┼───┼───╫───┼───┼───┤
9 │   │   │   ║   │   │   ║   │   │   │
  └───┴───┴───╨───┴───┴───╨───┴───┴───┘
```

### Big Number Rendering (each digit drawn as 3×3 box-art)
```
  │     ┌─┐   ┌─┐   ┌─┐   │┐   ┌─    ┌─   ─┐   ┌─┐   ┌─┐
  │     └─┐   ─┤    ─┤   └─┘  ┌─┘   ├─    │    ├─┤   └─┤
  │     └─┘   ─┘    ┘          ┘   └─    │    └─┘   ──┘
  1      2     3     4     5     6    7    8      9
```

---

## ⚙️ Features

- [x] Full 9×9 Sudoku grid split across **2 video pages** (rows 1–5 on page 0, rows 6–9 on page 1)
- [x] **Blinking cursor** navigation with arrow keys across both pages
- [x] Numbers rendered as **big 3×3 box-drawing characters** (not plain digits)
- [x] **Live timer** using hardware interrupt (IRQ 0 / INT 8) — updates every second
- [x] **Sound effects** via PC speaker (correct move, wrong move, game start)
- [x] **Mistake counter** (max 3 mistakes shown as `Mistakes: X/3`)
- [x] **Score tracking** — increments on every correct placement
- [x] **Notes mode** — enable with `n`, disable with `m` — write small candidate numbers inside cells
- [x] **Difficulty selection** — Beginner, Intermediate, Expert
- [x] **Theme switching** — Cyan background or White background
- [x] **Scrolling** — seamless page switch when cursor moves between row 5 and row 6
- [x] **3 hardcoded puzzle solutions** (`finalGrid_1`, `finalGrid_2`, `finalGrid_3`)
- [x] **Animated ASCII art** ending screen

---

## 🧠 Assembly Concepts — Core Focus of This Project

This project demonstrates **low-level systems programming** in x86 real mode. Every feature is implemented at the hardware level.

---

### 1. 🔷 Video Memory Direct Access (`0xB800`)

All rendering bypasses BIOS and writes **directly to video RAM**:

```asm
mov ax, 0xb800
mov es, ax        ; ES now points to video memory base
mov di, 524       ; offset = (row * 160) + (col * 2)
mov al, 0x31      ; ASCII character '1'
mov ah, 0x30      ; attribute: black text on cyan background
mov word [es:di], ax  ; write char + attribute in one word
```

Every character on screen is **2 bytes**: low byte = ASCII, high byte = color attribute.

---

### 2. 🔷 Dual Video Pages

The 9-row grid is too tall for one screen, so it uses **two video pages**:

| Page | Rows | Memory Range |
|---|---|---|
| Page 0 | Rows 1–5 | `0x0000` – `0x0F9F` |
| Page 1 | Rows 6–9 | `0x1000` – `0x1F9F` |

Page switching via BIOS:
```asm
mov ah, 0x05   ; BIOS set active page
mov al, 0x01   ; Select Page 1
int 0x10
```

All Page 1 addresses are offset by `0x1000` in code.

---

### 3. 🔷 Hardware Timer Interrupt (IRQ 0 / INT 8)

The live game timer is driven by **hijacking the system timer interrupt**:

```asm
; Hook INT 8 (IRQ 0 — fires ~18.2 times/second)
xor ax, ax
mov es, ax
cli
mov word [es:8*4], stimer   ; store new ISR offset
mov [es:8*4+2], cs          ; store segment
sti
```

The ISR `stimer` increments a tick counter, and every 18 ticks = 1 second:
```asm
stimer:
    inc word [cs:tickcount]
    mov ax, [cs:tickcount]
    cmp ax, 18
    jb skipSecond
    mov word [cs:tickcount], 0
    inc word [cs:seconds]
    ...
    call printtime
    mov al, 0x20
    out 0x20, al   ; send EOI to PIC
    iret
```

---

### 4. 🔷 PC Speaker Sound via Port I/O

Sound is produced by directly programming the **8253 timer chip** and toggling port `0x61`:

```asm
; Set Timer 2 to square wave at given frequency
mov al, 0xB6
out 0x43, al        ; Timer control port
out 0x42, al        ; Low byte of divisor
mov al, ah
out 0x42, al        ; High byte of divisor

; Enable speaker
in al, 0x61
or al, 3            ; Set bits 0-1
out 0x61, al

; Delay loop
; ...

; Disable speaker
in al, 0x61
and al, 0xFC
out 0x61, al
```

Three frequencies defined:
```asm
CORRECT_MOVE_FREQ  equ 1193180 / 700
WRONG_MOVE_FREQ    equ 1193180 / 262
GAME_START_FREQ    equ 1193180 / 250
```

---

### 5. 🔷 Stack-Based Subroutines with `BP`

All subroutines follow the **standard x86 calling convention** using `BP` as the frame pointer:

```asm
; Caller pushes parameters
push ax     ; attribute
push ax     ; x position
push ax     ; y position
call page1_Upper5

; Inside subroutine
push bp
mov bp, sp
mov ah, [bp+4]   ; access first parameter
mov al, [bp+6]   ; access second parameter
...
pop bp
ret 6            ; clean stack (3 word parameters = 6 bytes)
```

Parameters are accessed via positive offsets from `BP`.

---

### 6. 🔷 Big Number Rendering with Box-Drawing Characters

Each digit is drawn as a **3×3 pixel art** using IBM CP437 box-drawing characters:

```
Number "2":        Number "8":
┌──┐               ┌──┐
  ─┘               ├──┤
└──                └──┘
```

Each number subroutine (`one`, `two`, ... `nine`) manually writes 9 characters to video memory using offsets of ±2 (horizontal) and ±160 (vertical, one row = 160 bytes).

Example for number `8`:
```asm
sub di, 162       ; top-left of 3x3 box
mov al, 0xDA      ; ┌ top-left corner
mov word [es:di], ax
...
mov al, 0xC3      ; ├ left T-junction (middle row)
...
mov al, 0xD9      ; ┘ bottom-right corner
```

---

### 7. 🔷 Grid State Tracking (`realTimeGrid`)

A flat array of 81 bytes tracks the current state of the board:

```asm
realTimeGrid: times 81*8 db 0
```

On every valid number entry, the position index is computed:
```asm
mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl              ; (row-1) * 9
sub al, 1
add al, byte [gridColumn]   ; + (col-1)
```

Then validated against the solution array (`finalGrid_1`) and written to `realTimeGrid`.

---

### 8. 🔷 Blinking Cursor via Attribute Bit 7

The cursor is implemented using the **blink bit** (bit 7) of the video attribute byte — no BIOS cursor used:

```asm
; Enable blinking
or ah, 10000000b
mov word [es:di], ax

; Disable blinking
and ah, 01111111b
mov word [es:di], ax
```

Empty cells show a blinking `-` character; occupied cells blink their number.

---

### 9. 🔷 Interrupt-Driven Keyboard Input

All key input uses **BIOS INT 16h**:

```asm
mov ax, 0
int 0x16        ; AH = scan code, AL = ASCII code

cmp ah, 0x48    ; Up Arrow scan code
jz up
cmp ah, 0x50    ; Down Arrow scan code
jz down
cmp al, 0x31    ; ASCII '1'
jz oneCheck
```

---

### Summary Table

| Concept | Implementation | Purpose |
|---|---|---|
| Direct Video Memory | `ES:0xB800` writes | All rendering |
| Dual Video Pages | `INT 10h`, `0x1000` offset | 9-row grid display |
| Hardware Interrupt | INT 8 hook (IRQ 0) | Live game timer |
| Port I/O | Ports `0x43`, `0x42`, `0x61` | PC speaker sound |
| Stack Frame (`BP`) | Push/pop conventions | All subroutine calls |
| Box-Drawing Chars | CP437 characters | Big number rendering |
| Blink Bit | Attribute byte bit 7 | Cursor effect |
| Flat Array Indexing | `(row-1)*9 + (col-1)` | Board state tracking |
| BIOS Keyboard | `INT 16h` | All key input |

---

## 🏗️ Code Structure

```
Sudoku.asm
│
├── Data Segment
│   ├── Timer variables (tickcount, seconds, minutes)
│   ├── UI strings (l1–l11, i1, wm, nm1–nm5)
│   ├── Grid positions array
│   ├── finalGrid_1/2/3 (solution arrays, 81 bytes each)
│   ├── realTimeGrid (current board state, 81 bytes)
│   ├── notesPositions (300 notes * 8 bytes)
│   └── Sound/theme/difficulty variables
│
├── Subroutines
│   ├── clrscr          → Clear screen with attribute
│   ├── printstring     → Welcome/display screen renderer
│   ├── cursordmovement → Difficulty & theme selection cursor
│   ├── page1_Upper5    → Draw rows 1–5 (Page 0)
│   ├── page2_Lower4    → Draw rows 6–9 (Page 1)
│   ├── stimer          → Timer ISR (INT 8 hook)
│   ├── printtime       → Render MM:SS to screen
│   ├── soundeffect     → Route sound by type
│   ├── Sound_Frequency → PC speaker driver
│   ├── upArrow / downArrow / leftArrow / rightArrow  → Cursor movement
│   ├── one – nine      → Validate + render big numbers
│   ├── updateMistakes  → Update mistake counter on screen
│   ├── updateScore     → Update score display
│   ├── EnableNotes     → Notes mode input loop
│   ├── upArrowNotes – rightArrowNotes → Notes cursor movement
│   ├── oneNotesPrint   → Place note digit in cell
│   └── printart        → Animated ASCII art ending
│
└── start (entry point)
    ├── Display welcome screen
    ├── Difficulty/theme selection
    ├── Clear and draw both pages
    ├── Hook INT 8 for timer
    └── Main game loop (cursor movement + number input)
```

---

## ⚙️ How to Build & Run

### Requirements
- **NASM** assembler
- **DOSBox** emulator (runs DOS programs on modern OS)

### Step 1 — Install Tools

**NASM:** https://www.nasm.us/pub/nasm/releasebuilds/

**DOSBox:** https://www.dosbox.com/download.php?main=1

### Step 2 — Assemble

```bash
nasm -f bin Sudoku.asm -o Sudoku.com
```

### Step 3 — Run in DOSBox

1. Open DOSBox
2. Mount your folder:
```
mount c C:\path\to\your\folder
c:
```
3. Run:
```
Sudoku.com
```

---

## 🕹️ Controls

| Key | Action |
|---|---|
| `↑ ↓ ← →` | Move cursor |
| `1` – `9` | Place number in selected cell |
| `n` | Enable notes mode |
| `m` | Disable notes mode |
| `u` | Undo last move *(partial)* |
| `e` | Erase cell |

### Difficulty Selection (Welcome Screen)
| Key | Action |
|---|---|
| `←` `→` | Move between options |
| `Enter` | Confirm selection |
| `Space` | Skip to game |

---

## 📁 Repository Structure

```
sudoku-x86-assembly/
│
├── Sudoku.asm        ← Full source code
├── Sudoku.com        ← Compiled binary (optional)
└── README.md         ← This file
```

---

## ⚠️ Known Limitations

- Only `finalGrid_1` is actively used — `finalGrid_2` and `finalGrid_3` are defined but not yet wired to difficulty levels
- Notes mode (2–9) printing subroutines are defined but not fully implemented
- Undo (`u`) and erase (`e`) are wired in the input loop but not fully connected
- Runs in **16-bit real mode only** — requires DOSBox or actual DOS hardware

---

## 👨‍💻 Built With

- **Language:** x86 16-bit Assembly (NASM syntax)
- **Assembler:** NASM
- **Environment:** DOS Real Mode
- **Emulator:** DOSBox
- **Display:** Direct VGA text mode memory (`0xB800`)
- **Sound:** 8253 PIT chip via port I/O

---

## 📄 License

This project is open source and free to use for educational purposes.
