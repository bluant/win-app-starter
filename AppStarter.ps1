[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$config_json_data = Get-Content -raw -Path .\configJson.json  | ConvertFrom-Json
$defaultProjectRootDir = $config_json_data.DefaultProjectRoot
$projectCheckBoxLabels = $config_json_data.ProjectList | ForEach-Object -Process {return $_.code}
$additionalCommandsCheckBoxLabels = $config_json_data.AdditionalCommands | ForEach-Object -Process {return $_.code}



$form=New-Object System.Windows.Forms.Form
$form.StartPosition='CenterScreen'
$form.Size='1000,500'
$form.Text ='GUI for kompare starters'
$form.AutoSize = $true
$form.Topmost = $true

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Select which kompare project you want to work on:"
$Label.Location  = New-Object System.Drawing.Point(20,5)
$Label.AutoSize = $true
$Label.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($Label)

function GenerateProjectsCheckboxes{
	$CheckBoxCounter = 1
	$Checkboxes = foreach($projectLabel in $projectCheckBoxLabels){
		$CheckBox = New-Object System.Windows.Forms.CheckBox
		$CheckBox.UseVisualStyleBackColor = $True
		$System_Drawing_Size = New-Object System.Drawing.Size
		$System_Drawing_Size.Width = 104
     	$System_Drawing_Size.Height = 24
		$CheckBox.Size = $System_Drawing_Size
		$CheckBox.TabIndex = 2
		$checkChange =  {
	
			$form.Controls | Where-Object {$_ -is [System.Windows.Forms.Checkbox] -And $_.Name -Match "ProjectCheckBox" } | ForEach-Object {
			
				
				$_.Enabled = if ($this.Checked) { 
					($_ -eq $this);
					$selectedProjectCode = $this.Name.Replace('ProjectCheckBox', '')
					
					$form.Controls | Where-Object {$_ -is [System.Windows.Forms.Checkbox] -And $_.Name -Match "ProjectApplicationCheckBox$selectedProjectCode" } | ForEach-Object {
				
						$_.Enabled = if ($this.Checked) {
							$_.Checked = $true
							$true
						 } else {  
							$false
						  }
					}
				 } else { 
					$clickedProjectCode = $this.Name.Replace('ProjectCheckBox', '')
					$form.Controls | Where-Object {$_ -is [System.Windows.Forms.Checkbox] -And $_.Name -Match "ProjectApplicationCheckBox$clickedProjectCode" } | ForEach-Object {
						$_.Enabled = if ($this.Checked) {
							$_.Checked = $true
							$true
						 } else { 
							$_.Checked = $false
							$false
						  }
					}
					 $true 
				}
			}

			
		}
		$CheckBox.Add_CheckStateChanged($checkChange)
		$CheckBox.Text = $projectLabel
		$System_Drawing_Point = New-Object System.Drawing.Point
		$System_Drawing_Point.X = 50
		$System_Drawing_Point.Y = 41 + (($CheckBoxCounter - 1) * 31)
		$CheckBox.Location = $System_Drawing_Point
		$CheckBox.Name = "ProjectCheckBox$projectLabel"
		$form.Controls.Add($CheckBox)
		$CheckBox
		$CheckBoxCounter++

		

		
	}
}

GenerateProjectsCheckboxes
function GenerateApplicationCheckboxes {
	$ApplicationCheckboxCounter = 1
	$projectIterator = 0;
	$ApplicationCheckboxes = foreach($projectLabel in $projectCheckBoxLabels){
		$projectIterator++;
		$ApplicationCheckboxCounter = 1
		$projectApplications = $config_json_data.ProjectList | Where-Object {$_.code -eq $projectLabel }| ForEach-Object {
			return $_.applications
		}
		foreach($projectApplication in $projectApplications){
			$projectApplicationCode = $projectApplication.code
			$CheckBox = New-Object System.Windows.Forms.CheckBox
			$CheckBox.UseVisualStyleBackColor = $True
			$System_Drawing_Size = New-Object System.Drawing.Size
			$System_Drawing_Size.Width = 130
			$System_Drawing_Size.Height = 24
			$CheckBox.Size = $System_Drawing_Size
			$CheckBox.TabIndex = 2
			$CheckBox.Text = $projectApplicationCode
			$System_Drawing_Point = New-Object System.Drawing.Point
			$System_Drawing_Point.X = 180 + (($ApplicationCheckboxCounter - 1) * 130)
			$System_Drawing_Point.Y = 41 + (($projectIterator - 1) * 31)
			$CheckBox.Location = $System_Drawing_Point
			$CheckBox.Name = "ProjectApplicationCheckBox$projectLabel$projectApplicationCode"
			$CheckBox.Enabled = $false
			$form.Controls.Add($CheckBox)
			$CheckBox
			$ApplicationCheckboxCounter++
		}
		
	}

}
GenerateApplicationCheckboxes

$CheckBoxesTotalHeight = 41  + ($config_json_data.ProjectList.Count * 31)



$horizontalLine = New-Object System.Windows.Forms.Label
$horizontalLine.Text = ""
$horizontalLine.BorderStyle = 1
$horizontalLine.AutoSize = $false
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 2
$System_Drawing_Size.Width = 500
$horizontalLine.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = $CheckBoxesTotalHeight
$horizontalLine.Location = $System_Drawing_Point
$form.Controls.Add($horizontalLine)


$Label = New-Object System.Windows.Forms.Label
$Label.Text = "How do you want to start programs?"
$Label.Location  = New-Object System.Drawing.Point(20,($CheckBoxesTotalHeight +5))
$Label.AutoSize = $true
$Label.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($Label)


$startInCheckChange = {
	# loop through all the forms checkbox controls.
	# the sender object is captured in the automatic variable '$this'
	$form.Controls | Where-Object {$_ -is [System.Windows.Forms.Checkbox] -And $_.Name -Match "StartIn" } | ForEach-Object {
		# if this checkbox is checked, disable all others, otherwise
		# set all checkbox controls to Enabled
		$_.Enabled = if ($this.Checked) { ($_ -eq $this) } else { $true }
	}
}

$checkboxTerminal = New-Object System.Windows.Forms.Checkbox
$checkboxTerminal.Text = "Start in terminal"
$checkboxTerminal.AutoSize = $true
$checkboxTerminal.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Regular)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 60
$System_Drawing_Point.Y = $CheckBoxesTotalHeight + 30
$checkboxTerminal.Location = $System_Drawing_Point
$checkboxTerminal.Name = "StartInTerminalCheckbox"
$checkboxTerminal.Checked = $false
$checkboxTerminal.Enabled = $false
$checkboxTerminal.Add_CheckStateChanged($startInCheckChange)

$form.Controls.Add($checkboxTerminal)


$checkboxWebstorm = New-Object System.Windows.Forms.Checkbox
$checkboxWebstorm.Text = "Open in IDE"
$checkboxWebstorm.AutoSize = $true
$checkboxWebstorm.Name = "StartInWebstormCheckbox"
$checkboxWebstorm.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Regular)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 200
$System_Drawing_Point.Y = $CheckBoxesTotalHeight + 30
$checkboxWebstorm.Location = $System_Drawing_Point
$checkboxWebstorm.Checked = $true
$checkboxWebstorm.Add_CheckStateChanged($startInCheckChange)

$form.Controls.Add($checkboxWebstorm)

$horizontalLine = New-Object System.Windows.Forms.Label
$horizontalLine.Text = ""
$horizontalLine.BorderStyle = 1
$horizontalLine.AutoSize = $false
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 2
$System_Drawing_Size.Width = 500
$horizontalLine.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = $CheckBoxesTotalHeight + 60
$horizontalLine.Location = $System_Drawing_Point
$form.Controls.Add($horizontalLine)

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Do you want to start additional services or programs?"
$Label.Location  = New-Object System.Drawing.Point(20,($CheckBoxesTotalHeight + 65))
$Label.AutoSize = $true
$Label.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($Label)

function GenerateAdditionalCommandsCheckboxes{
	$CheckBoxCounter = 1
	$Checkboxes = foreach($additionalCommandlabel in $additionalCommandsCheckBoxLabels){
		$CheckBox = New-Object System.Windows.Forms.CheckBox
		$CheckBox.UseVisualStyleBackColor = $True
		$System_Drawing_Size = New-Object System.Drawing.Size
		$System_Drawing_Size.Width = 104
     	$System_Drawing_Size.Height = 24
		$CheckBox.Size = $System_Drawing_Size
		$CheckBox.TabIndex = 2
		$CheckBox.Text = $additionalCommandlabel
		$System_Drawing_Point = New-Object System.Drawing.Point
		$columnDividerX = If($CheckBoxCounter -gt 4) {170} Else{0}
		$columnDividerY = If($CheckBoxCounter -gt 4) {$CheckBoxesTotalHeight - 40} Else{0}
		$System_Drawing_Point.X = 50 + $columnDividerX
		$System_Drawing_Point.Y = $CheckBoxesTotalHeight + 90 + (($CheckBoxCounter - 1) * 31) - $columnDividerY
		$CheckBox.Location = $System_Drawing_Point
		$CheckBox.Name = "AdditionalCommandCheckBox$additionalCommandlabel"
		
		$form.Controls.Add($CheckBox)
		$CheckBox
		$CheckBoxCounter++
	}
}

GenerateAdditionalCommandsCheckboxes


$confirmButton = New-Object System.Windows.Forms.Button
$confirmButton.Text = "Pokreni"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 300
$System_Drawing_Size.Height = 100
$confirmButton.Size = $System_Drawing_Size
$confirmButton.Location = New-Object System.Drawing.Point(700,150)
$confirmButton.Add_Click({confirmClickAction})
$form.Controls.Add($confirmButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Odustani"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 200
$System_Drawing_Size.Height = 50
$cancelButton.Size = $System_Drawing_Size
$cancelButton.Location = New-Object System.Drawing.Point(700,350)
$cancelButton.Add_Click({handleClose})
$form.Controls.Add($cancelButton)


function handleClose(){
	$form.close()
}


function confirmClickAction ()
{
	$selectedProjectCheckBoxes =  $form.Controls | Where-Object {$_ -is [System.Windows.Forms.Checkbox] -And $_.Name -Match "ProjectCheckBox" } | ForEach-Object {
		if($_.Checked){
			return $_
		}
	}

	if($selectedProjectCheckBoxes){
		$selectedProjectCode = $selectedProjectCheckBoxes[0].Name.Replace('ProjectCheckBox', '')
		$selectedProjectData = $config_json_data.ProjectList | Where-Object {$_.code -eq $selectedProjectCode }| ForEach-Object {
			return $_
		}
		$selectedProjectApplications = $selectedProjectData[0].applications
	
		foreach($projectApplication in $selectedProjectApplications){
			$projectFolder = $projectApplication.folder
			$projectPath = "$defaultProjectRootDir$projectFolder"
			$projectProgram = $projectApplication.program
			$projectCommand = $projectApplication.command
			$projectApplicationCode = $projectApplication.code
			$applicationCheckboxName = "ProjectApplicationCheckBox$selectedProjectCode$projectApplicationCode"
			$form.Controls | Where-Object {$_ -is [System.Windows.Forms.Checkbox] -And $_.Name -eq "ProjectApplicationCheckBox$selectedProjectCode$projectApplicationCode"} | ForEach-Object {
				$isChecked = $_.Checked
				if($isChecked){
					if($checkboxTerminal.Checked -And $projectCommand){
						 Start-Process powershell -WorkingDirectory $projectPath -ArgumentList "-noexit $projectCommand" -PassThru
						 Start-Sleep -s 2
					}else{
						if($checkboxWebstorm.Checked){
							Start-process $projectProgram $projectPath -Wait:$false
							Start-Sleep -s 5
						}
							
					}
					
				}
			}
			
			
		}
	}
	

	$selectedAdditionalCommandCheckBoxes =  $form.Controls | Where-Object {$_ -is [System.Windows.Forms.Checkbox] -And $_.Name -Match "AdditionalCommandCheckBox" } | ForEach-Object {
		if($_.Checked){
			return $_
		}	
	}

	if($selectedAdditionalCommandCheckBoxes){
		$selectedAdditionalCommandsCodes = $selectedAdditionalCommandCheckBoxes | ForEach-Object {
			return $_.Name.Replace('AdditionalCommandCheckBox', '')
		}
		
		
		foreach($additionalCommandCode in $selectedAdditionalCommandsCodes){
			$additionalCommandData = $config_json_data.AdditionalCommands | Where-Object {$_.code -eq $additionalCommandCode } | ForEach-Object {
				return $_
			}
			
			$additionalCommandDataCommand = $additionalCommandData.command
			$additionalCommandDataProgram = $additionalCommandData.program
			$additionalCommandDataType = $additionalCommandData.type
			if($additionalCommandDataType -eq "program"){
				$additionalCommandDataAdditionalArguments = $additionalCommandData.additionalArguments
				& $additionalCommandDataCommand $additionalCommandDataAdditionalArguments
			}

			if($additionalCommandDataType -eq "service"){
				$additionalCommandDataExit = $additionalCommandData.exit
				$exitParam = If($additionalCommandDataExit) {""} Else{"-noexit"}
				Start-Process $additionalCommandDataProgram -WorkingDirectory $defaultProjectRootDir -ArgumentList "$exitParam $additionalCommandDataCommand"
				
			}
				
			
		}
		
	}



}

$form.ShowDialog()


