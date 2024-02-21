# AppStarter

AppStarter is a PowerShell script designed to streamline the process of launching multiple applications on Windows. This solution is particularly useful for scenarios where frequent system crashes require the manual restart of essential services. AppStarter utilizes a JSON configuration file to specify the locations and startup commands for various applications, providing a user-friendly interface with checkboxes for each application.

## Features

- **Easy Configuration**: Define application paths and startup commands in a simple JSON file.
- **User-Friendly Interface**: Launch your applications from a GUI with convenient checkboxes.
- **Customizable**: Use your own `favicon.ico` for the generated executable.

## Prerequisites

Before using AppStarter, ensure you have the following:

- PowerShell 5.0 or higher.
- The `PS2EXE` module to convert PowerShell scripts into executables. Installation instructions are provided below.

## Installation

1. **Install PS2EXE**

   AppStarter requires `PS2EXE` to generate an executable. If you haven't installed `PS2EXE` yet, run the following command in a PowerShell window run as administrator:

   ```powershell
   Install-Module -Name ps2exe -Scope CurrentUser -Force
For more information on PS2EXE, visit the GitHub repository.

## Configuration
Edit the Configuration File

- Modify the configJson file to specify the applications you wish to start. Each entry should contain the application's location and the command to launch it.

Prepare Your Icon

- Place your desired favicon.ico in the same directory as the AppStarter.ps1 script.

## Usage
To start the applications, simply run the AppStarter.ps1 script. If you prefer a standalone executable:

### Build the Executable

Use the following command to create an executable from the PowerShell script. This command also embeds your custom icon into the executable.

   ```powershell
Invoke-ps2exe .\AppStarter.ps1 .\AppStarterExecutable.exe -icon .\favicon.ico
```

### Launch Applications

Run AppStarterExecutable.exe to open the GUI. Select the applications you want to start and click the "Start Selected Apps" button.


## Troubleshooting
If you encounter any issues with script execution policies, you may need to adjust your PowerShell execution policy settings. Run the following command as an administrator:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
