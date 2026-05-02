Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- AUTO-ADMINISTRADOR ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "VoltOS 1 - Fullscreen"
$form.WindowState = "Maximized"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)

# Obtener tamaño real de tu pantalla
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# --- BOTÓN CERRAR (ESQUINA) ---
$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "X"
$btnClose.Size = New-Object System.Drawing.Size(50, 40)
$btnClose.Location = New-Object System.Drawing.Point($screenWidth - 60, 10)
$btnClose.FlatStyle = "Flat"
$btnClose.ForeColor = [System.Drawing.Color]::White
$btnClose.BackColor = [System.Drawing.Color]::DarkRed
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

# --- TÍTULO ---
$title = New-Object System.Windows.Forms.Label
$title.Text = "VOLTOS 1: ULTIMATE FULLSCREEN EXPERIENCE"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 30, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::Cyan
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(($screenWidth / 2) - 400, 40)
$form.Controls.Add($title)

# --- PESTAÑAS GIGANTES ---
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size($screenWidth - 100, $screenHeight - 250)
$tabControl.Location = New-Object System.Drawing.Point(50, 150)

$tab1 = New-Object System.Windows.Forms.TabPage
$tab1.Text = "Deshabilitar Cosas Innecesarias"
$tab1.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)

$tab2 = New-Object System.Windows.Forms.TabPage
$tab2.Text = "Gráficos y Juegos"
$tab2.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)

$tabControl.Controls.Add($tab1)
$tabControl.Controls.Add($tab2)
$form.Controls.Add($tabControl)

# --- FUNCIÓN DE BOTONES ---
function Add-Action($tab, $text, $x, $y, $cmd) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(250, 45) # Botones más grandes
    $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.FlatStyle = "Flat"
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10)
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

# --- GENERAR 40 BOTONES (DISTRIBUIDOS) ---
$tabs = @($tab1, $tab2)
foreach ($tab in $tabs) {
    $yPos = 30
    $xPos = 30
    for ($i=1; $i -le 40; $i++) {
        $name = if ($tab -eq $tab1) { "Innecesario #$i" } else { "Gráficos #$i" }
        Add-Action $tab $name $xPos $yPos 'Write-Host "Ejecutado"'
        $yPos += 60 # Más espacio hacia abajo
        if ($yPos -gt ($tabControl.Height - 100)) { 
            $yPos = 30 
            $xPos += 280 # Salto de columna más ancho
        }
    }
}

$form.ShowDialog()