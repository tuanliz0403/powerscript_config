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
$JAVA_COMPILER = Join-Path $myModulePath "JAVA.ps1"
$NAV = Join-Path $myModulePath "NAV.ps1"
$FILE_QUERY = Join-Path $myModulePath "FILE_QUERY.ps1"
$FILE_MANAGER = Join-Path $myModulePath "FILE_MANAGER.ps1"
$FUNCTIONS = Join-Path $myModulePath "FUNCTIONS.ps1"
$C_CPP_COMPILER = Join-Path $myModulePath "C_CPP.ps1"
$HASKELL_COMPILER = Join-Path $myModulePath "HASKELL.ps1"
$CALCULATOR = Join-Path $myModulePath "CALCULATOR.ps1"

. $INIT
. $FILE_QUERRY
. $FILE_MANAGER
. $NAV
. $FUNCTIONS
. $C_CPP_COMPILER
. $JAVA_COMPILER
. $CALCULATOR
. $HASKELL_COMPILER 

