Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- AUTO-ADMINISTRADOR ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "VoltOS 2 - Professional Optimizer"
$form.Size = New-Object System.Drawing.Size(1150, 850)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$form.FormBorderStyle = "FixedSingle"

# --- TÍTULO ---
$title = New-Object System.Windows.Forms.Label
$title.Text = "VOLTOS 2: CONTROL PANEL"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::Cyan
$title.Location = New-Object System.Drawing.Point(380, 20)
$title.AutoSize = $true
$form.Controls.Add($title)

# --- PESTAÑAS ---
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(1080, 680)
$tabControl.Location = New-Object System.Drawing.Point(30, 90)

$nombres = @("Limpieza", "Juegos", "Internet", "Privacidad")
$tabs = @()

foreach ($n in $nombres) {
    $t = New-Object System.Windows.Forms.TabPage
    $t.Text = $n
    $t.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $tabControl.Controls.Add($t)
    $tabs += $t
}
$form.Controls.Add($tabControl)

# --- FUNCIÓN DE BOTONES ---
function Add-VoltAction($tab, $text, $x, $y, $cmd) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(240, 40)
    $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.FlatStyle = "Flat"
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $btn.Add_Click({
        try {
            Invoke-Expression $cmd
            [System.Windows.Forms.MessageBox]::Show("VoltOS: $text completado")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error")
        }
    })
    $tab.Controls.Add($btn)
}

# --- GENERAR 40 BOTONES POR TAB ---
foreach ($tab in $tabs) {
    $y = 20; $x = 20
    for ($i=1; $i -le 40; $i++) {
        $name = "$($tab.Text) #$i"
        $c = 'Write-Host "OK"'
        
        # Comandos de ejemplo para que sirvan
        if ($i -eq 1 -and $tab.Text -eq "Limpieza") { $name = "Borrar Temporales"; $c = 'del /s /f /q %temp%\*.*' }
        if ($i -eq 1 -and $tab.Text -eq "Juegos") { $name = "Prioridad GPU"; $c = 'reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v DirectXUserGlobalGPUPreference /t REG_DWORD /d 2 /f' }
        if ($i -eq 1 -and $tab.Text -eq "Internet") { $name = "DNS Flush"; $c = 'ipconfig /flushdns' }

        Add-VoltAction $tab $name $x $y $c
        $y += 50
        if ($y -gt 600) { $y = 20; $x += 260 }
    }
}

$form.ShowDialog()
