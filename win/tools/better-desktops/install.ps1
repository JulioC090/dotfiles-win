# Caminho do executável
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$exePath = Join-Path $scriptDir "desktops.exe"

# Caminho do atalho (Startup folder)
$startup = [Environment]::GetFolderPath("Startup")
$shortcutPath = Join-Path $startup "better-desktops.lnk"

# Criando o objeto WScript.Shell
$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)

# Definindo propriedades do atalho
$shortcut.TargetPath = $exePath
$shortcut.WorkingDirectory = $scriptDir
$shortcut.WindowStyle = 7
$shortcut.Description = "Atalho para iniciar o Better Desktop junto com o Windows"
$shortcut.Save()

Write-Output "Atalho criado em: $shortcutPath"
