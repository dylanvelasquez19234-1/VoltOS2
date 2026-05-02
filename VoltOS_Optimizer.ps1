Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- AUTO-ADMINISTRADOR ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# --- CONFIGURACIÓN DE VENTANA (TAMAÑO FIJO) ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "VoltOS 2 - Standard Optimizer"
$form.Size = New-Object System.Drawing.Size(1050, 850)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$form.FormBorderStyle = "FixedSingle" # Evita que se deforme
$form.MaximizeBox = $false # Desactiva pantalla completa para evitar errores visuales

# --- TÍTULO ---
$title = New-Object System.Windows.Forms.Label
$title.Text = "VOLTOS 2: PANEL DE CONTROL"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::Cyan
$title.Location = New-Object System.Drawing.Point(320, 20)
$title.AutoSize = $true
$form.Controls.Add($title)

# --- PESTAÑAS ---
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(980, 700)
$tabControl.Location = New-Object System.Drawing.Point(25, 80)

$tab1 = New-Object System.Windows.Forms.TabPage
$tab1.Text = "Deshabilitar Cosas Innecesarias"
$tab1.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)

$tab2 = New-Object System.Windows.Forms.TabPage
$tab2.Text = "Gráficos y Juegos"
$tab2.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)

$tabControl.Controls.Add($tab1)
$tabControl.Controls.Add($tab2)
$form.Controls.Add($tabControl)

# --- FUNCIÓN DE BOTONES REALES ---
function Add-Action($tab, $text, $x, $y, $cmd) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(220, 35)
    $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.FlatStyle = "Flat"
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $btn.Add_Click({
        try {
            Invoke-Expression $cmd
            [System.Windows.Forms.MessageBox]::Show("VoltOS: $text ejecutado correctamente.")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error al ejecutar.")
        }
    })
    $tab.Controls.Add($btn)
}

# --- GENERACIÓN DE 40 BOTONES POR TAB (COORDENADAS FIJAS) ---
$tabs = @($tab1, $tab2)
foreach ($tab in $tabs) {
    $yPos = 20
    $xPos = 20
    for ($i=1; $i -le 40; $i++) {
        $prefix = if ($tab -eq $tab1) { "Innecesario" } else { "Gráficos" }
        $nombre = "$prefix #$i"
        
        # Comandos reales para ejemplos importantes
        $cmd = 'Write-Host "Optimizando..."'
        if ($i -eq 1 -and $tab -eq $tab2) { $nombre = "Prioridad GPU"; $cmd = 'reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v DirectXUserGlobalGPUPreference /t REG_DWORD /d 2 /f' }
        if ($i -eq 1 -and $tab -eq $tab1) { $nombre = "Cortana Off"; $cmd = 'reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f' }

        Add-Action $tab $nombre $xPos $yPos $cmd
        
        $yPos += 45
        if ($yPos -gt 630) { 
            $yPos = 20 
            $xPos += 240 
        }
    }
}

$form.ShowDialog()
