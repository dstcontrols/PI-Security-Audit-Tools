# ***********************************************************************
# Validation library
# ***********************************************************************
# * Modulename:   PISYSAUDIT
# * Filename:     PISYSAUDITCHECKLIB5.psm1
# * Version:      1.0.0.8
# * Description:  Validation rules for PI Coresight.
# * Authors:  Jim Davidson, Bryan Owen and Mathieu Hamel from OSIsoft.
# *
# * Copyright 2016 OSIsoft, LLC
# * Licensed under the Apache License, Version 2.0 (the "License");
# * you may not use this file except in compliance with the License.
# * You may obtain a copy of the License at
# * 
# *   <http://www.apache.org/licenses/LICENSE-2.0>
# * 
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# *
# * Modifications copyright (C) 2016 Harry Paul, OSIsoft, LLC
# * Created validation rule module based off of template used for the
# * previous modules.
# *
# ************************************************************************
# Version History:
# ------------------------------------------------------------------------
#
# ************************************************************************

# ........................................................................
# Internal Functions
# ........................................................................
function GetFunctionName
{ return (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name }

# ........................................................................
# Public Functions
# ........................................................................
function Get-PISysAudit_FunctionsFromLibrary5
{
	# Form a list of all functions that need to be called to test
	# the machine compliance.
	[System.Collections.HashTable]$listOfFunctions = @{}	
	$listOfFunctions.Add("Get-PISysAudit_CheckCoresightVersion", 1)
			
	# Return the list.
	return $listOfFunctions
}

function Get-PISysAudit_CheckCoresightVersion
{
<#  
.SYNOPSIS
AU50001 - Check for latest version of Coresight
.DESCRIPTION
VALIDATION: verifies PI Coresight version.<br/>
COMPLIANCE: upgrade to the latest version of PI Coresight.  For more information, 
see "Upgrade a PI Coresight installation" in the PI Live Library.<br/>
https://livelibrary.osisoft.com/LiveLibrary/content/en/coresight-v7/GUID-5CF8A863-E056-4B34-BB6B-
#>
[CmdletBinding(DefaultParameterSetName="Default", SupportsShouldProcess=$false)]     
param(							
		[parameter(Mandatory=$true, Position=0, ParameterSetName = "Default")]
		[alias("at")]
		[System.Collections.HashTable]
		$AuditTable,
		[parameter(Mandatory=$false, ParameterSetName = "Default")]
		[alias("lc")]
		[boolean]
		$LocalComputer = $true,
		[parameter(Mandatory=$false, ParameterSetName = "Default")]
		[alias("rcn")]
		[string]
		$RemoteComputerName = "",
		[parameter(Mandatory=$false, ParameterSetName = "Default")]
		[alias("dbgl")]
		[int]
		$DBGLevel = 0)		
BEGIN {}
PROCESS
{		
	# Get and store the function Name.
	$fn = GetFunctionName
	$msg = ""
	
	try
	{		
		$RegKeyPath = "HKLM:\Software\PISystem\Coresight"
		$attribute = "CurrentVersion"
		$installVersion = Get-PISysAudit_RegistryKeyValue -lc $LocalComputer -rcn $RemoteComputerName -rkp $RegKeyPath -a $attribute -DBGLevel $DBGLevel		
		
		$installVersionTokens = $installVersion.Split(".")
		# Form an integer value with all the version tokens.
		[string]$temp = $InstallVersionTokens[0] + $installVersionTokens[1] + $installVersionTokens[2] + $installVersionTokens[3]
		$installVersionInt64 = [Convert]::ToInt64($temp)
		if($installVersionInt64 -ge 3004)
		{
			$result = $true
			$msg = "Version is compliant."
		}	
		else 
		{
			$result = $false
			$msg = "Version is not compliant."
		}
	}
	catch
	{
		# Return the error message.
		$msg = "A problem occured during the processing of the validation check"					
		Write-PISysAudit_LogMessage $msg "Error" $fn -eo $_									
		$result = "N/A"
	}	
	
	# Define the results in the audit table	
	$AuditTable = New-PISysAuditObject -lc $LocalComputer -rcn $RemoteComputerName `
									-at $AuditTable "AU50001" `
									-msg $msg `
									-ain "PI Coresight Version" -aiv $result `
									-Group1 "PI System" -Group2 "PI Coresight" `
									-Severity "Moderate"																																																

}

END {}

#***************************
#End of exported function
#***************************
}

# ........................................................................
# Add your cmdlet after this section. Don't forget to add an intruction
# to export them at the bottom of this script.
# ........................................................................
function Get-PISysAudit_TemplateAU1xxxx
{
<#  
.SYNOPSIS
AU5xxxx - <Name>
.DESCRIPTION
VERIFICATION: <Enter what the verification checks>
COMPLIANCE: <Enter what it needs to be compliant>
#>
[CmdletBinding(DefaultParameterSetName="Default", SupportsShouldProcess=$false)]     
param(							
		[parameter(Mandatory=$true, Position=0, ParameterSetName = "Default")]
		[alias("at")]
		[System.Collections.HashTable]
		$AuditTable,
		[parameter(Mandatory=$false, ParameterSetName = "Default")]
		[alias("lc")]
		[boolean]
		$LocalComputer = $true,
		[parameter(Mandatory=$false, ParameterSetName = "Default")]
		[alias("rcn")]
		[string]
		$RemoteComputerName = "",
		[parameter(Mandatory=$false, ParameterSetName = "Default")]
		[alias("dbgl")]
		[int]
		$DBGLevel = 0)		
BEGIN {}
PROCESS
{		
	# Get and store the function Name.
	$fn = GetFunctionName
	
	try
	{		
		# Enter routine.			
	}
	catch
	{
		# Return the error message.
		$msg = "A problem occured during the processing of the validation check"					
		Write-PISysAudit_LogMessage $msg "Error" $fn -eo $_									
		$result = "N/A"
	}	
	
	# Define the results in the audit table	
	$AuditTable = New-PISysAuditObject -lc $LocalComputer -rcn $RemoteComputerName `
									-at $AuditTable "AU1xxxx" `
									-ain "<Name>" -aiv $result `
									-msg $msg `
									-Group1 "<Category 1>" -Group2 "<Category 2>" `
									-Group3 "<Category 3>" -Group4 "<Category 4>" `
									-Severity "<Severity>"																																																
}

END {}

#***************************
#End of exported function
#***************************
}

# ........................................................................
# Export Module Member
# ........................................................................
# <Do not remove>
Export-ModuleMember Get-PISysAudit_FunctionsFromLibrary5
Export-ModuleMember Get-PISysAudit_CheckCoresightVersion
# </Do not remove>

# ........................................................................
# Add your new Export-ModuleMember instruction after this section.
# Replace the Get-PISysAudit_TemplateAU1xxxx with the name of your
# function.
# ........................................................................
# Export-ModuleMember Get-PISysAudit_TemplateAU1xxxx