# Definici�n de contrase�as y fechas
$contrase�aTrabajador = ConvertTo-SecureString "Contrase�aTrabajador123" -AsPlainText -Force
$contrase�aResponsable = ConvertTo-SecureString "Contrase�aResponsable123" -AsPlainText -Force
$contrase�aInformatico = ConvertTo-SecureString "Contrase�aInformatico123" -AsPlainText -Force
$expirationDate = (Get-Date).AddYears(1)

# Crear grupos si no existen
$grupos = @("Trabajadores", "Responsables", "Administradores")
foreach ($grupo in $grupos) {
    if (!(Get-LocalGroup -Name $grupo -ErrorAction SilentlyContinue)) {
        New-LocalGroup -Name $grupo -Description "Grupo de $grupo"
    }
}

# Crear usuarios Trabajador1 a Trabajador5 y agregarlos al grupo Trabajadores
for ($i = 1; $i -le 5; $i++) {
    $username = "Trabajador$i"
    if (!(Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
        New-LocalUser -Name $username -Password $contrase�aTrabajador -FullName $username -AccountExpires $expirationDate
        Add-LocalGroupMember -Group "Trabajadores" -Member $username
    }
}

# Crear usuarios Responsable1 y Responsable2 y agregarlos al grupo Responsables
foreach ($username in @("Responsable1", "Responsable2")) {
    if (!(Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
        New-LocalUser -Name $username -Password $contrase�aResponsable -FullName $username -AccountExpires $expirationDate
        Add-LocalGroupMember -Group "Responsables" -Member $username
    }
}

# Crear usuario Informatico sin que la contrase�a expire y agregarlo al grupo Administradores
if (!(Get-LocalUser -Name "Informatico" -ErrorAction SilentlyContinue)) {
    # Crear el usuario sin el par�metro -PasswordNeverExpires
    New-LocalUser -Name "Informatico" -Password $contrase�aInformatico -FullName "Informatico"
    
    # Configurar la contrase�a para que nunca expire
    Set-LocalUser -Name "Informatico" -PasswordNeverExpires $true
    
    # Agregar el usuario al grupo Administradores
    Add-LocalGroupMember -Group "Administradores" -Member "Informatico"
}

# Crear usuario nuevo_usuario sin ning�n grupo espec�fico
if (!(Get-LocalUser -Name "nuevo_usuario" -ErrorAction SilentlyContinue)) {
    New-LocalUser -Name "nuevo_usuario" -Password $contrase�aTrabajador -FullName "nuevo_usuario"
}

# Comprobar los usuarios de los grupos Trabajadores y Responsables
Write-Output "`nUsuarios en el grupo 'Trabajadores':"
Get-LocalGroupMember -Group "Trabajadores"

Write-Output "`nUsuarios en el grupo 'Responsables':"
Get-LocalGroupMember -Group "Responsables"

# Mostrar las propiedades de un usuario de cada grupo
Write-Output "`nPropiedades del usuario Trabajador1:"
Get-LocalUser -Name "Trabajador1" | Select-Object *

Write-Output "`nPropiedades del usuario Responsable1:"
Get-LocalUser -Name "Responsable1" | Select-Object *

Write-Output "`nPropiedades del usuario Informatico:"
Get-LocalUser -Name "Informatico" | Select-Object *
