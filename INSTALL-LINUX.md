= Install Pow

System installation (requires root privileges):

    apt-get install iptables dnsmasq openresolv
    
    cp linux/dnsmasq.conf /etc/dnsmasq.d/pow
    cat linux/openresolv.conf >> /etc/resolvconf.conf
    
    cp linux/initd /etc/init.d/pow
    update-rc.d defaults pow

Local installation (user privileges):

    mkdir -p ~/.config/Pow/Current
    cp -r * ~/.config/Pow/Current
    
    mkdir -p ~/.config/Pow/Hosts
    ln -s ~/.config/Pow/Hosts ~/.pow
    
    mkdir -p ~/.config/autostart
    cp linux/pow.desktop ~/.config/autostart/pow.desktop

