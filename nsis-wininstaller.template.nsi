; bigtest.nsi
;
; This script attempts to test most of the functionality of the NSIS exehead.

;--------------------------------
;Valores del instalador
!define PRODUCT_NAME "AlephERP"
!define PRODUCT_VERSION "1.3.$WCREV$"
!define PRODUCT_PUBLISHER "Aleph Sistemas de Informaci�n S.L."
!define PRODUCT_WEB_SITE "http://www.alephsistemas.es"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\alepherp.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

;--------------------------------
;Inclu�mos los templates modernos
!include "MUI.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"

;--------------------------------
;Con esta opci�n alertamos al usuario cuando pulsa el bot�n cancelar y le pedimos confirmaci�n para abortar
;la instalaci�n
;Esta macro debe colocarse en esta posici�n del script sino no funcionara
!define mui_abortwarning
!define MUI_ICON ".\src\alephLogoIcon.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

;--------------------------------

;Definimos el valor de la variable VERSION, en caso de no definirse en el script
;podria ser definida en el compilador
!define VERSION "1.3.$WCREV$"

; A continuaci�n mostramos las distintas p�ginas de que constar� nuestro instalador, 
; al estar usando el nuevo estilo de instalador usamos unas macros especiales:
;--------------------------------
;Pages

;Mostramos la p�gina de bienvenida 
!insertmacro MUI_PAGE_WELCOME 
;P�gina donde mostramos el contrato de licencia 
!insertmacro MUI_PAGE_LICENSE ".\licencia.txt" 
;p�gina donde se muestran las distintas secciones definidas 
!insertmacro MUI_PAGE_COMPONENTS 
;p�gina donde se selecciona el directorio donde instalar nuestra aplicacion 
!insertmacro MUI_PAGE_DIRECTORY 
;Pedimos los datos necesarios de configuraci�n
Page custom nsDialogsConfiguration nsDialogsConfigurationPageLeave
;Pedimos los datos espec�ficos de GMP
Page custom nsDialogsGMP nsDialogsGMPPageLeave
;p�gina de instalaci�n de ficheros 
!insertmacro MUI_PAGE_INSTFILES 
;p�gina final
!insertmacro MUI_PAGE_FINISH

;p�ginas referentes al desinstalador
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
  
;--------------------------------
;La siguiente macro define el idioma de los mensajes por defecto que se mostrara al usuario:
;Languages
!insertmacro MUI_LANGUAGE "Spanish"

;;;;;;;;;;;;;;;;;;;;;;;;;
; Configuraci�n General ;
;;;;;;;;;;;;;;;;;;;;;;;;;
;Nuestro instalador se llamara si la versi�n fuera la 1.0: Ejemplo-1.0-win32.exe
OutFile "${PRODUCT_NAME}-${VERSION}-win32.exe"

;Aqu� comprobamos que en la versi�n Inglesa se muestra correctamente el mensaje:
;Welcome to the $Name Setup Wizard
;Al tener reservado un espacio fijo para este mensaje, y al ser
;la frase en espa�ol mas larga:
; Bienvenido al Asistente de Instalaci�n de Aplicaci�n $Name
; no se ve el contenido de la variable $Name si el tama�o es muy grande
Name "${PRODUCT_NAME} ${VERSION}"
Caption "${PRODUCT_NAME} ${VERSION} - Sistemas de Gesti�n Empresarial"
Icon ".\src\alephLogoIcon.ico"

;Comprobacion de integridad del fichero activada
CRCCheck on

;Estilos visuales del XP activados
XPStyle on

;Indicamos cual ser� el directorio por defecto donde instalaremos nuestra
;aplicaci�n, el usuario puede cambiar este valor en tiempo de ejecuci�n.
InstallDir "$PROGRAMFILES\Aleph Sistemas de Informacion"

; Comprueba si el programa ha sido instalado previamente, y si es as�, toma esa
; direcci�n como direcci�n de instalaci�n
InstallDirRegKey HKCU "Software\Aleph Sistemas de Informacion\AlephERP\generales\ApplicationPath" "Install_Dir"

;Mensaje que mostraremos para indicarle al usuario que seleccione un directorio
DirText "Introduzca los par�metros de configuraci�n:"
;Indicamos que cuando la instalaci�n se complete no se cierre el instalador autom�ticamente
AutoCloseWindow false
;Mostramos todos los detalles del la instalaci�n al usuario.
ShowInstDetails show
;En caso de encontrarse los ficheros se sobreescriben
SetOverwrite on
;Optimizamos nuestro paquete en tiempo de compilaci�n, es altamente recomendable habilitar siempre esta opci�n
SetDatablockOptimize on
;Habilitamos la compresi�n de nuestro instalador
SetCompress auto
;Personalizamos el mensaje de desinstalaci�n
UninstallText "Este es el desinstalador de AlephERP."


; Di�logo que se crear� con nsDialogs
Var Dialog
; Controles que se crear�n dentro de ese di�logo
Var LabelHeader
Var LabelServer
Var TextServer
Var LabelDatabase
Var TextDatabase
Var LabelUser
Var TextUser
Var LabelPassword
Var TextPassword
Var LabelDBScheme
Var TextDBScheme
Var LabelSystemTablePrefix
Var TextSystemTablePrefix
Var LabelPort
Var TextPort
Var LabelIDTienda
Var TextIDTienda
Var CheckBoxValoresAnteriores

Var server
Var user
Var password
Var database
Var port
Var dbScheme
Var systemTablePrefix
Var idTienda
Var usarValoresAnterioresRegistro

Function nsDialogsConfiguration
	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}

	${NSD_CreateLabel} 0 0 100% 12u "Introduzca los par�metros de conexi�n y configuraci�n"
	Pop $LabelHeader

	${NSD_CreateLabel} 0 15u 20% 12u "Servidor"
	Pop $LabelServer

	${NSD_CreateText} 30% 15u 70% 12u "misevidor.com"
	Pop $TextServer

	${NSD_CreateLabel} 0 30u 20% 12u "Base de Datos"
	Pop $LabelDatabase

	${NSD_CreateText} 30% 30u 70% 12u "alepherp"
	Pop $TextDatabase

	${NSD_CreateLabel} 0 45u 20% 12u "Usuario DB"
	Pop $LabelUser

	${NSD_CreateText} 30% 45u 70% 12u "alepherp"
	Pop $TextUser

	${NSD_CreateLabel} 0 60u 20% 12u "Password DB"
	Pop $LabelPassword

	${NSD_CreateText} 30% 60u 70% 12u "alepherp"
	Pop $TextPassword

	${NSD_CreateLabel} 0 75u 20% 12u "Puerto DB"
	Pop $LabelPort

	${NSD_CreateText} 30% 75u 70% 12u "5432"
	Pop $TextPort

	${NSD_CreateLabel} 0 90u 20% 12u "Schema DB"
	Pop $LabelDBScheme

	${NSD_CreateText} 30% 90u 70% 12u "generic"
	Pop $TextDBScheme

	${NSD_CreateLabel} 0 105u 20% 12u "Prefijo de tablas"
	Pop $LabelSystemTablePrefix

	${NSD_CreateText} 30% 105u 70% 12u "alepherp"
	Pop $TextSystemTablePrefix

	${NSD_CreateCheckBox} 0 120u 100% 12u "Utilizar valores de una instalaci�n anterior"
	Pop $CheckBoxValoresAnteriores
	${NSD_SetState} $CheckBoxValoresAnteriores $usarValoresAnterioresRegistro

	nsDialogs::Show
FunctionEnd

Function nsDialogsConfigurationPageLeave
	${NSD_GetText} $TextServer $server
	${NSD_GetText} $TextDatabase $database
	${NSD_GetText} $TextUser $user
	${NSD_GetText} $TextPassword $password
	${NSD_GetText} $TextPort $port
	${NSD_GetText} $TextDBScheme $dbScheme
	${NSD_GetText} $TextSystemTablePrefix $systemTablePrefix
	${NSD_GetState} $CheckBoxValoresAnteriores $usarValoresAnterioresRegistro
FunctionEnd

Function nsDialogsGMP
	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}

	${NSD_CreateLabel} 0 0 100% 12u "Introduzca los par�metros de Tienda"
	Pop $LabelHeader

	${NSD_CreateLabel} 0 15u 20% 12u "ID. Tienda"
	Pop $LabelIDTienda

	${NSD_CreateText} 30% 15u 70% 12u "0"
	Pop $TextIDTienda
	
	nsDialogs::Show
FunctionEnd

Function nsDialogsGMPPageLeave
	${NSD_GetText} $TextIDTienda $idTienda
FunctionEnd

;Function WriteToFile
;	Exch $0 ;file to write to
;	Exch
;	Exch $1 ;text to write
;	 
;	FileOpen $0 $0 a #open file
;	FileSeek $0 0 END #go to end
;	FileWrite $0 $1 #write to file
;	FileClose $0
;	 
;	Pop $1
;	Pop $0
;FunctionEnd
 
;!macro WriteToFile NewLine File String
;	!if "${NewLine}" == true
;	Push "${String}$\r$\n"
;	!else
;	Push "${String}"
;	!endif
;	Push "${File}"
;	Call WriteToFile
;!macroend
;!define WriteToFile "!insertmacro WriteToFile false"
;!define WriteLineToFile "!insertmacro WriteToFile true"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Install settings                                                    ;
; En esta secci�n a�adimos los ficheros que forman nuestra aplicaci�n ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Section "AlephERP"
	Var /GLOBAL sourceFiles
	Var /GLOBAL PATH
	Var /GLOBAL PATH_ACCESO_DIRECTO
	Var /GLOBAL REGISTRY_PATH
	StrCpy $sourceFiles "."
	StrCpy $PATH "AlephERP"
	StrCpy $PATH_ACCESO_DIRECTO "AlephERP"
	StrCpy $REGISTRY_PATH "Aleph Sistemas de Informacion\AlephERP"
	SetOutPath $INSTDIR\$PATH

;	md5dll::GetMD5String "$idTienda"
;	Pop $0
;	StrCpy "$idTienda" "$0"
;	Push $0

;	${WriteToFile} "$INSTDIR\$PATH\qt.conf" "[Paths]$\r$\nPrefix=$INSTDIR\$PATH$\r$\nPlugins=plugins"
	
	!define SHELLFOLDERS \
		"Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
 
	ReadRegStr $0 HKCU "${SHELLFOLDERS}" AppData
	StrCmp $0 "" 0 +2
	ReadRegStr $0 HKLM "${SHELLFOLDERS}" "Common AppData"
	StrCmp $0 "" 0 +2
	StrCpy $0 "$WINDIR\Application Data"
  
	;Incluimos todos los ficheros que componen nuestra aplicaci�n
	File   ".\build\release\alepherp.exe"
	File   ".\build\release\jasperserver.dll"
	File   ".\build\release\daobusiness.dll"
	File   ".\build\release\config.dll"
	File   ".\build\release\qcodeedit.dll"
	File   ".\build\release\htmleditor.dll"
	File   ".\build\release\QtCore4.dll"
	File   ".\build\release\QtGui4.dll"
	File   ".\build\release\QtNetwork4.dll"
	File   ".\build\release\QtXml4.dll"
	File   ".\build\release\QtXmlPatterns4.dll"
	File   ".\build\release\QtWebKit4.dll"
	File   ".\build\release\QtScript4.dll"
	File   ".\build\release\QtScriptTools4.dll"
	File   ".\build\release\QtSql4.dll"
	File   ".\build\release\phonon4.dll"
	File   ".\build\release\libgcc_s_dw2-1.dll"
	File   ".\build\release\qt_es.qm"
	File   ".\build\release\mingwm10.dll"
	File   ".\build\release\libpq.dll"
	File   ".\build\release\ssleay32.dll"
	File   ".\build\release\libeay32.dll"
	File   ".\build\release\libintl-8.dll"
	File   ".\build\release\libiconv-2.dll"
	SetOutPath "$INSTDIR\$PATH\resources"
	File   ".\build\release\resources\alepherp.rcc"
	SetOutPath "$INSTDIR\$PATH\plugins\designer"
	File   ".\build\release\plugins\designer\dbcommonsplugin.dll"
	File   ".\build\release\plugins\designer\htmleditorplugin.dll"
	File   ".\build\release\plugins\designer\qcodeedit-plugin.dll"
	File   ".\build\release\plugins\designer\qwwrichtexteditplugin.dll"
	SetOutPath "$INSTDIR\$PATH\plugins\imageformats"
	File   ".\build\release\plugins\imageformats\qgif4.dll"
	File   ".\build\release\plugins\imageformats\qico4.dll"
	File   ".\build\release\plugins\imageformats\qmng4.dll"
	File   ".\build\release\plugins\imageformats\qjpeg4.dll"
	File   ".\build\release\plugins\imageformats\qsvg4.dll" 
	File   ".\build\release\plugins\imageformats\qtiff4.dll" 
	File   ".\build\release\plugins\imageformats\qtga4.dll" 
	SetOutPath "$INSTDIR\$PATH\plugins\script"
	File   ".\build\release\plugins\script\perpscriptextensionplugin.dll"
	File   ".\build\release\plugins\script\qtscript_core.dll"
	File   ".\build\release\plugins\script\qtscript_gui.dll"
	File   ".\build\release\plugins\script\qtscript_network.dll"
	File   ".\build\release\plugins\script\qtscript_opengl.dll"
	File   ".\build\release\plugins\script\qtscript_phonon.dll"
	File   ".\build\release\plugins\script\qtscript_sql.dll"
	File   ".\build\release\plugins\script\qtscript_sql.dll"
	File   ".\build\release\plugins\script\qtscript_uitools.dll"
	File   ".\build\release\plugins\script\qtscript_webkit.dll"
	File   ".\build\release\plugins\script\qtscript_xml.dll"
	File   ".\build\release\plugins\script\qtscript_xmlpatterns.dll"
	File   ".\build\release\plugins\script\scriptjasperserverplugin.dll"
	File   ".\build\release\plugins\script\openrptplugin.dll"
	SetOutPath "$INSTDIR\$PATH\plugins\sqldrivers"
	File   ".\build\release\plugins\sqldrivers\qsqlpsql4.dll"
	File   ".\build\release\plugins\sqldrivers\qsqlite4.dll"

	${If} $usarValoresAnterioresRegistro == ${BST_UNCHECKED}
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "servidor" $server
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "usuario" $user
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "password" $password
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "nombre" $database
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "codificacion" "UTF-8"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "esquema_bbdd" $dbScheme
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "port" $port
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "TipoConexion" "NATIVA"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "DSN_ODBC" ""
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "system_table_prefix" $systemTablePrefix
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\db" "filesystem_encoding" ""

	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\generales" "debuggerEnabled" "false"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\generales" "externalResource" "$INSTDIR\$PATH\resources\alepherp.rcc"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\generales" "PrimerDiaSemana" "monday"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\generales" "ultimoUsuarioLogado" ""
	WriteRegDWORD HKCU "SOFTWARE\$REGISTRY_PATH\generales" "LookAndFeel" 0x00000004
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\generales" "usarVisorInternoPDF" "false"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\generales" "visorPDF" "false"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\generales" "business" "gmp/value.txt"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\generales" "DirectorioTemporal" "$0\AlephERP"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\generales" "timeBetweenReloads" "30000"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\generales" "mdiTabView" "true"
	WriteRegStr HKCU "SOFTWARE\$REGISTRY_PATH\script" "idt" "$idTienda"
	${EndIf}
	CreateDirectory "$0\AlephERP"

	WriteRegStr HKLM "SOFTWARE\$REGISTRY_PATH" "Version" "${VERSION}"
	
SectionEnd

Section -Post
	WriteUninstaller "$INSTDIR\uninstall.exe"
	;Hacemos que la instalaci�n se realice para todos los usuarios del sistema
	SetShellVarContext all
	;Creamos los directorios, acesos directos y claves del registro que queramos...
	CreateDirectory "$SMPROGRAMS\$PATH_ACCESO_DIRECTO"
	CreateShortCut "$SMPROGRAMS\$PATH_ACCESO_DIRECTO\AlephERP.lnk" \
		   "$INSTDIR\$PATH\alepherp.exe"

	;Creamos tambi�n el aceso directo al instalador
	CreateShortCut "$SMPROGRAMS\$PATH_ACCESO_DIRECTO\Desinstalar.lnk" \
		   "$INSTDIR\uninstall.exe"

	WriteRegStr HKLM \
		SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$PATH \
		"DisplayName" "${PRODUCT_NAME} ${VERSION}"
	WriteRegStr HKLM \
		SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$PATH \
		"UninstallString" '"$INSTDIR\uninstall.exe"'


	WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\alepherp.exe"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME} - ${PRODUCT_VERSION}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\alepherp.exe"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Section Uninstall
	Delete   "$INSTDIR\alepherp.exe"
	Delete   "$INSTDIR\jasperserver.dll"
	Delete   "$INSTDIR\daobusiness.dll"
	Delete   "$INSTDIR\config.dll"
	Delete   "$INSTDIR\qcodeedit.dll"
	Delete   "$INSTDIR\htmleditor.dll"
	Delete   "$INSTDIR\QtCore4.dll"
	Delete   "$INSTDIR\QtGui4.dll"
	Delete   "$INSTDIR\QtNetwork4.dll"
	Delete   "$INSTDIR\QtXml4.dll"
	Delete   "$INSTDIR\QtXmlPatterns4.dll"
	Delete   "$INSTDIR\QtWebKit4.dll"
	Delete   "$INSTDIR\QtScript4.dll"
	Delete   "$INSTDIR\QtScriptTools4.dll"
	Delete   "$INSTDIR\QtSql4.dll"
	Delete   "$INSTDIR\phonon4.dll"
	Delete   "$INSTDIR\libgcc_s_dw2-1.dll"
	Delete   "$INSTDIR\qt_es.qm"
	Delete   "$INSTDIR\mingwm10.dll"
	Delete   "$INSTDIR\libpq.dll"
	Delete   "$INSTDIR\ssleay32.dll"
	Delete   "$INSTDIR\libeay32.dll"
	Delete   "$INSTDIR\libintl-8.dll"
	Delete   "$INSTDIR\libiconv-2.dll"
	Delete   "$INSTDIR\resources\alepherp.rcc"
	Delete   "$INSTDIR\plugins\designer\dbcommonsplugin.dll"
	Delete   "$INSTDIR\plugins\designer\htmleditorplugin.dll"
	Delete   "$INSTDIR\plugins\designer\qcodeedit-plugin.dll"
	Delete   "$INSTDIR\plugins\designer\qwwrichtexteditplugin.dll"
	Delete   "$INSTDIR\plugins\imageformats\qgif4.dll"
	Delete   "$INSTDIR\plugins\imageformats\qico4.dll"
	Delete   "$INSTDIR\plugins\imageformats\qgif4.dll"
	Delete   "$INSTDIR\plugins\imageformats\qgif4.dll"
	Delete   "$INSTDIR\plugins\imageformats\qgif4.dll" 
	Delete   "$INSTDIR\plugins\imageformats\qtiff4.dll" 
	Delete   "$INSTDIR\plugins\script\perpscriptextensionplugin.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_core.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_gui.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_network.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_opengl.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_phonon.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_sql.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_sql.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_uitools.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_webkit.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_xml.dll"
	Delete   "$INSTDIR\plugins\script\qtscript_xmlpatterns.dll"
	Delete   "$INSTDIR\plugins\script\scriptjasperserverplugin.dll"
	Delete   "$INSTDIR\plugins\sqldrivers\qsqlpsql4.dll"

	Delete "$SMPROGRAMS\$PATH_ACCESO_DIRECTO\AlephERP.lnk" 
	Delete "$SMPROGRAMS\$PATH_ACCESO_DIRECTO\Desinstalar.lnk"
	
	RMDir "$SMPROGRAMS\$PATH_ACCESO_DIRECTO"

	RMDir "$SMPROGRAMS\eXaro"
	RMDir "$INSTDIR\plugins\script"
	RMDir "$INSTDIR\plugins\sqldrivers"
	RMDir "$INSTDIR\plugins\imageformats"
	RMDir "$INSTDIR\plugins\designer"
	RMDir "$INSTDIR\plugins\resources"
	RMDir "$INSTDIR"

	DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
	DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"

	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\servidor"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\usuario"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\password"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\nombre"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\codificacion"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\esquema_bbdd"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\port"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\TipoConexion"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\DSN_ODBC"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\system_table_prefix"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\db\filesystem_encoding"

	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\generales\debuggerEnabled"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\generales\externalResource"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\generales\PrimerDiaSemana"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\generales\ultimoUsuarioLogado"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\generales\LookAndFeel"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\generales\usarVisorInternoPDF"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\generales\visorPDF"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\generales\business"
	DeleteRegKey HKCU "SOFTWARE\$REGISTRY_PATH\generales\DirectorioTemporal"

	SetAutoClose true
  
SectionEnd
