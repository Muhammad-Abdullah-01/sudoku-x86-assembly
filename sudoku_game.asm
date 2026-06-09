; this is a comment. Comment starts with semicolon
; 23L-0770(Muhammad Abdullah)
; End Semester Project-Grid Printing

; -------------------------------------------------------------------------

[org 0x0100] ;This is the starting offset of our code/program
jmp start

tickcount:    dw   0
seconds:      dw   0
minutes:      dw   0                  ;variable to store minutes
numprint: db 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39
i1: db 'Notes:'
l1: db 'Timer: 00:00',0
l2: db 'Beginner'
l3: db 'Mistakes: 0/3'
l4: db 'Score: 000'
l5: db 'Press (u) for'
l6: db 'undo'
l7: db 'Press (e) for'
l8: db 'erase'
l9: db 'Press (n) to'
l10: db 'enable notes &'
l11: db '(m) to disable'
countforNumbers: db 2, 4, 5, 4, 5, 6, 5, 5, 3
; seconds: db 0 ; Seconds (0-59)
; minutes: db 0 ; Minutes (0-59)
; tickcount dw 0 ; Tick count for interrupt
position: dw 524,532,540,1164,1172,1180,1804,1812,1820 ; Will take the position where we want to print a number in the grid
currentPage: db 0h
gridRow: db 1 ; 1 to 9
gridColumn: db 1 ; 1 to 9
textAttribute: db 0x30
notesStatus: db 0 ; 0 means notes are off and 1 means notes are on  
notesPositions: times 300*8 db 0 ; Option to save up to 300 notes
notesRow: db 2 ; 1 to 3
notesColumn: db 2 ; 1 to 3
realTimeGrid: times 81*8 db 0 ; An array of 81 0`s where the actual status of our whole grid will be saved
finalGrid_1: db 9,1,3,6,7,2,4,8,5,4,2,7,5,8,1,3,9,6,5,6,8,9,4,3,7,1,2,7,5,9,1,6,8,2,3,4,2,4,1,7,3,5,9,6,8,3,8,6,2,9,4,1,5,7,8,3,2,4,1,6,5,7,9,1,9,4,8,5,7,6,2,3,6,7,5,3,2,9,8,4,1
finalGrid_2: db 1,2,3,8,5,6,4,7,9,4,5,6,9,7,1,8,2,3,7,8,9,3,4,2,1,6,5,6,7,1,4,2,3,5,9,8,3,9,5,6,8,7,2,1,4,2,4,8,1,9,5,6,3,7,8,6,2,7,3,4,9,5,1,9,1,7,5,6,8,3,4,2,5,3,4,2,1,9,7,8,6
finalGrid_3: db 4,8,7,6,9,5,2,3,1,9,3,1,2,7,8,5,6,4,5,2,6,1,4,3,7,8,9,7,5,4,9,1,6,8,2,3,3,1,8,4,5,2,6,9,7,6,9,2,3,8,7,1,4,5,8,7,9,5,2,4,3,1,6,2,4,3,7,6,1,9,5,8,1,6,5,8,3,9,4,7,2
mistakes: db 0
Difficultylevel: db 1
scorecount: db 0
cursorAttribute: db 0XB4
cursorcol: db 3
cursorcol2: db 2
wm: db 'Welcome to Sudoku!'
nm1: db '"A game designed to sharpen your Intelligence!!"'
nm2: db 'Difficulty Levels'
nm3: db 'Beginner'
nm4: db 'Intermediate'
nm5: db 'Expert'
t1: db 'Theme:Cyan Background'
t2: db 'Theme:White Background'

; ASCII Art Message (multiple lines)
art_message:
    db '                  /$$$$$$   /$$$$$$  /$$      /$$ /$$$$$$$$                     '
    db '                 /$$__  $$ /$$__  $$| $$$    /$$$| $$_____/                     '
    db '                | $$  \__/| $$  \ $$| $$$$  /$$$$| $$                           '
    db '                | $$ /$$$$| $$$$$$$$| $$ $$/$$ $$| $$$$$                        '
    db '                | $$|_  $$| $$__  $$| $$  $$$| $$| $$__/                        '
    db '                | $$  \ $$| $$  | $$| $$\  $ | $$| $$                           '
    db '                |  $$$$$$/| $$  | $$| $$ \/  | $$| $$$$$$$$                     '
    db '                 \______/ |__/  |__/|__/     |__/|________/                     '
    db '                                                                                '
    db '            /$$$$$$  /$$    /$$ /$$$$$$$$ /$$$$$$$        /$$ /$$               '
    db '           /$$__  $$| $$   | $$| $$_____/| $$__  $$      | $$| $$               '
    db '          | $$  \ $$| $$   | $$| $$      | $$  \ $$      | $$| $$               '
    db '          | $$  | $$|  $$ / $$/| $$$$$   | $$$$$$$/      | $$| $$               '
    db '          | $$  | $$ \  $$ $$/ | $$__/   | $$__  $$      |__/|__/               '
    db '          | $$  | $$  \  $$$/  | $$      | $$  \ $$                             '
    db '          |  $$$$$$/   \  $/   | $$$$$$$$| $$  | $$       /$$ /$$               '
    db '           \______/     \_/    |________/|__/  |__/      |__/|__/               '
    db '                                                                                '
    db ' /$$     /$$ /$$$$$$  /$$   /$$      /$$      /$$  /$$$$$$  /$$   /$$    /$$ /$$'
    db '|  $$   /$$//$$__  $$| $$  | $$     | $$  /$ | $$ /$$__  $$| $$$ | $$   | $$| $$'
    db ' \  $$ /$$/| $$  \ $$| $$  | $$     | $$ /$$$| $$| $$  \ $$| $$$$| $$   | $$| $$'
    db '   \  $$/  | $$  | $$| $$  | $$     | $$$$_  $$$$| $$  | $$| $$  $$$$   |__/|__/'
    db '    | $$   | $$  | $$| $$  | $$     | $$$/ \  $$$| $$  | $$| $$\  $$$           '
    db '    | $$   |  $$$$$$/|  $$$$$$/     | $$/   \  $$|  $$$$$$/| $$ \  $$    /$$ /$$'
    db '    |__/    \______/  \______/      |__/     \__/ \______/ |__/  \__/   |__/|__/'

; Total number of lines
art_lines: dw 35

line11:db ' ###### ##### ### ### ####### ###### ### ### ####### ###### ',0
line12:db' ## ## ## #### #### ## ## ## ## ## ## ## ##',0
line13:db' ## ### ####### ## ## ## ## ##### ## ## ## ## ##### ###### ',0
line14:db' ## ## ## ## ## ### ## ## ## ## ## ## ## ## ##',0
line15:db' ###### ## ## ## ## ####### ###### ##### ####### ## ##',0



line6: db '$$ $$ $$$$$$$$$$ $$$$$$$ $$$$$$$$$$ $$$$$$$ $$$$$$$ $$ $$ ',0
line7: db ' $$ $$ $$ $$ $$ $$ $$ $$ $$ $$ $$ ',0
line8: db ' $$ $$ $$ $$ $$ $$ $$ $$$$$$$ $$ $$ ',0
line9: db ' $$$ $$ $$ $$ $$ $$ $$ $$ $$ ',0
line10: db' $ $$$$$$$$$$ $$$$$$$ $$ $$$$$$$$ $$ $$ $ ',0



sound: db 's' ; Example sound input ('c' for correct, 'w', 's'
CORRECT_MOVE_FREQ equ 1193180 / 700 ; Frequency for correct move sound
WRONG_MOVE_FREQ equ 1193180 / 262 ; Frequency for wrong move sound
GAME_START_FREQ equ 1193180 / 250 ; Frequency for game start sound
     
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------

;timer

printtime:    push bp 
              mov  bp, sp 
              push es 
              push ax 
              push bx 
              push cx 
              push dx 
              push di 
 
              mov  ax, 0xb800 
              mov  es, ax            
 
              ; Print minutes (2 digits)
              mov  ax, [cs:minutes]
              mov  bx, 10             
              mov  cx, 2              ; ensure 2 digits 
              mov  di, 140            ; point di to 70th column 
 
minuteloop:   mov  dx, 0 
              div  bx 
              add  dl, 0x30           ; convert to ASCII 
              push dx 
              dec  cx 
              cmp  cx, 0 
              jnz  minuteloop 
 
              mov  cx, 2              ; restore counter 
minutepos:    pop  dx 
              mov  dh, 0x07           
              mov  [es:di], dx 
              add  di, 2 
              loop minutepos 
 
              ; Print colon
              mov  word [es:di], 0x073A ; print colon 
              add  di, 2 
 
              ; Print seconds (2 digits)
              mov  ax, [cs:seconds]
              mov  bx, 10          
              mov  cx, 2              ; ensure 2 digits 
 
secondloop:   mov  dx, 0 
              div  bx 
              add  dl, 0x30           ; convert to ASCII 
              push dx 
              dec  cx 
              cmp  cx, 0 
              jnz  secondloop 
 
              mov  cx, 2              ; restore counter 
secondpos:    pop  dx 
              mov  dh, 0x07           ; normal attribute 
              mov  [es:di], dx 
              add  di, 2 
              loop secondpos 
 
              pop  di 
              pop  dx 
              pop  cx 
              pop  bx 
              pop  ax 
              pop  es 
              pop  bp 
              ret 
 
; stimer interrupt service routine 
stimer:        push ax 
 
              inc  word [cs:tickcount] ; increment tick count
              mov  ax, [cs:tickcount]
              cmp  ax, 18             ; check if 1 second has passed 
              jb   skipSecond         
              
              mov  word [cs:tickcount], 0  ; reset tick count
              inc  word [cs:seconds]  ; increment seconds
              
              ; Check if seconds reached 60
              mov  ax, [cs:seconds]
              cmp  ax, 60
              jb   updateTime
              
              ; Reset seconds and increment minutes
              mov  word [cs:seconds], 0
              inc  word [cs:minutes]
 
updateTime:   call printtime
              
skipSecond:   mov  al, 0x20 
              out  0x20, al           ; end of interrupt 
 
              pop  ax 
              iret                    ; return from interrupt 

;Subroutine to clear the screen starts here
clrscr:
push bp
mov bp, sp
push es
push ax
push di
push dx

mov ax, 0xb800
mov es, ax
mov di, [bp+8]
mov dx, [bp+8]
add dx, 4000
mov al, 0x20

;<--------------------------attributes------------------------------>
mov ah, [bp+4] ;push dark black on cyan attribute
;mov ah, [bp+6] ;push dark black on white attribute
;<--------------------------attributes------------------------------>

nextloc:
mov word [es:di], ax
add di, 2
cmp di, dx
jne nextloc

pop dx
pop di
pop ax
pop es
pop bp
ret 4
;Subroutine to clear the screen ends here

; -------------------------------------------------------------------------
soundeffect:
    cmp byte [sound], 'c'
    je play_correct

    cmp byte [sound], 'w'
    je play_wrong

    cmp byte [sound], 's'
    je play_start

   
    ; ; Default case if no match
    jmp end_program_sound

play_correct:
    push word CORRECT_MOVE_FREQ
    call Sound_Frequency
    jmp end_program_sound

play_wrong:
    push word WRONG_MOVE_FREQ
    call Sound_Frequency
    jmp end_program_sound

play_start:
    push word GAME_START_FREQ
    call Sound_Frequency
    jmp end_program_sound


 end_program_sound:
     ret

; Sound_Frequency routine
Sound_Frequency:
    push bp
    mov bp, sp
    push ax
    push cx
    push dx

    mov ax, [bp+4] ; Load the frequency value from the stack

    ; Disable interrupts
    cli

    ; Set timer 2 control word
    mov al, 0xB6 ; Channel 2, lobyte/hibyte, mode 3 (square wave)
    out 0x43, al ; Timer control port

    ; Set frequency divisor
    out 0x42, al ; Send low byte to timer 2
    mov al, ah
    out 0x42, al ; Send high byte to timer 2

    ; Enable speaker
    in al, 0x61 ; Read current port state
    or al, 3 ; Set bits 0 and 1 to turn on speaker
    out 0x61, al ; Write back to port

    ; Longer, more controllable delay
    mov dx, 0x0118 ; Outer loop for longer duration
outer_delay:
    mov cx, 0x0FFF ; Inner loop for more precise timing
inner_delay:
    loop inner_delay
    dec dx
    jnz outer_delay

    ; Disable speaker
    in al, 0x61
    and al, 0xFC ; Clear speaker enable bits
    out 0x61, al

    ; Re-enable interrupts
    sti

    pop dx
    pop cx
    pop ax
    pop bp
    ret 2

; ------------------------------Display Screen Code starts here------------------------------------------->

printstring:
push bp
mov bp, sp
push dx
push es
push ax
push cx
push si
push di
 
mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [bp+6] ; multiply with y position
add ax, [bp+8] ; add x position
shl ax, 1 ; turn into byte offset
mov di, ax ; point di to required location

;<--------------------------attributes------------------------------>
mov ah, [bp+4] ; push dark black on cyan attribute
;mov ah, [bp+6] ; push dark black on white attribute
;<--------------------------attributes------------------------------>

mov dx, 0 ; To keep track of blank spaces
cld

;Prints firt row as blank white space
mov cx, 26
firstlines:
mov al, 0x20 ; Load ASCII value in al
firstlineloop:
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
loop firstlineloop ; repeat for the whole row
add dx, 1
cmp dx, 5
jz ninth
cmp dx, 4
jz seventh
cmp dx, 3
jz sixth
cmp dx, 2
jz fourth
;First row printing ends here

;Secondline printing
mov di, 380
mov si, wm
mov cx, 18
line1:
lodsb
stosw
loop line1

;Thirdline printing
mov cx, 26
jmp firstlines

;Fourthline printing
fourth:
mov di, 670
mov si, nm1
mov cx, 48
line2:
lodsb
stosw
loop line2

;Fifthline printing
mov cx, 26
jmp firstlines

;Sixthline printing
sixth:
mov di, 1020
mov si, nm2
mov cx, 17
line3:
lodsb
stosw
loop line3

;Seventhline printing
mov cx, 26
jmp firstlines

;Seventhline overwrite
seventh:
mov al, 0xC4
mov cx, 17
mov di, 1180
underline:
mov word [es:di], ax
add di, 2
loop underline

;Eigthline printing
mov cx, 26
jmp firstlines

;Ninthline printing
ninth:
mov di, 1470
mov si, nm3
mov cx, 8
line4a:
lodsb
stosw
loop line4a

add di, 18
mov si, nm4
mov cx, 12
line4b:
lodsb
stosw
loop line4b

add di, 18
mov si, nm5
mov cx, 6
line4c:
lodsb
stosw
loop line4c

;box printing
mov di, 506
mov al, 0xDA
mov word [es:di], ax
add di, 160
mov al, 0xB3
mov word [es:di], ax
add di, 160
mov al, 0xC0
mov word [es:di], ax

mov di, 608
mov al, 0xBF
mov word [es:di], ax
add di, 160
mov al, 0xB3
mov word [es:di], ax
add di, 160
mov al, 0xD9
mov word [es:di], ax

mov di, 508
mov cx, 50
mov dx, 0
mov al, 0xC4
loop1:
mov word [es:di], ax
add di, 2
loop loop1
mov di, 828
add dx, 1
cmp dx, 2
jz theme
mov cx, 50
jmp loop1
;----------------


;Theme options printing starts here

theme:
mov di, 2722
mov si, t1
mov cx, 21
themeleft:
lodsb
stosw
loop themeleft

add di, 64
mov si, t2
mov cx, 22
themeright:
lodsb
stosw
loop themeright

;Theme options printing ends here

; Mini grid printing
mgrids:
mov al, 0xDA
mov di, 1804
mov word [es:di], ax
mov cx, 3
column1:
mov al, 0xB3
add di, 160
mov word [es:di], ax
add di, 160
mov word [es:di], ax
add di, 160
mov word [es:di], ax
add di, 160
mov al, 0xC3
mov word [es:di], ax
loop column1


mov di, 1806
mov cx, 3
row1:
mov al, 0xC4
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xC2
mov word [es:di], ax
add di, 2
loop row1

mov di, 2446
mov cx, 3
mov dx, 0
nextrows:
mov al, 0xC4
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xC5
mov word [es:di], ax
add di, 2
loop nextrows
add dx, 1
cmp dx, 3
jz cols
add di, 580
mov cx, 3
jmp nextrows

cols:
mov di, 1984
mov dx, 0
mov cx, 3
nextcols:
mov al, 0xB3
mov word [es:di], ax
add di, 160
mov word [es:di], ax
add di, 160
mov word [es:di], ax
add di, 160
mov al, 0xC5
mov word [es:di], ax
add di, 160
loop nextcols
add dx, 1
cmp dx, 3
jz gridedges
add cx, 3
sub di, 1900
jmp nextcols

gridedges:
;Overwriting the edges of the right border of the grid
mov al, 0xBF
mov di, 1864
mov word [es:di], ax
add di, 640
mov al, 0xB4
mov word [es:di], ax
add di, 640
mov word [es:di], ax
mov al, 0xD9
add di, 640
mov word [es:di], ax

;Overwriting the edges of the bottom border of the grid
mov al, 0xC0
mov di, 3724
mov word [es:di], ax
mov al, 0xC1
add di, 20
mov word [es:di], ax
add di, 20
mov word [es:di], ax

printcentre:
    ; Move the starting position of the center of the first box into DI
    mov di, 1494        

    ; Shift down by one row before printing
    add di, 640 ; Move DI down to the new position (one row below)

    ; Now print at the new location
    mov al, '2' ; Load the character '2' into AL register
    mov [es:di], al ; Store the character '2' at the calculated position in memory
    mov [es:di + 1], ah ; Store the attribute byte after the character
    add di, 20 ; Move to the next column in the same row

   
    mov al, '7'        
    mov [es:di], al            
    mov [es:di + 1], ah
    add di, 20  

   
    mov al, '4'        
    mov [es:di], al          
    mov [es:di + 1], ah
   
    add di, 600
    mov al, '1'      
    mov [es:di], al          
    mov [es:di + 1], ah
    add di, 20  
    mov al, '3'        
    mov [es:di], al            
    mov [es:di + 1], ah
    add di, 20  
    mov al, '5'        
    mov [es:di], al            
    mov [es:di + 1], ah
    add di,600
    mov al, '9'        
    mov [es:di], al        
    mov [es:di + 1], ah
    add di, 20  
    mov al, '8'        
    mov [es:di], al          
    mov [es:di + 1], ah
    add di, 20
    mov al, '6'        
    mov [es:di], al            
    mov [es:di + 1], ah

exit:
pop di
pop si
pop cx
pop ax
pop es
pop dx
pop bp
ret 6
;Subroutine to print something on the screen ends here
; ------------------------------------------------------------------------
cursordmovement:
     push ax
     push es
     push di
     mov ax, 0xb800
     mov es,ax
     mov di, 1676
     


     userinput1:
     mov ax,0
     int 0x16
     
     cmp ah, 0x4B ; Check for Left Arrow
     jz leftNotesInt2
     cmp ah, 0x4D ; Check for Right Arrow
     jz rightNotesInt_11
     cmp ah,0x1C
     jz enterKeyInt_1
     cmp ah, 0x39 ; Space bar to just exit display screen
     jz exitNotesInterval_1
     jmp userinput1

 leftNotes2:
 mov al, 0x20
 mov ah, 0x30
 mov word[es:di],ax
 add di, 2
 mov word[es:di],ax
 add di, 2
 mov word[es:di],ax
 sub di,4


 cmp byte[cursorcol],1
 jz leftNotesInt_22

 cmp byte[cursorcol2],1

 jz themejmp
 cmp byte[cursorcol],5
 jz themejmp_22
 

 sub di,40
 mov al,0xC4
 mov ah, byte[cursorAttribute]
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 sub di,4
 dec byte[cursorcol]
 dec byte[cursorcol2]
 leftNotesInt_22:
 jmp exitleftNotes2

leftNotesInt2:
jmp leftNotes2

rightNotesInt_1:
jmp rightNotes2

enterKeyInt_1:
jmp enterkey_1

exitNotesInterval_1:
jmp exitcursordmovement

rightNotesInt_11:
jmp exitrightNotes2

themejmp:
 add di,1266
 mov al,0xC4
 mov ah, byte[cursorAttribute]
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 sub di,4
 dec byte[cursorcol]
 jmp exitleftNotes2

themejmp_22:
 sub di,1300
 mov al,0xC4
 mov ah, byte[cursorAttribute]
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 sub di,4
 dec byte[cursorcol]
 jmp exitleftNotes2

 exitleftNotes2:
 jmp userinput1

 rightNotes2:
 mov al, 0x20
 mov ah, 0x30
 mov word[es:di],ax
 add di, 2
 mov word[es:di],ax
 add di, 2
 mov word[es:di],ax
 sub di,4
 cmp byte[cursorcol],5
 jz rightNotesInt_1
 cmp byte[cursorcol2],3
 jz themejmp_1
 cmp byte[cursorcol],1
 jz themejmp_2
 
add di,36
 mov al,0xc4
 mov ah, byte[cursorAttribute]
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 sub di,4
 inc byte[cursorcol]
 inc byte[cursorcol2]
 jmp exitrightNotes2

 themejmp_1:
 add di,1300
 mov al,0xC4
 mov ah, byte[cursorAttribute]
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 sub di,4
 inc byte[cursorcol]
 jmp exitrightNotes2
 themejmp_2:
 sub di,1266
 mov al,0xC4
 mov ah, byte[cursorAttribute]
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 add di,2
 mov word[es:di],ax
 sub di,4
 inc byte[cursorcol]
 jmp exitrightNotes2


 exitrightNotes2:
 jmp userinput1


 enterkey_1:
 cmp di, 2906
 jz themeselection
 cmp di, 1640
 jz Beginner1
 cmp di, 1676
 jz Intermediate1
 cmp di, 1712
 jz hard1
 cmp di, 3012
 jz themeselection2

 jmp userinput1

 themeselection:
     mov byte[textAttribute],0x30
     mov ax, 0 ; Push value of di for page 0
     push ax
     mov ax, 0x70 ; dark black on white attribute
     push ax
     mov ax, [textAttribute] ; dark black on cyan attribute
     push ax
call clrscr
     jmp userinput1
 Beginner1:
     mov byte[Difficultylevel],1
      jmp exitcursordmovement
 Intermediate1:
         mov byte[Difficultylevel],2
         jmp exitcursordmovement
 hard1:
         mov byte[Difficultylevel],3
         jmp exitcursordmovement
 themeselection2:
             mov byte[textAttribute],0x03
             mov ax, 0 ; Push value of di for page 0
push ax
mov ax, 0x70 ; dark black on white attribute
push ax
mov ax, [textAttribute] ; dark black on cyan attribute
push ax
call clrscr
jmp userinput1
 exitcursordmovement:        
 pop di
 pop es
 pop ax
 ret


; ------------------------------Display Screen Code ends here--------------------------------------------->

; ------------------------------------------Page 1 printing starts here----------------------------------->

;Subroutine to print something on the screen starts here
page1_Upper5:
push bp
mov bp, sp
push dx
push bx
push es
push ax
push cx
push si
push di
 
mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [bp+12] ; multiply with y position
add ax, [bp+14] ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location

;<--------------------------attributes------------------------------>  
mov ah, [bp+4] ; push dark black on cyan attribute
;mov ah, [bp+6] ; push dark black on white attribute
;<--------------------------attributes------------------------------>

mov dx, 0
mov al, 0x20
cld

;Prints firt row as blank white space
mov cx, 26 ;set counter cx to 26
firstline:
mov word [es:di], ax ;store value
add di, 2 ;moves to the next character position (2 bytes per char)
mov word [es:di], ax ;stores another blank space
add di, 2 ;moves to next character position
mov word [es:di], ax
add di, 2
loop firstline ;repeat for the whole row (26) times
;First row printing ends here


;Grid printing starts here-------------------------------------->
;Print top most row of grid
mov al, 0xDA
mov di, 200 ;set di to 200 that is the offset to the next row to be printed.
mov word [es:di], ax ;store character with respective attribute
add di, 2 ;moves di to the next character

mov cx, 9 ;set counter to 9 for the second row.
firstrow:
mov al, 0xC4
mov word [es:di], ax ; store charcter here
add di, 2 ; moves to next charcter
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xBF
mov word [es:di], ax
add di, 2 ; stores another character
loop firstrow ; repeat for the whole row
add di, 86 ; to move on to the start of the next row
                        ; 40 bytes space on left | 46 bytes space on right
loopstart:

;<--------------------------attributes------------------------------>
mov ah, [bp+8] ; push dark black on cyan attribute
;mov ah, [bp+10] ; push dark black on white attribute
;<--------------------------attributes------------------------------>

mov al, 0xB3
mov word [es:di], ax ;stores a char in current memory location
add di, 2


mov cx, 9 ; cx is initialized or set to 9
secondrow:
mov al, 0x20
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xB3
mov word [es:di], ax
add di, 2
loop secondrow ; repeat for the whole row
add di, 86

mov al, 0xB3
mov word [es:di], ax
add di, 2

mov cx, 9
thirdrow:
mov al, 0x20
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xB3
mov word [es:di], ax
add di, 2
loop thirdrow ; repeat for the whole row
add di, 86

mov al, 0xB3
mov word [es:di], ax
add di, 2

mov cx, 9
fourthrow:
mov al, 0x20
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xB3
mov word [es:di], ax
add di, 2
loop fourthrow ; repeat for the whole row
add di, 86

mov al, 0xC3
mov word [es:di], ax
add di, 2

mov cx, 9
fifthrow:
mov al, 0xC4
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xB4
mov word [es:di], ax
add di, 2
loop fifthrow ; repeat for the whole row

add dx, 1 ;Ending counter(keeps track of how many boxes being printed)
cmp dx, 5 ;Prints 5 boxes = 22 rows
jz exit1 ;Total 22 rows printed with first one as empty space
add di, 86 ;move to the next row
jmp loopstart ;jump back to the start of the loop to print the next row


exit1:
sub di, 74 ;di is being pointed to the previous row start
mov al, 0xC0
mov word [es:di], ax ; stored value in current memory location
add di, 2 ;move 2 bytes forward
mov cx, 9 ;counter is set to 9
fifthrowow:
mov al, 0xC4 ;storing character again
mov word [es:di], ax
add di, 2 ; move to next char(2 bytes)
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xD9
mov word [es:di], ax
add di, 2
loop fifthrowow ; repeat for the whole row(9 box in total)

; dark row priting begins here----------------------------->

;<--------------------------attributes------------------------------>
mov ah, [bp+4] ; push dark black on cyan attribute
;mov ah, [bp+6] ; push dark black on white attribute
;<--------------------------attributes------------------------------>

mov di, 2122 ;set di to the starting point of the dark row in video
cld ;clear the direction flag to inc di after evry operation
mov cx, 9
darkrow1:
mov al, 0xC4
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xB4
mov word [es:di], ax
add di, 2
loop darkrow1
; dark row priting ends here

; dark column priting begins here
mov dx, 0
mov di, 200
cld
mov cx, 1
darkcol1:
mov al, 0xDA
mov word [es:di], ax
add di, 24 ;increment di by 24 to move to the next character in the column
mov al, 0xC2
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 24
mov al, 0xBF
mov word [es:di], ax
add di, 88
loop darkcol1

mov cx, 3
mov al, 0xB3
darkcol2:
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 88
loop darkcol2
add dx, 1
cmp dx, 5
mov cx, 1
jz darkcol4


darkcol3:
mov al, 0xC3
mov word [es:di], ax
add di, 24
mov al, 0xC5
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 24
mov al, 0xB4
mov word [es:di], ax
add di, 88
loop darkcol3
mov cx, 3
mov al, 0xB3
jmp darkcol2

darkcol4:
mov al, 0xC0
mov word [es:di], ax
add di, 24
mov al, 0xC1
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 24
mov al, 0xD9
mov word [es:di], ax
add di, 88
loop darkcol4
; dark column priting ends here

; Row numbering of our grid starts here--------------->

; Left column row numdering
mov di, 358
mov si, [bp+16]
mov cx, 5
rnumpleft:
lodsb
stosw
add di, 638
loop rnumpleft

; Right column row numdering
mov di, 434
mov si, [bp+16]
mov cx, 5
rnumpright:
lodsb
stosw
add di, 638
loop rnumpright

; Row numbering of our grid ends here------------------>


; Instructions printing on left and right begins here--------------------->

insp:
mov di, 610 ; Blank space starts from di = 274
mov si, [bp+18] ; Print word "Notes:"
mov cx, 6
insp1:
lodsb
stosw
loop insp1
add di, 148
mov cx, 5
mov al, 0xC4
u1:
mov word[es:di], ax ; Underlines "Notes"
add di, 2
loop u1

; Mini Grids Printing Starts here

mov bx, 0
mov si, 0
; Just tweek this value to change position of the whole 3x3 set of mini grid v
mov di, 1552 ; To start box pritning at di = 918 bytes
; Just tweek this value to change position of the whole 3x3 set of mini grid ^

mgrid:
sub di, 634
; Top edges
;mov di, 916 ; 930
mov al, 0xDA
mov word[es:di], ax
add di, 8
mov al, 0xBF
mov word[es:di], ax

mov dx, 0
mov al, 0xB3
mov cx, 3
sub di, 8 ; To jump to bytes = 930
verticallines:
add di, 160
mov word[es:di], ax
loop verticallines
add dx, 1
cmp dx, 2
jz bedges
mov cx, 3
sub di, 472 ; To jump to bytes = 938
jmp verticallines

bedges:
; Bottom edges
add di, 152 ; To jump to bytes = 1570
mov al, 0xC0
mov word[es:di], ax
add di, 8
mov al, 0xD9
mov word[es:di], ax

sub di, 648 ; To jump to bytes = 930
mov cx, 3
mov al, 0xC4
mov dx, 0
horizontallines:
add di, 2
mov word[es:di], ax
loop horizontallines
add dx, 1
cmp dx, 2
jz nbox1
mov cx, 3
add di, 634 ; To jump to bytes = 1570
jmp horizontallines

nbox1:
add bx, 1
cmp bx, 3
jnz mgrid ; 290 bytes + 634 bytes
add di, 924 ; To move on to bytes = 1878 for the next row
mov bx, 0
add si, 1
cmp si, 3
jnz mgrid
 
; Mini Grids Printing ends here
 
; notes printing inside ins box starts here

notes:
mov si, [bp+16]
mov di, 1092 ;first position inside notes box
mov cx, 3
mov dx, 0
nloop:
lodsb
stosw
loop nloop
add dx, 1
cmp dx, 3
jz next_123
mov cx, 3
add di, 154 ;to jump on to the first position of next row
jmp nloop

; notes printing inside ins box ends here
next_123:


; Guidelines on left start here
guidelines:
mov di, 324 ; di = 324 bytes
mov si, [bp+20]
mov cx, 12
gl1:
lodsb
stosw
loop gl1

add di, 296 ; di = 644 bytes
mov si, [bp+22]
mov cx, 8
gl2:
lodsb
stosw
loop gl2

add di, 304 ; di = 964 bytes
mov si, [bp+24]
mov cx, 13
gl3:
lodsb
stosw
loop gl3

add di, 294 ; di = 1284 bytes
mov si, [bp+26]
mov cx, 9
gl4:
lodsb
stosw
loop gl4

add di, 302 ; di = 1604 bytes
mov si, [bp+28]
mov cx, 13
gl5:
lodsb
stosw
loop gl5

add di, 134 ; di = 1764 bytes
mov si, [bp+30]
mov cx, 4
gl6:
lodsb
stosw
loop gl6

add di, 312 ; di = 2084 bytes
mov si, [bp+32]
mov cx, 13
gl7:
lodsb
stosw
loop gl7

add di, 134 ; di = 2244 bytes
mov si, [bp+34]
mov cx, 5
gl8:
lodsb
stosw
loop gl8

add di, 310 ; di = 2564 bytes
mov si, [bp+36]
mov cx, 12
gl9:
lodsb
stosw
loop gl9

add di, 136 ; di = 2724 bytes
mov si, [bp+38]
mov cx, 14
gl10:
lodsb
stosw
loop gl10

add di, 132 ; di = 2884 bytes
mov si, [bp+40]
mov cx, 14
gl11:
lodsb
stosw
loop gl11

; Guidelines on left end here


; Instructions printing ends here

exit2:
pop di
pop si
pop cx
pop ax
pop es
pop bx
pop dx
pop bp
ret 40
;Subroutine to print something on the screen ends here

; ----------------------------Page 2 printing ends here--------------------------------------------->

















;-----------------------------Page2 start---------------------------------->
;Subroutine to print something on the screen starts here

page2_Lower4:
push bp
mov bp, sp
push dx
push bx
push es
push ax
push cx
push si
push di
 
mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [bp+12] ; multiply with y position
add ax, [bp+14] ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes

;<--------------------------attributes------------------------------>  
mov ah, [bp+8] ; push light black on cyan attribute
;mov ah, [bp+10] ; push light black on white attribute
;<--------------------------attributes------------------------------>

mov dx, 0
mov al, 0x20
cld


;Prints firt row as blank white space
mov cx, 26 ;set counter cx to 26
firstline_2:
mov word [es:di], ax ;store value
add di, 2 ;moves to the next character position (2 bytes per char)
mov word [es:di], ax ;stores another blank space
add di, 2 ;moves to next character position
mov word [es:di], ax
add di, 2
loop firstline_2 ;repeat for the whole row (26) times
;First row printing ends here


;Grid printing starts here-------------------------------------->
;Print top most row of grid
mov al, 0xDA ; Top left edge
mov di, 200 ;set di to 200 that is the offset to the next row to be printed.
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes
mov word [es:di], ax ;store character with respective attribute
add di, 2 ;moves di to the next character

mov cx, 9 ;set counter to 9 for the second row.
firstrow_2:
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax ; store charcter here
add di, 2 ; moves to next charcter
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xC2 ; Top left/right double edge
mov word [es:di], ax
add di, 2 ; stores another character
loop firstrow_2 ; repeat for the whole row
sub di, 2
mov al, 0xBF ; Top right edge
mov word [es:di], ax
add di, 88 ; to move on to the start of the next row
                        ; 40 bytes space on left | 46 bytes space on right
loopstart_2:

mov bx, 0 ; To keep track of similar printing
duplicate_run_1:
mov al, 0xB3 ; Vertical line
mov word [es:di], ax ; stores a char in current memory location
add di, 2

mov cx, 9 ; cx is initialized or set to 9
secondrow_2:
mov al, 0x20 ; Empty space
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xB3 ; Vertical Line
mov word [es:di], ax
add di, 2
loop secondrow_2 ; repeat for the whole row
add di, 86
add bx, 1
cmp bx, 3 ; will print this for 3 rows (2nd, 3rd, and 4th)
jnz duplicate_run_1

mov al, 0xC3 ; Left up/down double edge
mov word [es:di], ax
add di, 2

mov cx, 9
fifthrow_2:
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xC5 ; Right/Left up/down double edge
mov word [es:di], ax
add di, 2
loop fifthrow_2 ; repeat for the whole row
sub di, 2
mov al, 0xB4 ; Right up/down double edge
mov word [es:di], ax
add di, 2

add dx, 1 ;Ending counter(keeps track of how many boxes being printed)
cmp dx, 4 ;Prints 4 boxes = 18 rows
jz next_1 ;Total 18 rows printed with first one as empty space
add di, 86 ;move to the next row
jmp loopstart_2 ;jump back to the start of the loop to print the next row

next_1:
; Overwriting of our grid taking place below this
; dark row priting begins here-------------------------->

;<--------------------------attributes------------------------------>
mov ah, [bp+4] ; push dark black on cyan attribute
;mov ah, [bp+6] ; push dark black on white attribute
;<--------------------------attributes------------------------------>

mov bx, 0 ; Will keep track of duplicate running
mov di, 842 ;set di to the starting point of 6th row to darken (skipping left column border i.e. 840 + 2)
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes
cld ;clear the direction flag to inc di after evry operation
duplicate_run_2:
mov cx, 9
darkrow1_2:
mov al, 0xC4 ; Horizontal Dash
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xC5 ; Right/Left up/down double edge
mov word [es:di], ax
add di, 2
loop darkrow1_2
sub di, 2
mov al, 0xB4 ; Right up/down double edge
mov word [es:di], ax

mov di, 2762 ;set di to the starting point of 9th row to darken (skipping left column border i.e. 2760 + 2)
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes
add bx, 1
cmp bx, 2
jnz duplicate_run_2

mov bx, 0 ; Will keep track of duplicate running
mov di, 2760
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes
mov al, 0xC0 ; Bottom left edge
mov word [es:di], ax
mov al, 0xC1 ; Bottom left/right double edge
duplicate_run_3:
add di, 8
mov word [es:di], ax
add bx, 1
cmp bx, 8
jnz duplicate_run_3
add di, 8
mov al, 0xD9 ; Bottom right edge
mov word [es:di], ax

; dark row priting ends here---------------------->

; dark column priting begins here----------------->
mov dx, 0
mov di, 200
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes
cld
mov cx, 1
darkcol1_2:
mov al, 0xDA ; Top left edge
mov word [es:di], ax
add di, 24 ;increment di by 24 to move to the next character in the column
mov al, 0xC2 ; Top left/right double edge
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 24
mov al, 0xBF ; Top right edge
mov word [es:di], ax
add di, 88
loop darkcol1_2

mov cx, 3
mov al, 0xB3 ; Vertical Line
darkcol2_2:
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 88
loop darkcol2_2

mov cx, 1
darkcol3_2:
mov al, 0xC3 ; Left up/down double edge
mov word [es:di], ax
add di, 24
mov al, 0xC5 ; left/Right up/down double edge
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 24
mov al, 0xB4 ; Right up/down double edge
mov word [es:di], ax
add di, 88
loop darkcol3_2
mov cx, 3
mov al, 0xB3
add dx, 1
cmp dx, 4
jnz darkcol2_2

sub di, 160 ; To overwrite the last row
darkcol4_2:
mov al, 0xC0 ; Bottom Left edge            
mov word [es:di], ax
add di, 24
mov al, 0xC1 ; Bottom left/right double edge
mov word [es:di], ax
add di, 24
mov word [es:di], ax
add di, 24
mov al, 0xD9 ; Bottom Right edge
mov word [es:di], ax

; dark column priting ends here---------->

; Overwriting of our grid taking place above this

; Left column row numdering

mov di, 358
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes
mov si, [bp+16] ; numprint
add si, 5 ; To point si to number 6 (as row numbering from 6 to 9)
mov cx, 4
rnumpleft_2:
lodsb
stosw
add di, 638
loop rnumpleft_2

; Right column row numdering
mov di, 434
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes
mov si, [bp+16] ; numprint
add si, 5 ; To point si to number 6 (as row numbering from 6 to 9)

mov cx, 4
rnumpright_2:
lodsb
stosw
add di, 638
loop rnumpright_2

; Row numbering of our grid ends here
;Grid printing ends here-------------------------------------->

; Instructions printing begins here

insp_2:
mov di, 610 ; Blank space starts from di = 274
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes
mov si, [bp+18] ; Print word "Notes:"
mov cx, 6
insp1_2:
lodsb
stosw
loop insp1_2
add di, 148
mov cx, 5
mov al, 0xC4
u1_2:
mov word[es:di], ax ; Underlines "Notes"
add di, 2
loop u1_2
;-----------------
;numbering of grid

   
   
; Mini Grids Printing Starts here

mov bx, 0
mov si, 0
; Just tweek this value to change position of the whole 3x3 set of mini grid v
mov di, 1552 ; To start box pritning at di = 918 bytes
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes
; Just tweek this value to change position of the whole 3x3 set of mini grid ^

mgrid_2:
sub di, 634
; Top edges
;mov di, 916 ; 930
mov al, 0xDA
mov word[es:di], ax
add di, 8
mov al, 0xBF
mov word[es:di], ax

mov dx, 0
mov al, 0xB3
mov cx, 3
sub di, 8 ; To jump to bytes = 930
verticallines_2:
add di, 160
mov word[es:di], ax
loop verticallines_2
add dx, 1
cmp dx, 2
jz bedges_2
mov cx, 3
sub di, 472 ; To jump to bytes = 938
jmp verticallines_2

bedges_2:
; Bottom edges
add di, 152 ; To jump to bytes = 1570
mov al, 0xC0
mov word[es:di], ax
add di, 8
mov al, 0xD9
mov word[es:di], ax

sub di, 648 ; To jump to bytes = 930
mov cx, 3
mov al, 0xC4
mov dx, 0
horizontallines_2:
add di, 2
mov word[es:di], ax
loop horizontallines_2
add dx, 1
cmp dx, 2
jz nbox1_2
mov cx, 3
add di, 634 ; To jump to bytes = 1570
jmp horizontallines_2

nbox1_2:
add bx, 1
cmp bx, 3
jnz mgrid_2 ; 290 bytes + 634 bytes
add di, 924 ; To move on to bytes = 1878 for the next row
mov bx, 0
add si, 1
cmp si, 3
jnz mgrid_2
 
; Mini Grids Printing ends here

; Guidelines on left start here
guidelines_2:
mov di, 324 ; di = 324 bytes
add di, 0x1000 ; Because we are on page 1 so this is beyond 4000 bytes
mov si, [bp+20] ; l1
mov cx, 12
gl1_2:
lodsb
stosw
loop gl1_2

add di, 296 ; di = 644 bytes
mov si, [bp+22] ; l2
mov cx, 8
gl2_2:
lodsb
stosw
loop gl2_2

add di, 304 ; di = 964 bytes
mov si, [bp+24]
mov cx, 13
gl3_2:
lodsb
stosw
loop gl3_2

add di, 294 ; di = 1284 bytes
mov si, [bp+26]
mov cx, 9
gl4_2:
lodsb
stosw
loop gl4_2

add di, 302 ; di = 1604 bytes
mov si, [bp+28]
mov cx, 13
gl5_2:
lodsb
stosw
loop gl5_2

add di, 134 ; di = 1764 bytes
mov si, [bp+30]
mov cx, 4
gl6_2:
lodsb
stosw
loop gl6_2

add di, 312 ; di = 2084 bytes
mov si, [bp+32]
mov cx, 13
gl7_2:
lodsb
stosw
loop gl7_2

add di, 134 ; di = 2244 bytes
mov si, [bp+34]
mov cx, 5
gl8_2:
lodsb
stosw
loop gl8_2

add di, 310 ; di = 2564 bytes
mov si, [bp+36]
mov cx, 12
gl9_2:
lodsb
stosw
loop gl9_2

add di, 136 ; di = 2724 bytes
mov si, [bp+38]
mov cx, 14
gl10_2:
lodsb
stosw
loop gl10_2

add di, 132 ; di = 2884 bytes
mov si, [bp+40]
mov cx, 14
gl11_2:
lodsb
stosw
loop gl11_2

; Guidelines on left end here

; Instructions printing ends here

exit2_2:
pop di
pop si
pop cx
pop ax
pop es
pop bx
pop dx
pop bp
ret 38

;Subroutine to print something on the screen ends here
;-----------------------------Page2 end---------------------------------->


;--------------------------------------------------------------------------------------------------Overwrite Part begins here--------------------------------------------------->

;-----------------------------subroutine of cursor movements begins here------------------>

upArrow:
push bp
mov bp, sp
push bx
push ax
push es
push dx


mov bx, [bp+4] ; Row no.
cmp bl, 1
jz upInterval ; If already at end of grid, ignore
mov ax, word [es:di]
cmp al, '-' ; To check if current element number or empty space
jnz skipUp_3
mov al, 0x20 ; As it was empty space
mov word [es:di], ax ; Empty space overwritten in place of cursor
checkUp_1:
mov bx, [bp+4] ; Row no.
cmp bl, 6
jz scrollUp ; If it is at top of page 1
sub di, 640 ; To move one space up
mov ax, word [es:di]
cmp al, 0x20 ; Now check if next location is a number or empty space
jnz skipUp_2
or ah, 10000000b
mov al, '-' ; As it was empty space
mov word [es:di], ax ; Replace with blinking cursor
jmp exit_upArrow_1
skipUp_2:
mov ax, word [es:di]
or ah, 10000000b ; To turn on blinking bit so that number starts blinking
mov word [es:di], ax
jmp exit_upArrow_1
skipUp_3:
mov ax, word [es:di]
and ah, 01111111b ; To revert (finish) blinking of number
mov word [es:di], ax
jmp checkUp_1

upInterval:
jmp exit_upArrow_2

scrollUp:
mov byte [currentPage], 0h
mov bx, di
mov dx, 4736 ; 4096 + (4*160)
sub dx, bx ; To find space from right    
mov di, 4000 ; Move to end of previous page          
sub di, 800 ; Move to 5th row
sub di, dx ; Move to correct position of 5th row
; Switch back to Page 0
mov ah, 05h ; BIOS function to set video page
mov al, 00h ; Select Page 0
int 10h ; Execute the BIOS interrupt to change the page

mov ax, word [es:di]
cmp al, 0x20 ; Now check if next location is a number or empty space
jnz skipUp_22
or ah, 10000000b
mov al, '-' ; As it was empty space
mov word [es:di], ax ; Replace with blinking cursor
jmp exit_upArrow_1
skipUp_22:
mov ax, word [es:di]
or ah, 10000000b ; To turn on blinking bit so that number starts blinking
mov word [es:di], ax
jmp exit_upArrow_1


exit_upArrow_1:
dec byte [gridRow]
exit_upArrow_2:
pop dx
pop es
pop ax
pop bx
pop bp
ret 2

downArrow:
push bp
mov bp, sp
push bx
push ax
push es
push dx


mov bx, [bp+4] ; Row no.
cmp bl, 9
jz downInterval ; If already at end of grid, ignore
mov ax, word [es:di]
cmp al, '-' ; To check if current element number or empty space
jnz skipDown_3
mov al, 0x20 ; As it was empty space
mov word [es:di], ax ; Empty space overwritten in place of cursor
checkDown_1:
mov bx, [bp+4] ; Row no.
cmp bl, 5
jz scrollDown ; If it is at end of page 1
add di, 640 ; To move one space down
mov ax, word [es:di]
cmp al, 0x20 ; Now check if next location is a number or empty space
jnz skipDown_2
or ah, 10000000b
mov al, '-' ; As it was empty space
mov word [es:di], ax ; Replace with blinking cursor
jmp exit_downArrow_1
skipDown_2:
mov ax, word [es:di]
or ah, 10000000b ; To turn on blinking bit so that number starts blinking
mov word [es:di], ax
jmp exit_downArrow_1
skipDown_3:
mov ax, word [es:di]
and ah, 01111111b ; To revert (finish) blinking of number
mov word [es:di], ax
jmp checkDown_1

downInterval:
jmp exit_downArrow_2

scrollDown:
mov byte [currentPage], 1h
mov bx, di
mov dx, 3040
sub bx, dx ; To find space from left
mov di, 4096 ; Move to start of next page
add di, 480 ; Move to 6th row
add di, bx ; Move to correct position of 6th row
; Switch to Page 1
mov ah, 05h ; BIOS function to set video page
mov al, 01h ; Select Page 1 (pages are 0-based, so 1 means page 1)
int 10h ; Execute the BIOS interrupt to change the page

mov ax, word [es:di]
cmp al, 0x20 ; Now check if next location is a number or empty space
jnz skipDown_22
or ah, 10000000b
mov al, '-' ; As it was empty space
mov word [es:di], ax ; Replace with blinking cursor
jmp exit_downArrow_1
skipDown_22:
mov ax, word [es:di]
or ah, 10000000b ; To turn on blinking bit so that number starts blinking
mov word [es:di], ax
jmp exit_downArrow_1

exit_downArrow_1:
inc byte [gridRow]
exit_downArrow_2:
pop dx
pop es
pop ax
pop bx
pop bp
ret 2

leftArrow:
push bp
mov bp, sp
push bx
push ax
push es

mov bx, [bp+4] ; Column no.
cmp bl, 1
jz exit_leftArrow ; If it is already at left edge, ignore movement
dec byte [gridColumn]
mov ax, word [es:di]
cmp al, '-' ; To check if current element number or empty space
jnz skipLeft_3
mov al, 0x20 ; As it was empty space
mov word [es:di], ax ; Empty space overwritten in place of cursor
checkLeft_1:
sub di, 8
mov ax, word [es:di]
cmp al, 0x20 ; Now check if next location is a number or empty space
jnz skipLeft_2
or ah, 10000000b
mov al, '-' ; As it was empty space
mov word [es:di], ax ; Replace with blinking cursor
jmp exit_leftArrow
skipLeft_2:
mov ax, word [es:di]
or ah, 10000000b ; To turn on blinking bit so that number starts blinking
mov word [es:di], ax
jmp exit_leftArrow
skipLeft_3:
mov ax, word [es:di]
and ah, 01111111b ; To revert (finish) blinking of number
mov word [es:di], ax
jmp checkLeft_1

exit_leftArrow:
pop es
pop ax
pop bx
pop bp
ret 2

rightArrow:
push bp
mov bp, sp
push bx
push ax
push es

mov bx, [bp+4] ; Column no.
cmp bl, 9
jz exit_rightArrow ; If it is already at right edge, ignore movement
inc byte [gridColumn]
mov ax, word [es:di]
cmp al, '-' ; To check if current element number or empty space
jnz skipThis_3
mov al, 0x20 ; As it was empty space
mov word [es:di], ax ; Empty space overwritten in place of cursor
check_1:
add di, 8
mov ax, word [es:di]
cmp al, 0x20 ; Now check if next location is a number or empty space
jnz skipThis_2
or ah, 10000000b
mov al, '-' ; As it was empty space
mov word [es:di], ax ; Replace with blinking cursor
jmp exit_rightArrow
skipThis_2:
mov ax, word [es:di]
or ah, 10000000b ; To turn on blinking bit so that number starts blinking
mov word [es:di], ax
jmp exit_rightArrow
skipThis_3:
mov ax, word [es:di]
and ah, 01111111b ; To revert (finish) blinking of number
mov word [es:di], ax
jmp check_1
     
exit_rightArrow:
pop es
pop ax
pop bx
pop bp
ret 2

;-----------------------------subroutines of cursor movements ends here------------------>

;-----------------------------subroutines to print big number starts here---------------->


numPresenceCheckRow:
push ax
push es
push di
push cx

mov ax, [bp+4]
mov cx, 0
mov bx, 0
mov bx, realTimeGrid
add bx, dx

rowCheck_12:
cmp byte [bx], al
jz rowCheckSuccess_1
add bx, 1
add cx, 1
cmp cx, 9
jz rowCheckSuccess_1
jmp rowCheck_12

rowCheckSuccess_1:
mov bx, 0
mov bl, cl
pop cx
pop di
pop es
pop ax
ret 2

numPresenceCheckCol:
push ax
push es
push di
push cx

mov al, byte [bp+4]
mov cx, 0
mov bx, 0
mov bx, realTimeGrid
mov cl, byte [gridColumn]
add bx, cx
sub bx, 1
jmp colCmp_2
colCmp_1:
add bx, 9
colCmp_2:
add cx, 1
cmp cx, 10
jz col_Success_1
mov ax, [bp+4]
cmp [bx], ax
jnz colCmp_1
col_Success_1:
mov bx, 0
mov bl, cl

colCheckSuccess_1:
pop cx
pop di
pop es
pop ax
ret 2

updateMistakes:
push ax
push es
push di
push dx

mov ax, 0xb800
mov es, ax
mov di, 0

add di, 984
oneItIs_3:
add dx, 1
mov al, byte [mistakes]
add al, 0x30
mov ah, byte [textAttribute]
mov word [es:di], ax
add di, 1000h
cmp dx, 2
jz updateDone_1
jmp oneItIs_3

updateDone_1:
pop dx
pop di
pop es
pop ax
ret

updateScore:

call printnum_1

ret

; subroutine to print a number on screen
; takes the row no, column no, and number to be printed as parameters
printnum_1: push bp
              mov bp, sp
              push es
              push ax
              push bx
              push cx
              push dx
              push di
              push si
 
               
              mov si, 0
              mov ax, 0xb800
              mov es, ax ; point es to video base
              mov di, 0
              mov di, 1302
              samePage_1:
              mov ax, 0
              mov al, byte [scorecount] ; load number in ax
              cmp al, 9
              ja tensPlace_1
              cmp al, 99
              ja hundredPlace
              mov cx, 1 ; initialize count of digits
              jmp moveOnNow
              tensPlace_1:
              mov cx, 2 ; initialize count of digits
              hundredPlace:
              mov cx, 3 ; initialize count of digits
              moveOnNow:
              mov bx, 10 ; use base 10 for division
               
 
nextdigit: mov dx, 0 ; zero upper half of dividend
              div bx ; divide by 10
              add dl, 0x30 ; convert digit into ascii value
              cmp dl, 0x39 ; is the digit an alphabet
              jbe skipalpha ; no, skip addition
              add dl, 7 ; yes, make in alphabet code
skipalpha: mov dh, [textAttribute] ; attach normal attribute
              mov [es:di], dx ; print char on screen
              sub di, 2 ; to previous screen location
              loop nextdigit ; if no divide it again
              add si, 1
              mov di, 0x1000
              add di, 1302
             
              cmp si, 2
              jnz samePage_1
 
              pop si
              pop di
              pop dx
              pop cx
              pop bx
              pop ax
              pop es
              pop bp
              ret  


; Number: 1
one:
push ax
push di
push bx
push dx

mov ax, word [es:di]
cmp al, '-'
jnz exit_one
mov ax, 0
mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl
sub al, 1
add al, byte [gridColumn]
mov bx, finalGrid_1
add bx, ax
cmp byte [bx], 1
jnz exit_one_1
mov bx, realTimeGrid
add bx, ax
mov byte [bx], 1

add byte [scorecount], 2
call updateScore
mov byte[sound],'c'
call soundeffect
mov ah, byte [textAttribute]
mov al, 0xB3 ; Vertical dash
mov word [es:di], ax
sub di, 160
mov word [es:di], ax
add di, 320
mov word [es:di], ax
jmp exit_one

exit_one_1:
    mov byte[sound],'w'
    call soundeffect
inc byte [mistakes]
call updateMistakes
exit_one:
pop dx
pop bx
pop di
pop ax
ret

; Number 2
two:
push ax
push di
push bx

mov ax, word [es:di]
cmp al, '-'
jnz beyondTwo_2

mov ax, 0
mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl
sub al, 1
add al, byte [gridColumn]

mov bx, finalGrid_1
add bx, ax
cmp byte [bx], 2
jnz exit_two_1

mov bx, realTimeGrid
add bx, ax
mov byte [bx], 2
jmp beyondTwo_1

beyondTwo_2:
jmp exit_two

beyondTwo_1:
add byte [scorecount], 2
call updateScore
mov byte[sound],'c'
call soundeffect

sub di, 162
mov ah, byte [textAttribute]
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax  
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xBF ; Top right edge
mov word [es:di], ax
add di, 160
mov al, 0xD9 ; Bottom right edge
mov word [es:di], ax
sub di, 2
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
sub di, 2
mov al, 0xDA ; Top left edge
mov word [es:di], ax
add di, 160
mov al, 0xC0 ; Bottom left edge
mov word [es:di], ax
add di, 2
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
add di, 2
mov word [es:di], ax
jmp exit_two

exit_two_1:
    mov byte[sound],'w'
    call soundeffect
inc byte [mistakes]
call updateMistakes
exit_two:
pop bx
pop di
pop ax
ret

; Number 3
three:
push ax
push di
push bx

mov ax, word [es:di]
cmp al, '-'
jnz threeint_12

mov ax, 0
mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl
sub al, 1
add al, byte [gridColumn]

mov bx, finalGrid_1
add bx, ax
cmp byte [bx], 3
jnz exit_three_1

mov bx, realTimeGrid
add bx, ax
mov byte [bx], 3
jmp threeint_13

threeint_12:
jmp exit_three

threeint_13:
add byte [scorecount], 2
call updateScore
mov byte[sound],'c'
call soundeffect

sub di, 162 ; Bring to top left of 3x3 grid box
mov ah, byte [textAttribute]
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax  
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xBF ; Top right edge
mov word [es:di], ax
add di, 160
mov al, 0xB4 ; Right up/down double edge
mov word [es:di], ax
sub di, 2
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
sub di, 2
mov word [es:di], ax
add di, 160
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xD9 ; Bottom right edge
mov word [es:di], ax
jmp exit_three

exit_three_1:
    mov byte[sound],'w'
    call soundeffect
inc byte [mistakes]
call updateMistakes
exit_three:
pop bx
pop di
pop ax
ret

; Number 4
four:
push ax
push di
push bx

mov ax, word [es:di]
cmp al, '-'
jnz exit_four

mov ax, 0
mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl
sub al, 1
add al, byte [gridColumn]

mov bx, finalGrid_1
add bx, ax
cmp byte [bx], 4
jnz exit_four_1

mov bx, realTimeGrid
add bx, ax
mov byte [bx], 4

add byte [scorecount], 2
call updateScore
mov byte[sound],'c'
call soundeffect

sub di, 162 ; Bring to top left of 3x3 grid box
mov ah, byte [textAttribute]
mov al, 0xB3 ; Vertical dash
mov word [es:di], ax  
add di, 160
mov al, 0xC0 ; Bottom left edge
mov word [es:di], ax
add di, 2
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
add di, 2
mov al, 0xB4 ; Right up/down double edge
mov word [es:di], ax
sub di, 160
mov al, 0xB3 ; Vertical dash
mov word [es:di], ax
add di, 320
mov word [es:di], ax
jmp exit_four

exit_four_1:
    mov byte[sound],'w'
    call soundeffect
inc byte [mistakes]
call updateMistakes
exit_four:
pop bx
pop di
pop ax
ret

; Number 5
five:
push ax
push di
push bx

mov ax, 0
mov ax, word [es:di]
cmp al, '-'
jnz beyondFive_2

mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl
sub al, 1
add al, byte [gridColumn]

mov bx, finalGrid_1
add bx, ax
cmp byte [bx], 5
jnz exit_five_1

mov dx, realTimeGrid
add bx, dx
mov byte [bx], 5
jmp beyondFive_1

beyondFive_2:
jmp exit_five

beyondFive_1:
add byte [scorecount], 2
call updateScore
mov byte[sound],'c'
call soundeffect

sub di, 162 ; Bring to top left of 3x3 grid box
mov ah, byte [textAttribute]
mov al, 0xDA ; Top left edge
mov word [es:di], ax  
mov al, 0xC4 ; Horizontal dash
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 160
mov al, 0xBF ; Top right edge
mov word [es:di], ax
sub di, 2
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
sub di, 2
mov al, 0xC0 ; Bottom left edge
mov word [es:di], ax
add di, 160
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
add di, 2
mov word [es:di], ax
mov al, 0xD9 ; Bottom right edge
add di, 2
mov word [es:di], ax
jmp exit_five

exit_five_1:
    mov byte[sound],'w'
    call soundeffect
inc byte [mistakes]
call updateMistakes
exit_five:
pop bx
pop di
pop ax
ret

; Number 6
six:
push ax
push di
push bx

mov ax, word [es:di]
cmp al, '-'
jnz beyondSix_2

mov ax, 0
mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl
sub al, 1
add al, byte [gridColumn]

mov bx, finalGrid_1
add bx, ax
cmp byte [bx], 6
jnz exit_six_1

mov bx, realTimeGrid
add bx, ax
mov byte [bx], 6
jmp beyondSix_1

beyondSix_2:
jmp exit_six

beyondSix_1:
add byte [scorecount], 2
call updateScore
mov byte[sound],'c'
call soundeffect

sub di, 162 ; Bring to top left of 3x3 grid box
mov ah, byte [textAttribute]
mov al, 0xDA ; Top left edge
mov word [es:di], ax  
mov al, 0xC4 ; Horizontal dash
add di, 2
mov word [es:di], ax
add di, 2
mov word [es:di], ax
add di, 160
mov al, 0xBF ; Top right edge
mov word [es:di], ax
sub di, 2
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
sub di, 2
mov al, 0xC3 ; Left up/down double edge
mov word [es:di], ax
add di, 160
mov al, 0xC0 ; Bottom left edge
mov word [es:di], ax
mov al, 0xC4 ; Horizontal dash
add di, 2
mov word [es:di], ax
mov al, 0xD9 ; Bottom right edge
add di, 2
mov word [es:di], ax
jmp exit_six

exit_six_1:
    mov byte[sound],'w'
    call soundeffect
inc byte [mistakes]
call updateMistakes
exit_six:
pop bx
pop di
pop ax
ret

; Number 7
seven:
push ax
push di
push bx

mov ax, word [es:di]
cmp al, '-'
jnz sevenInt_123

mov ax, 0
mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl
sub al, 1
add al, byte [gridColumn]

mov bx, finalGrid_1
add bx, ax
cmp byte [bx], 7
jnz exit_seven_1

mov bx, realTimeGrid
add bx, ax
mov byte [bx], 7

add byte [scorecount], 2
call updateScore
mov byte[sound],'c'
call soundeffect
jmp sevenInt_456

sevenInt_123:
jmp exit_seven

sevenInt_456:
sub di, 162 ; Bring to top left of 3x3 grid box
mov ah, byte [textAttribute]
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax  
add di, 2
mov word [es:di], ax
add di, 2
mov al, 0xBF ; Top right edge
mov word [es:di], ax
add di, 160
mov al, 0xB3 ; Vertical dash
mov word [es:di], ax
add di, 160
mov word [es:di], ax
sub di, 162
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
sub di, 2
mov word [es:di], ax
jmp exit_seven

exit_seven_1:
    mov byte[sound],'w'
    call soundeffect
inc byte [mistakes]
call updateMistakes

exit_seven:
pop bx
pop di
pop ax
ret

; Number 8
eight:
push ax
push di
push bx

mov ax, word [es:di]
cmp al, '-'
jnz eightInterval_2

mov ax, 0
mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl
sub al, 1
add al, byte [gridColumn]

mov bx, finalGrid_1
add bx, ax
cmp byte [bx], 8
jnz exit_eight_1

mov bx, realTimeGrid
add bx, ax
mov byte [bx], 8
jmp beyondEight_1

eightInterval_2:
jmp exit_eight

beyondEight_1:
add byte [scorecount], 2
call updateScore
mov byte[sound],'c'
call soundeffect
sub di, 162 ; Bring to top left of 3x3 grid box
mov ah, byte [textAttribute]
mov al, 0xDA ; Top left edge
mov word [es:di], ax  
mov al, 0xC4 ; Horizontal dash
add di, 2
mov word [es:di], ax
mov al, 0xBF ; Top right edge
add di, 2
mov word [es:di], ax
add di, 160
mov al, 0xB4 ; Right up/down double edge
mov word [es:di], ax
sub di, 2
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
sub di, 2
mov al, 0xC3 ; Left up/down double edge
mov word [es:di], ax
add di, 160
mov al, 0xC0 ; Bottom left edge
mov word [es:di], ax
mov al, 0xC4 ; Horizontal dash
add di, 2
mov word [es:di], ax
mov al, 0xD9 ; Bottom right edge
add di, 2
mov word [es:di], ax
jmp exit_eight

exit_eight_1:
mov byte[sound],'w'
call soundeffect
inc byte [mistakes]
call updateMistakes

exit_eight:
pop bx
pop di
pop ax
ret

; Number 9
nine:
push ax
push di
push bx

mov ax, word [es:di]
cmp al, '-'
jnz beyondNine_2

mov ax, 0
mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl
sub al, 1
add al, byte [gridColumn]

mov bx, finalGrid_1
add bx, ax
cmp byte [bx], 9
jnz exit_nine_1

mov bx, realTimeGrid
add bx, dx
mov byte [bx], 9
jmp beyondNine_1

beyondNine_2:
jmp exit_nine

beyondNine_1:
add byte [scorecount], 2
call updateScore
mov byte[sound],'c'
call soundeffect

sub di, 162 ; Bring to top left of 3x3 grid box
mov ah, byte [textAttribute]
mov al, 0xDA ; Top left edge
mov word [es:di], ax  
mov al, 0xC4 ; Horizontal dash
add di, 2
mov word [es:di], ax
mov al, 0xBF ; Top right edge
add di, 2
mov word [es:di], ax
add di, 160
mov al, 0xB4 ; Right up/down double edge
mov word [es:di], ax
sub di, 2
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
sub di, 2
mov al, 0xC0 ; Bottom left edge
mov word [es:di], ax
add di, 160
mov al, 0xC4 ; Horizontal dash
mov word [es:di], ax
add di, 2
mov word [es:di], ax
mov al, 0xD9 ; Bottom right edge
add di, 2
mov word [es:di], ax
jmp exit_nine

exit_nine_1:
mov byte[sound],'w'
call soundeffect
inc byte [mistakes]
call updateMistakes

exit_nine:
pop bx
pop di
pop ax
ret

; Big number subroutines ends here------------------------------->


;-----------------------------subroutines to print big number ends here------------------>

;-----------------------------Subroutine to print notes inside grid begins here---------->

;-----------------------------operations in notes begin here
upArrowNotes:
push es
push ax
push bx

cmp byte [gridRow], 1
jnz upSuccess_1
cmp byte [notesRow], 1
jz upInterval_1 ; If already at top, ignore key press
upSuccess_1:
mov ax, word [es:di] ; Check current character
cmp al, '-'
jnz upSpace_1 ; It was blank space (blinking cursor)
mov al, 0x20            
and ah, 01111111b ; End blinking
mov word [es:di], ax ; So, overwrite blank space
jmp upOverwriteDone
upSpace_1: ; It was a blinking number
and ah, 01111111b ; So, just end the blinking
mov word [es:di], ax
upOverwriteDone:
cmp byte [gridRow], 6
jnz upSuccess_2
cmp byte [notesRow], 1
jz notesScrollUp
upSuccess_2:
cmp byte [notesRow], 1
jnz upManyLabels_1
sub di, 320
mov byte [notesRow], 3
dec byte [gridRow]
jmp comparisonUp_1
upManyLabels_1:
sub di, 160 ; Move to next location
dec byte [notesRow]
comparisonUp_1:
mov ax, word [es:di] ; Check current character
cmp al, 0x20 ; Check if blank space
jnz upNumPresent
mov al, '-'
or ah, 10000000b ; Turn on blinking
mov word [es:di], ax ; Overwrite cursor on blank space
jmp exit_upArrowNotes_1          
upNumPresent:
or ah, 10000000b ; Turn on blinking
mov word [es:di], ax ; Just start blinking number
jmp exit_upArrowNotes_1

upInterval_1:
jmp exit_upArrowNotes_1

notesScrollUp:
mov bx, 1000h
add bx, 480
sub bx, di ; To get space from the right
mov di, 4000 ; Move to end of page 0
sub di, 640 ; Move to end of last row of upper grid (grid 5th row)
sub di, bx ; Move to repective position of last row of upper grid (grid 5th row)
mov byte [notesRow], 3
dec byte [gridRow]

; Switch back to Page 0
mov ah, 05h ; BIOS function to set video page
mov al, 00h ; Select Page 0
int 10h ; Execute the BIOS interrupt to change the page
mov byte [currentPage], 0
jmp comparisonUp_1


exit_upArrowNotes_1:
pop bx
pop ax
pop es
ret

downArrowNotes:
push es
push ax
push bx

cmp byte [gridRow], 9
jnz downSuccess_1
cmp byte [notesRow], 3
jz downInterval_1 ; If already at bottom, ignore key press
downSuccess_1:
mov ax, word [es:di] ; Check current character
cmp al, '-'
jnz downSpace_1 ; It was blank space (blinking cursor)
mov al, 0x20            
and ah, 01111111b ; End blinking
mov word [es:di], ax ; So, overwrite blank space
jmp downOverwriteDone
downSpace_1: ; It was a blinking number
and ah, 01111111b ; So, just end the blinking
mov word [es:di], ax
downOverwriteDone:
cmp byte [gridRow], 5
jnz downSuccess_2
cmp byte [notesRow], 3
jz notesScrollDown
downSuccess_2:
cmp byte [notesRow], 3
jnz downManyLabels_1
add di, 320
mov byte [notesRow], 1
inc byte [gridRow]
jmp comparisonDown_1
downManyLabels_1:
add di, 160  
inc byte [notesRow]  
comparisonDown_1:
mov ax, word [es:di] ; Check current character
cmp al, 0x20 ; Check if blank space
jnz DownNumPresent
mov al, '-'
or ah, 10000000b ; Turn on blinking
mov word [es:di], ax ; Overwrite cursor on blank space
jmp exit_downArrowNotes_1          
DownNumPresent:
or ah, 10000000b ; Turn on blinking
mov word [es:di], ax ; Just start blinking number
jmp exit_downArrowNotes_1

downInterval_1:
jmp exit_downArrowNotes_1

notesScrollDown:
mov bx, di
sub bx, 3200 ; To get space from the left
mov di, 1000h ; Move to start of page
add di, 320 ; Move to start of 1st row of the grid
add di, bx ; Move to respective position of 1st row
mov byte [notesRow], 1
inc byte [gridRow]

; Switch back to Page 1
mov ah, 05h ; BIOS function to set video page
mov al, 01h ; Select Page 1
int 10h ; Execute the BIOS interrupt to change the page
mov byte [currentPage], 1
jmp comparisonDown_1


exit_downArrowNotes_1:
pop bx
pop ax
pop es
ret

leftArrowNotes:
push es
push ax
push bx

cmp byte [gridColumn], 1
jnz leftSuccess_1
cmp byte [notesColumn], 1
jz exit_leftArrowNotes ; If already at left edge, ignore key press
leftSuccess_1:
mov ax, word [es:di] ; Check current character
cmp al, '-'
jnz leftSpace_1 ; It was blank space (blinking cursor)
mov al, 0x20            
and ah, 01111111b ; End blinking
mov word [es:di], ax ; So, overwrite blank space
jmp leftOverwriteDone
leftSpace_1: ; It was a blinking number
and ah, 01111111b ; So, just end the blinking
mov word [es:di], ax
leftOverwriteDone:
cmp byte [notesColumn], 1
jnz leftSuccess_2
mov byte [notesColumn], 3
sub di, 4
dec byte [gridColumn]
jmp comparisonLeft_1
leftSuccess_2:
sub di, 2 ; Move to next location
dec byte [notesColumn]
comparisonLeft_1:
mov ax, word [es:di] ; Check current character
cmp al, 0x20 ; Check if blank space
jnz leftNumPresent
mov al, '-'
or ah, 10000000b ; Turn on blinking
mov word [es:di], ax ; Overwrite cursor on blank space
jmp exit_leftArrowNotes          
leftNumPresent:
or ah, 10000000b ; Turn on blinking
mov word [es:di], ax ; Just start blinking number

exit_leftArrowNotes:
pop bx
pop ax
pop es
ret

rightArrowNotes:
push es
push ax
push bx

cmp byte [gridColumn], 9
jnz rightSuccess_1
cmp byte [notesColumn], 3
jz exit_rightArrowNotes ; If already at left edge, ignore key press
rightSuccess_1:
mov ax, word [es:di] ; Check current character
cmp al, '-'
jnz rightSpace_1 ; It was blank space (blinking cursor)
mov al, 0x20            
and ah, 01111111b ; End blinking
mov word [es:di], ax ; So, overwrite blank space
jmp rightOverwriteDone
rightSpace_1: ; It was a blinking number
and ah, 01111111b ; So, just end the blinking
mov word [es:di], ax
rightOverwriteDone:
cmp byte [notesColumn], 3
jnz rightSuccess_2
mov byte [notesColumn], 1
add di, 4
inc byte [gridColumn]
jmp comparisonRight_1
rightSuccess_2:
add di, 2 ; Move to next location
inc byte [notesColumn]
comparisonRight_1:
mov ax, word [es:di] ; Check current character
cmp al, 0x20 ; Check if blank space
jnz rightNumPresent
mov al, '-'
or ah, 10000000b ; Turn on blinking
mov word [es:di], ax ; Overwrite cursor on blank space
jmp exit_rightArrowNotes          
rightNumPresent:
or ah, 10000000b ; Turn on blinking
mov word [es:di], ax ; Just start blinking number

exit_rightArrowNotes:
pop bx
pop ax
pop es
ret

oneNotesPrint:
push es
push ax

mov ax, word [es:di]
cmp al, '-'
jnz exit_oneNotes

mov ax, 0
mov dx, 0
mov al, byte [gridRow]
sub al, 1
mov bl, 9
mul bl
sub al, 1
mov dl, al
mov ax, 0
mov al, 1
;push ax
;call notesRowCheck
add al, byte [gridColumn]
mov bx, finalGrid_1
add bx, ax
cmp byte [bx], 1
jnz exit_one_1
mov bx, realTimeGrid
add bx, ax
mov byte [bx], 1

mov al, 0x31  
mov ah, byte [textAttribute]          
and ah, 01111111b ; End blinking
mov word [es:di], ax ; So, overwrite blank space with one


exit_oneNotes:
pop ax
pop es
ret

twoNotesPrint:

threeNotesPrint:

fourNotesPrint:

fiveNotesPrint:

sixNotesPrint:

sevenNotesPrint:


eightNotesPrint:

nineNotesPrint:


;-----------------------------operations in notes end here

;----------------------------Checks in notes begin here
EnableNotes:
push bp
mov bp, sp
push dx
push bx
push es
push ax
push cx
push si
push di

mov ax, 0xb800
mov es, ax
notesInput:
mov ax, 0
int 0x16
cmp ah, 0x48 ; Check for Up Arrow
jz upNotes
cmp ah, 0x50 ; Check for Down Arrow
jz downNotes
cmp ah, 0x4B ; Check for Left Arrow
jz leftNotes
cmp ah, 0x4D ; Check for Right Arrow
jz rightNotes
cmp al, 0x31 ; Number 1 input
jz oneNotes
cmp al, 0x32 ; Number 2 input
jz twoNotes
cmp al, 0x33 ; Number 3 input
jz threeNotes
cmp al, 0x34 ; Number 4 input
jz fourNotes
cmp al, 0x35 ; Number 5 input
jz fiveNotes
cmp al, 0x36 ; Number 6 input
jz sixNotes
cmp al, 0x37 ; Number 7 input
jz sevenNotes
cmp al, 0x38 ; Number 8 input
jz eightNotes
cmp al, 0x39 ; Number 9 input
jz nineNotes
cmp al, 0x75 ; u for Undo
;jz undoMove ; ------------------------------------------------------->?????????????????/
cmp al, 0x6D ; m key to disable notes
;jz disableNotes_2
jmp notesInput

upNotes:
call upArrowNotes
jmp notesInput

downNotes:
call downArrowNotes
jmp notesInput

leftNotes:
call leftArrowNotes
jmp notesInput

rightNotes:
call rightArrowNotes
jmp notesInput

oneNotes:
call oneNotesPrint
jmp notesInput

twoNotes:
call twoNotesPrint
jmp notesInput

threeNotes:
call threeNotesPrint
jmp notesInput

fourNotes:
call fourNotesPrint
jmp notesInput

fiveNotes:
call fiveNotesPrint
jmp notesInput

sixNotes:
call sixNotesPrint
jmp notesInput

sevenNotes:
call sevenNotesPrint
jmp notesInput

eightNotes:
call eightNotesPrint
jmp notesInput

nineNotes:
call nineNotesPrint
jmp notesInput

disableNotes_2:
mov byte [notesStatus], 0
exit_EnableNotes:
pop di
pop si
pop cx
pop ax
pop es
pop bx
pop dx
pop bp
ret

; subroutine to clear the screen
clrscre: push es
push ax
push di

    mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 0 ; point di to top left column
nextloce: mov word [es:di], 0x3020 ; clear next char on screen
add di, 2 ; move to next screen location
cmp di, 4000 ; has the whole screen cleared
jne nextloce ; if no clear next position
pop di
pop ax
pop es
ret

sleep: 
	push cx
	mov cx, 0xffff
	delay: loop delay
	pop cx
	ret

; Subroutine to print ASCII art
; Takes address of string and number of lines as parameters
printart:
    push bp
    mov bp, sp
    push es
    push ax
    push cx
    push si
    push di
    
    mov ax, 0xb800
    mov es, ax ; point es to video base
    mov si, [bp+6] ; point si to string
    mov cx, [bp+4] ; load number of lines
    mov di, 0 ; point di to top left column
    
nextline:
    call sleep
    call sleep

    push cx ; save outer loop counter
    mov cx, 57 ; length of each line
    
nextchar:
    
    mov al, [si] ; load next char of string
    mov ah, 0x30 ; black text on cyan background
    mov [es:di], ax ; show this char on screen
    add di, 2 ; move to next screen location
    add si, 1 ; move to next char
    loop nextchar ; repeat for each char in line
    
    pop cx ; restore outer loop counter
    loop nextline ; repeat for each line
    
    pop di
    pop si
    pop cx
    pop ax
    pop es
    pop bp
    ret 4

;----------------------------Checks in notes end here

;----------------------------Disabling of notes begin here


;----------------------------Disabling of notes end here

;-----------------------------Subroutine to print notes inside grid ends here---------->

;--------------------------------------------------------------------------------------------------Overwrite Part ends here--------------------------------------------------->

;-------------------------------------------------------------------start------------------------------------------->
;-------------------------------------------------------------------start------------------------------------------->
start:
;------------------------------------------------------background setting for display screen--->
mov ax, 0 ; Push value of di for page 0
push ax
mov ax, 0x70 ; dark black on white attribute
push ax
mov ax, [textAttribute] ; dark black on cyan attribute
push ax
call clrscr ; call the clrscr subroutine


;------------------------------------------------------Display Screen-------------------------->
mov ax, 0x70 ; dark black on white attribute
push ax
mov ax, 0
push ax ; push x position
mov ax, 0
push ax ; push y position
mov ax, [textAttribute] ; dark black on cyan attribute
push ax ; push attribute
call printstring ; call the printstr subroutine
call soundeffect

mov ax, 0
int 0x16

;------------------------------------------------------Display Screen Cursor movements--------->

call cursordmovement

;------------------------------------------------------background setting for page 0----------->
mov ax, 0 ; Push value of di for page 0
push ax
mov ax, 0x70 ; dark black on white attribute
push ax
mov ax, 0x30 ; dark black on cyan attribute
push ax
call clrscr

; Prepare Page 0 (Top 5 Rows)----------------------------->
mov ah, 0x05 ; Set active display page
mov al, 0x00 ; Select Page 0
int 0x10

; Procedure to draw rows 1–5
mov ax, position
push ax
mov ax, l11
push ax
mov ax, l10
push ax
mov ax, l9
push ax
mov ax, l8
push ax
mov ax, l7
push ax
mov ax, l6
push ax
mov ax, l5
push ax
mov ax, l4
push ax
mov ax, l3
push ax
mov ax, l2
push ax
mov ax, l1
push ax ; [bp+20]
mov ax, i1
push ax
mov ax, numprint
push ax
mov ax, 0
push ax ; push x position
mov ax, 0
push ax ; push y position
mov ax, 0x78 ; Light black on white attribute
push ax
mov ax, 0x38 ; Light black on cyan attribute
push ax ; push attribute
mov ax, 0x70 ; dark black on white attribute
push ax
mov ax, 0x30 ; dark black on cyan attribute
push ax ; push attribute
call page1_Upper5 ; call the printstr subroutine
 
   ;xor ax, ax
 ;mov es, ax ; point es to IVT base
 ;cli ; disable interrupts
 ;mov word [es:8*4], timer_isr; store offset at n*4
 ;mov [es:8*4+2], cs ; store segment at n*4+2
 ;sti ; enable interrupts
 ;mov dx, start ; end of resident portion
 ;add dx, 15 ; round up to next para
 ;mov cl, 4
 ;shr dx, cl ; number of paras
 ;mov ax, 0x3100 ; terminate and stay resident
 ;int 0x21

mov ax, 0
int 0x16

;timer=========================
              xor  ax, ax 
              mov  es, ax             ; point es to IVT base 
              cli                     ; disable interrupts 
              mov  word [es:8*4], stimer; store offset at n*4 
              mov  [es:8*4+2], cs     ; store segment at n*4+2 
              sti                     ; enable interrupts 
 
              mov  dx, start          ; end of resident portion 
              add  dx, 15             ; round up to next para 
              mov  cl, 4 
              shr  dx, cl             ; number of paras 

; Prepare Page 1 (Bottom 4 Rows)----------------------------------->
mov ah, 0x05 ; Set active display page
mov al, 0x01 ; Select Page 1
int 0x10

mov ax, 0x1000 ; Push value of di for page 1
push ax
mov ax, 0x70 ; dark black on white attribute
push ax
mov ax, 0x30 ; dark black on cyan attribute
push ax
call clrscr ; call the clrscr subroutine

mov ax, 0
int 0x16

; Procedure to draw rows 6–9
mov ax, l11
push ax ; [bp+40]          
mov ax, l10
push ax
mov ax, l9
push ax
mov ax, l8
push ax
mov ax, l7
push ax
mov ax, l6
push ax ; [bp+30]
mov ax, l5
push ax
mov ax, l4
push ax
mov ax, l3
push ax
mov ax, l2
push ax
mov ax, l1
push ax ; [bp+20]
mov ax, i1
push ax
mov ax, numprint
push ax
mov ax, 0
push ax ; push x position (bp+14)
mov ax, 0
push ax ; push y position (bp+12)
mov ax, 0x78 ; Light black on white attribute
push ax
mov ax, 0x38 ; Light black on cyan attribute
push ax ; push attribute
mov ax, 0x70 ; dark black on white attribute
push ax
mov ax, 0x30 ; dark black on cyan attribute
push ax ; push attribute
call page2_Lower4

mov ah, 0x00
int 0x16

; Switch back to Page 0
mov ah, 05h ; BIOS function to set video page
mov al, 00h ; Select Page 0
int 10h ; Execute the BIOS interrupt to change the page

; Set cursor positions ----------------------------------->
mov ah, byte [currentPage]
cmp ah, 0
jz skipThis_1
mov di, 0x1000
jmp setCursor
skipThis_1:
mov di, 0
setCursor:
add di, 524 ; To move di to centre of first box
mov ax, 0xb800
mov es, ax
mov ax, word [es:di]
cmp al, 0x20
jz cursorPossible_1
or ah, 10000000b ; Turn on blinking
mov word [es:di], ax ; Just start blinking number
jmp cursorMovement
cursorPossible_1:
mov al, '-'
mov ah, byte [textAttribute]
or ah, 10000000b ; Turn on blinking
mov word [es:di], ax
cursorMovement:

mov ah, 0x00
int 0x16 ; ah has scan code and al has ASCII codes
cmp ah, 0x48 ; Check for Up Arrow
jz up
cmp ah, 0x50 ; Check for Down Arrow
jz down
cmp ah, 0x4B ; Check for Left Arrow
jz left
cmp ah, 0x4D ; Check for Right Arrow
jz right
cmp al, 0x31 ; Number 1 input
jz oneCheck

cmp al, 0x32 ; Number 2 input
jz twoCheck
cmp al, 0x33 ; Number 3 input
jz threeCheck
cmp al, 0x34 ; Number 4 input
jz fourCheck
cmp al, 0x35 ; Number 5 input
jz fiveCheck
cmp al, 0x36 ; Number 6 input
jz sixCheck
cmp al, 0x37 ; Number 7 input
jz sevenCheck
cmp al, 0x38 ; Number 8 input
jz eightCheck
cmp al, 0x39 ; Number 9 input
jz nineCheck
cmp al, 0x6E ; n key pressed to enable notes
jz notesEnable
jmp cursorMovement

up:
mov al, byte [gridRow]
push ax
call upArrow
jmp cursorMovement

down:
mov al, byte [gridRow]
push ax
call downArrow
jmp cursorMovement

left:
mov al, byte [gridColumn]
push ax
call leftArrow
jmp cursorMovement

right:
mov al, byte [gridColumn]
push ax
call rightArrow
jmp cursorMovement

oneCheck:
call one
jmp cursorMovement

twoCheck:
call two
jmp cursorMovement

threeCheck:
call three
jmp cursorMovement

fourCheck:
call four
jmp cursorMovement

fiveCheck:
call five
jmp cursorMovement

sixCheck:
call six
jmp cursorMovement

sevenCheck:
call seven
jmp cursorMovement

eightCheck:
call eight
jmp cursorMovement

nineCheck:
call nine
jmp cursorMovement

notesEnable:
mov byte [notesStatus], 1
call EnableNotes
notesDisable:
;call disableNotes

    call clrscre ; clear the screen
    mov ax, art_message
    push ax ; push address of art message
    push word [art_lines] ; push number of lines
    call printart ; call the printart subroutine

mov ax, 0x4c00 ; terminate program
int 0x21