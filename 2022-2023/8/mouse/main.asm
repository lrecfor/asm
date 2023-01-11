.686
.model flat, stdcall
option casemap:none

;----------------------------------------

include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\gdi32.inc
include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\msvcrt.inc

include Strings.mac

AppWindowName equ <"Application">

ED_1    equ    201     ;; ������������� �������� ���������� ����
ST_1    equ    202     ;; ������������� ������������ ����

.data

glChar dd 0

.data?

hIns HINSTANCE ?

HwndMainWindow HWND ?
HwndEdit1  HWND ?
HwndStatic1  HWND ?
glWindowMainWidth  ULONG ?
glWindowMainHeight ULONG ?

.const

format db "x = %d",13,10, "y = %d",0
format2 db "������ ����� ������ ���� � ����� (%d,%d)",13,10, 0

.code

CreateWindow proto c :vararg

RegisterClassMainWindow proto

CreateMainWindow proto

CreateControlWindowsMain proto hwnd:HWND

ProcessingSizeEvent proto hwnd:HWND, iMsg:UINT, wParam:WPARAM, lParam:LPARAM

InsertStringTailEdit proto str_:dword

WndProcMain proto hwnd:HWND, iMsg:UINT, wParam:WPARAM, lParam:LPARAM


WinMain proc stdcall hInstance:HINSTANCE, hPrevInstance:HINSTANCE, szCmdLine:PSTR, iCmdShow:DWORD

    local msg: MSG

    mov eax, [hInstance]
    mov [hIns], eax

    invoke CreateMainWindow
    mov [HwndMainWindow], eax
    .if [HwndMainWindow] == 0
        xor eax, eax
        ret
    .endif
	
    .while TRUE
        invoke GetMessage, addr msg, NULL, 0, 0
            .break .if eax == 0

        invoke TranslateMessage, addr msg
        invoke DispatchMessage, addr msg

    .endw

    mov eax, [msg].wParam
    ret

WinMain endp


RegisterClassMainWindow proc

    local WndClass:WNDCLASSEX	; ��������� ������

    ; ��������� ���� ���������
    mov WndClass.cbSize, sizeof (WNDCLASSEX)	; ������ ��������� ������
    mov WndClass.style, 0
    mov WndClass.lpfnWndProc, WndProcMain		; ����� ������� ��������� ������
    mov WndClass.cbClsExtra, 0
    mov WndClass.cbWndExtra, 0
    mov eax, [hIns]
    mov WndClass.hInstance, eax					; ��������� ����������
    invoke LoadIcon, hIns, $CTA0("MainIcon")	; ������ ����������
    mov WndClass.hIcon, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov WndClass.hCursor, eax
    invoke GetStockObject, BLACK_BRUSH			; ����� ��� ����
    mov WndClass.hbrBackground, eax
    mov WndClass.lpszMenuName, NULL
    mov WndClass.lpszClassName, $CTA0(AppWindowName)	; ��� ������
    invoke LoadIcon, hIns, $CTA0("MainIcon")
    mov WndClass.hIconSm, eax

    invoke RegisterClassEx, addr WndClass
    ret

RegisterClassMainWindow endp


CreateMainWindow proc

    local hwnd:HWND

    ; ����������� ������ ��������� ����
    invoke RegisterClassMainWindow

    ; �������� ���� ������������������� ������
    invoke CreateWindowEx, 
        WS_EX_CONTROLPARENT or WS_EX_APPWINDOW, ; ����������� ����� ����
        $CTA0(AppWindowName),	; ��� ������������������� ������ ����
        $CTA0("Mouse example"),	; ��������� ����
        WS_OVERLAPPEDWINDOW,	; ����� ����
        10,	    ; X-���������� ������ �������� ����
        10,	    ; Y-���������� ������ �������� ����
        650,    ; ������ ����
        650,    ; ������ ����
        NULL,   ; ��������� ������������� ����
        NULL,   ; ��������� �������� ���� (��� �������� ����)
        [hIns], ; ������������� ����������
        NULL
    mov [hwnd], eax
    
    .if [hwnd] == 0
        invoke MessageBox, NULL, $CTA0("������ �������� ��������� ���� ����������"), NULL, MB_OK
        xor eax, eax
        ret
    .endif
        
    invoke ShowWindow, hwnd, SW_SHOWNORMAL
    invoke UpdateWindow, hwnd
    
    mov eax, [hwnd]
    ret

CreateMainWindow endp


CreateControlWindowsMain proc hwnd:HWND
    invoke CreateWindowEx, NULL, $CTA0("edit"), NULL,
                            WS_CHILD or WS_VISIBLE or WS_VSCROLL or WS_HSCROLL or WS_BORDER or ES_LEFT or ES_MULTILINE or ES_AUTOVSCROLL or ES_AUTOHSCROLL or ES_READONLY,
                            0, 0,
                            0, 0,
                            hwnd, ED_1, hIns, NULL
    mov HwndEdit1, eax

    invoke CreateWindowEx, NULL, $CTA0("static"), NULL,
                            WS_CHILD or WS_VISIBLE or WS_BORDER or ES_NUMBER,
                            10, 10,
                            80, 40,
                            hwnd, ST_1, hIns, NULL
    mov HwndStatic1, eax

    invoke SetWindowText, HwndStatic1, $CTA0("static1")
    ret
CreateControlWindowsMain endp


ProcessingSizeEvent proc hwnd:HWND, iMsg:UINT, wParam:WPARAM, lParam:LPARAM
    local one:dword
    local two:dword
    local three:dword

    mov eax, lParam
    movzx ebx, ax
    mov glWindowMainWidth, ebx
    shr eax, 16
    mov glWindowMainHeight, eax

    xor eax, eax
    xor ebx, ebx

    mov eax, glWindowMainHeight
    sub eax, 120
    mov ebx, 2
    div ebx
    mov [three], eax
    add eax, 110
    mov [one], eax
    mov eax, [glWindowMainWidth]
    sub eax, 20
    mov [two], eax

    invoke MoveWindow, HwndEdit1,   ;; ��������� ������������� ����
               10,                                  ;; �-���������� ������ �������� ����
               [one],    ;; �-���������� ������ �������� ����
               [two],                ;; ������
               [three],          ;; ������
               1         ;; ���� ������������� �����������

	xor eax, eax
    xor ebx, ebx
    ret
ProcessingSizeEvent endp

InsertStringTailEdit proc str_:dword
    local offset_: dword

    ;; �������� ����� ������ � ������ ����
    invoke GetWindowTextLength, HwndEdit1
    mov [offset_], eax

    ;; ���������� ������ � ����� ������
    invoke SendMessage, HwndEdit1,EM_SETSEL,[offset_],[offset_]

    ;; �������� ������
    mov eax, [str_]
    invoke SendMessage, HwndEdit1,EM_REPLACESEL,0,str_

    ret
InsertStringTailEdit endp


WndProcMain proc hwnd:HWND, iMsg:UINT, wParam:WPARAM, lParam:LPARAM

    local hdc:HDC
    local pen:HPEN
    local ps:PAINTSTRUCT
    local buf[100]:dword
    local x:dword
    local y:dword

    .if [iMsg] == WM_CREATE
        invoke CreateControlWindowsMain, hwnd
        xor eax, eax
        ret
    .elseif [iMsg] == WM_SIZE
        invoke ProcessingSizeEvent, hwnd,iMsg,wParam,lParam
    .elseif [iMsg] == WM_DESTROY
        invoke PostQuitMessage, 0
        xor eax, eax
        ret
    .elseif [iMsg] == WM_MOUSEMOVE

            mov eax, lParam
            movzx ebx, ax
           
            ;invoke GET_X_LPARAM, lParam
            mov [x], ebx
            
            shr eax, 16
            ;invoke GET_Y_LPARAM, lParam
            mov [y], eax

            xor eax, eax
            xor ebx, ebx

            invoke crt_sprintf, addr buf, offset format,x,y

            invoke SetWindowText, HwndStatic1, addr buf
            xor eax, eax
            ret
    .elseif [iMsg] == WM_LBUTTONDOWN
            mov eax, lParam
            movzx ebx, ax
            ;invoke GET_X_LPARAM, lParam
            mov [x], ebx
            
            shr eax, 16
            ;invoke GET_Y_LPARAM, lParam
            mov [y], eax
            invoke crt_sprintf, addr buf, offset format2,x,y
            invoke InsertStringTailEdit, addr buf
            xor eax, eax
            xor ebx, ebx
            ret

     .elseif [iMsg] == WM_LBUTTONUP
            invoke InsertStringTailEdit, $CTA0("�������� ����� ������ ����\r\n")
            xor eax, eax
            ret

     .elseif [iMsg] == WM_LBUTTONDBLCLK
            invoke InsertStringTailEdit, $CTA0("������ ������ ����� ������ ����\r\n")
            xor eax, eax
            ret
    .elseif [iMsg] == WM_RBUTTONDOWN
            invoke InsertStringTailEdit, $CTA0("������ ������ ������ ����\r\n");
            xor eax, eax
            ret

    .elseif [iMsg] == WM_RBUTTONUP
            invoke InsertStringTailEdit, $CTA0("�������� ������ ������ ����\r\n");
            xor eax, eax
            ret
    .elseif [iMsg] == WM_RBUTTONDBLCLK
            invoke InsertStringTailEdit, $CTA0("������ ������ ������ ������ ����\r\n");
            xor eax, eax
            ret
        
    .endif
    
    invoke DefWindowProc, hwnd, iMsg, wParam, lParam
    ret

WndProcMain endp

end