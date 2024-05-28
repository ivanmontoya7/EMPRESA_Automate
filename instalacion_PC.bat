echo ASEGURATE DE ESTAR EJECUTANDOLO COMO ADMINISTRADOR!!
pause
::Crea un usuario Administrador y elimina el usuario por defecto
net user Administrador /active:yes
net user Usuario /delete
set /p usuario=Nombre del usuario que utilizara el PC:
::Añade la unidad de red P: para acceder a los archivos compartidos
net use P: \\XXX\Publico /persistent:yes
pause
::Ir a escritorio, hecho de dos formas para prevenir errores
cd C:\Users\%usuario%\Desktop
cd C:\Users\%usuario%\Escritorio
::Seleccionar que programa va a usar
set /p eleccion=programa o programa?
if "%eleccion%"=="programa" (copy "\\XXX\Publico\CPU\programa.rdp" "C:\Users\%usuario%\Desktop")
if "%eleccion%"=="programa" (copy \\XXX\Publico\CPU\programa.rdp C:\Users\%usuario%\Desktop)
copy \\XXX\Publico\CPU\CerrarSesion.rdp C:\Users\%usuario%\Desktop

::Desactiva el Control de Cuentas de Usuario
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f

::Los programas están en CPU
pushd \\XXX\Publico\CPU
echo TEN EN EL INSTALADOR DE APLICACION ACTUALIZADO EN MICROSOFT STORE
pause
::Abre el instalador de aplicación de la tienda de Windows
start ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1
::Ejecuta los instaladores de las aplicaciones
Programas.exe
echo Espera mientras se instalan los programas, al terminar pulsa enter
pause
::Configurar Forticlient, importa la configuración de la VPN automáticamente
copy \\XXX\Publico\CPU\vpn.conf C:\Program Files\Fortinet\FortiClient
cd C:\Program Files\Fortinet\FortiClient
FCConfig -m vpn -f vpn.conf -o import
::Totalmente opcional, que no se suspenda al cerrar la tapa
set /p portatil=Es portatil? (S/N):
if %portatil%=="S" powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
::Forzar directivas de grupo
gpupdate /force