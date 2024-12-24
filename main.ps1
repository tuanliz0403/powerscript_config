# Author : Pham Minh Tuan
# Contact : tuanliz0403@gmail.com
# ~~~IMPORTANT~~~
# This is my personal config. 
# I don't claim that the functions are better than the original ones. 
# It's your preference.
# ******************************************************************************

Get the config folder of different devices
$configPath = Split-Path -Parent $PROFILE
$myModulePath = Join-Path $configPath "MyModules"

$INIT = Join-Path $myModulePath "INIT.ps1"
$NAV = Join-Path $myModulePath "NAV.ps1"
$FILE_QUERRY = Join-Path $myModulePath "FILE_QUERRY.ps1"
$FILE_MANAGER = Join-Path $myModulePath "FILE_MANAGER.ps1"
$FUNCTIONS = Join-Path $myModulePath "FUNCTIONS.ps1"
$C_CPP_COMPILER = Join-Path $myModulePath "C_CPP.ps1"

# $INIT = "~\OneDrive\Documents\PowerShell\MyModules\INIT.ps1" 
# $FILE_QUERRY = "~\OneDrive\Documents\PowerShell\MyModules\FILE_QUERRY.ps1" 
# $NAV = "~\OneDrive\Documents\PowerShell\MyModules\NAV.ps1" 
# $FILE_MANAGER = "~\OneDrive\Documents\PowerShell\MyModules\FILE_MANAGER.ps1" 
# $FUNCTIONS = "~\OneDrive\Documents\PowerShell\MyModules\FUNCTIONS.ps1"
# $C_CPP_COMPILER = "~\OneDrive\Documents\PowerShell\MyModules\C_CPP.ps1"

. $INIT
. $FILE_QUERRY
. $FILE_MANAGER
. $NAV
. $FUNCTIONS
. $C_CPP_COMPILER

