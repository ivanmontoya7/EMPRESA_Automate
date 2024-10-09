Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Taxonomy.dll"

[System.Collections.ArrayList]$a = @()
$SiteURL =  Read-Host "Introduce el link del Site"
#Obtener credenciales de Microsoft
$Cred = Get-Credential
#Conexion a SharePoint con las credenciales
$Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
$Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)

$listas= Read-Host "Cuantas listas necesitas?"
$i=0
while($i -lt $listas){
    #Inicializacion listas
    $ListCreationInfo = New-Object Microsoft.SharePoint.Client.ListCreationInformation
    $ListCreationInfo.Title = Read-Host "Introduce el nombre de la lista"
    $a.Add($ListCreationInfo.Title)
    $ListCreationInfo.TemplateType = 100
    $List = $Ctx.Web.Lists.Add($ListCreationInfo)
    $List.Description = ""
    $List.Update()
    $Ctx.ExecuteQuery()
    $i++
}
$i=0
while($i -lt $a.Count){
    #Inicializacion de las listas
    $ListName=$a[$i]
    $FieldID = New-Guid
    $List = $Ctx.Web.Lists.GetByTitle($ListName)
    $Ctx.Load($List)
    $Ctx.ExecuteQuery()
    $Fields = $List.Fields
    $Ctx.Load($Fields)
    $LookupListID= $LookupList.id
    $LookupWebID=$web.Id
    $Ctx.executeQuery()
    #Campo con varias lineas de texto
    $FieldSchema = "<Field Type='Note' ID='{$FieldID}' Name='Campo con varias lineas de texto' StaticName='Campo con varias lineas de texto' DisplayName='Campo con varias lineas de texto' Description='' MaxLength='200'/>"
    $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()
    #Campo numerico
    $FieldID = New-Guid
    $FieldSchema = "<Field Type='Number' ID='{$FieldID}' Name='Campo numerico' StaticName='Campo numerico' DisplayName='Campo numerico' Decimals='2' Description='' Required='TRUE'/>"
    $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()
    #Campo busqueda
    $FieldID = New-Guid
    $Web = $Ctx.web
    $List = $Web.Lists.GetByTitle($ListName)
    $LookupList = $Web.Lists.GetByTitle('Lista_a_buscar')
    $Ctx.Load($Web)
    $Ctx.Load($LookupList)
    $Ctx.ExecuteQuery()
    $FieldSchema = "<Field Type='Lookup' ID='{$FieldID}' DisplayName='Campo busqueda' Name='Campo busqueda' Description='' Required='TRUE' List='$LookupListID' WebId='$LookupWebID' ShowField='columna_a_buscar' />"
    $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()
    #Campo eleccion
    $FieldID = New-Guid
    $FieldSchema = "<Field Type='Choice' ID='{$FieldID}' DisplayName='Campo eleccion' Name='Campo eleccion' Description='' FillInChoice='$FillInChoice' Required='TRUE'><CHOICES><CHOICE>Eleccion 1</CHOICE><CHOICE>Eleccion 2</CHOICE><CHOICE>Eleccion 3</CHOICE></CHOICES></Field>"
    $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()
    #Campo formula
    $FieldID = New-Guid
    $Formula="=[Columna 1] + [Columna 2]"
    $FieldSchema = "<Field Type='Calculated' ID='{$FieldID}' DisplayName='Columna Formula' Decimals='2' Name='Columna Formula' Description='' ResultType='Number' ReadOnly='TRUE'><Formula>$Formula</Formula><FieldRefs><FieldRef Name='[Columna 1]' /><FieldRef Name='[Columna 2]' /></FieldRefs></Field>"
    $List.Fields.AddFieldAsXml($FieldSchema,$True,[Microsoft.SharePoint.Client.AddFieldOptions]::AddFieldInternalNameHint)
    $Ctx.ExecuteQuery()
    $i++
}