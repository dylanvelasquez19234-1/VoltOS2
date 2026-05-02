Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- AUTO-ADMINISTRADOR ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "VoltOS 2 - Mega Optimizer 2026"
$form.Size = New-Object System.Drawing.Size(1200, 900)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
$form.FormBorderStyle = "FixedSingle"

# --- TÍTULO ---
$title = New-Object System.Windows.Forms.Label
$title.Text = "VOLTOS 2: ELITE CONTROL PANEL"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 26, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::Cyan
$title.Location = New-Object System.Drawing.Point(350, 20)
$title.AutoSize = $true
$form.Controls.Add($title)

# --- SISTEMA DE PESTAÑAS (4 APARTADOS) ---
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(1120, 720)
$tabControl.Location = New-Object System.Drawing.Point(30, 100)

$tabs = @()
$nombresTabs = "Limpieza de Sistema", "Graficos y Juegos", "Internet y Red", "Privacidad Pro"

foreach ($n in $nombresTabs) {
    $t = New-Object System.Windows.Forms.TabPage
    $t.Text = $n
    $t.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)
    $tabControl.Controls.Add($t)
    $tabs += $t
}
$form.Controls.Add($tabControl)

# --- FUNCIÓN DE BOTONES ---
function Add-Action($tab, $text, $x, $y, $cmd) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(240, 38)
    $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.FlatStyle = "Flat"
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $btn.Add_Click({
        try {
            Invoke-Expression $cmd
            [System.Windows.Forms.MessageBox]::Show("VoltOS: $text ejecutado.")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error en comando.")
        }
    })
    $tab.Controls.Add($btn)
}

# --- GENERACIÓN DE 160 BOTONES (40 por pestaña) ---
foreach ($tab in $tabs) {
    $yPos = 20
    $xPos = 20
    for ($i=1; $i -le 40; $i++) {
        $name = "$($tab.Text) #$i"
        $comando = 'Write-Host "Ejecutando..."'
        
        # COMANDOS REALES SEGÚN PESTAÑA
        if ($tab.Text -eq "Limpieza de Sistema") {
            if ($i -eq 1) { $name = "Borrar Temp"; $comando = 'del /s /f /q %temp%\*.*' }
            if ($i -eq 2) { $name = "Vaciar Papelera"; $comando = 'Clear-RecycleBin -Force -ErrorAction SilentlyContinue' }
            if ($i -eq 3) { $name = "Limpiar Prefetch"; $comando = 'del /s /f /q C:\Windows\Prefetch\*.*' }
        }
        if ($tab.Text -eq "Graficos y Juegos") {
            if ($i -eq 1) { $name = "Prioridad GPU"; $comando = 'reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v DirectXUserGlobalGPUPreference /t REG_DWORD /d 2 /f' }
            if ($i -eq 2) { $name = "Modo Juego On"; $comando = 'reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f' }
            if ($i -eq 3) { $name = "Limpiar Cache Roblox"; $comando = 'Remove-Item -Path "$env:LocalAppData\Roblox\logs" -Recurse -Force' }
        }
        if ($tab.Text -eq "Internet y Red") {
            if ($i -eq 1) { $name = "Flush DNS"; $comando = 'ipconfig /flushdns' }
            if ($i -eq 2) { $name = "Reset IP"; $comando = 'ipconfig /release; ipconfig /renew' }
            if ($i -eq 3) { $name = "Optimizar TCP"; $comando = 'netsh int tcp set global autotuninglevel=normal' }
        }
        if ($tab.Text -eq "Privacidad Pro") {
            if ($i -eq 1) { $name = "Cortana Off"; $comando = 'reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f' }
            if ($i -eq 2) { $name = "Telemetria Off"; $comando = 'sc config DiagTrack start= disabled; stop-service DiagTrack' }
        }

        Add-Action $tab $name $xPos $yPos $comando
        $yPos += 50
        if ($yPos -gt 630) { $yPos = 20; $xPos += 270 }
    }
}

$form.ShowDialog()
