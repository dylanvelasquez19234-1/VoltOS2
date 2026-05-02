Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- AUTO-ADMINISTRADOR ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$form = New-Object System.Windows.Forms.Form
$form.WindowState = "Maximized"
$form.FormBorderStyle = "None"
$form.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)

$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# --- BOTÓN CERRAR ---
$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "X"
$btnClose.Size = New-Object System.Drawing.Size(60, 40)
$btnClose.Location = New-Object System.Drawing.Point($screenWidth - 70, 10)
$btnClose.FlatStyle = "Flat"
$btnClose.ForeColor = [System.Drawing.Color]::White
$btnClose.BackColor = [System.Drawing.Color]::DarkRed
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

# --- PESTAÑAS GIGANTES (ESTO ES LO QUE FALLABA) ---
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size($screenWidth - 100, $screenHeight - 200)
$tabControl.Location = New-Object System.Drawing.Point(50, 120)

$tab1 = New-Object System.Windows.Forms.TabPage
$tab1.Text = "Deshabilitar Cosas Innecesarias"
$tab1.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)

$tab2 = New-Object System.Windows.Forms.TabPage
$tab2.Text = "Graficos y Juegos"
$tab2.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 25)

$tabControl.Controls.Add($tab1)
$tabControl.Controls.Add($tab2)
$form.Controls.Add($tabControl)

# --- FUNCIÓN DE BOTONES ---
function Add-Action($tab, $text, $x, $y) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(240, 40)
    $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.FlatStyle = "Flat"
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
    $btn.Add_Click({ [System.Windows.Forms.MessageBox]::Show("VoltOS: $text ejecutado") })
    $tab.Controls.Add($btn)
}

# --- DISTRIBUCIÓN DE 40 BOTONES ---
$tabs = @($tab1, $tab2)
foreach ($tab in $tabs) {
    $yPos = 20
    $xPos = 20
    for ($i=1; $i -le 40; $i++) {
        Add-Action $tab "Opcion #$i" $xPos $yPos
        $yPos += 50
        if ($yPos -gt ($tabControl.Height - 80)) { $yPos = 20; $xPos += 260 }
    }
}

$form.ShowDialog()
