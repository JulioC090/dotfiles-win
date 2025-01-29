if (Get-Command code -ErrorAction SilentlyContinue) {
    $codeExtensions = Get-Content "$HOME\dotfiles\.vscode\extensions.txt" | Sort-Object
    $installedExtensions = code --list-extensions | Sort-Object
    $uninstalledExtensions = $codeExtensions | Where-Object { $_ -notin $installedExtensions }

    Write-Output "Checking for uninstalled VSCode extensions..."

    if ($uninstalledExtensions.Count -eq 0) {
        Write-Output "All good!"
    } else {
        Write-Output "Found $($uninstalledExtensions.Count) extensions to install."

        foreach ($extension in $uninstalledExtensions) {
            Write-Output "Installing $extension..."
            code --install-extension $extension
        }

        Write-Output "Done!"
    }
}