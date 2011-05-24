# Pow under GNU/Linux

Pow is a great piece of software for running rack applications in Mac OS X.
The problem is you can't use it directly in *nix systems.

Here are a few notes to actually have it running under GNU/Linux systems:

  1. resolve *.dev domains to localhost
  2. forward localhost:80 to localhost:20599
  3. use the more linux-friendly path `~/.config` instead of `~/Library/Application Support`.

There are no zero-configuration installer yet, but that should be doable --have
a look at `install-linux.sh` and the `linux/` directory for starting points.

## Routing

We need to configure iptables to redirect from port 80 to port 20559. iptable
rules are kept on hibernate/wakeup but are forgotten on full reboot. We thus
need to check if the rule has been loaded before executing it.

    if [ `sudo iptables -t nat -L | grep 20559 | wc -l` -eq 0 ]
      sudo iptables -t nat -A OUTPUT -p tcp -d 127.0.0.1 --dport 80 -j REDIRECT --to-ports 20559
    fi

IPv6 would require something like the following, but I haven't been able to
make it work yet:

    $ sudo iptables  -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY --on-port 20559
    $ sudo ip6tables -t mangle -A PREROUTING -p tcp -d ::1 --dport 80 -j TPROXY --on-port 20559

## DNS Server

We will resolve `.dev` domains with dnsmasq, and will use resolvconf to
actually manipulate the `resolv.conf` file. This is necessary because the
`resolv.conf` file is actually overwritten everytime we connect to any
network, we thus can't configure anything in this file permanently.

The Debian/Ubuntu package `dnsmasq` comes with a resolvconf script that keeps
the list of nameservers in `/var/run/dnsmasq/resolv.conf`.

`openresolv` itself comes with a dnsmasq script that keeps the list of
nameservers in an external file (that you must configure).

### Installation

Installation on Debian / Ubuntu:

    $ sudo apt-get install dnsmasq openresolv

You may use resolvconf instead of openresolv if it's already installed on your
system, but neither Debian nor Ubuntu bundle it anymore by default.

### Configuration

#### dnsmasq

Edit `/etc/dnsmasq.conf`:

    domain-needed
    interface=lo
    #address=/dev/::1
    address=/dev/127.0.0.1
    resolv-file=/var/run/dnsmasq/resolv.conf

#### openresolv

Edit `/etc/resolvconf.conf`:

    resolv_conf=/etc/resolv.conf
    #name_servers=::1
    name_servers=127.0.0.1
    dnsmasq_conf=/var/run/dnsmasq/dnsmasq.conf
    dnsmasq_resolv=/var/run/dnsmasq/resolv.conf

#### resolvconf

Edit /etc/resolvconf/resolv.conf.d/base

    #nameserver ::1
    nameserver 127.0.0.1

## Starting Pow

Starting Pow on user session is quite easy: you just have to create a
`pow.desktop` file in `~/.config/autostart/`. For instance:

    [Desktop Entry]
    Version=1.0
    Encoding=UTF-8
    Name=Pow
    Type=Application
    Exec=~/.config/Pow/Current/bin/pow.sh
    Terminal=false
    Icon=Pow
    Comment=Pow Rack server.
    NoDisplay=false
    Categories=Development;

## KNOWN BUGS

  - Pow won't load ~/.powconfig?

## TODO

  - write an installer (maybe one per GNU/Linux distribution?)
  - disable the DNS Server since we don't use it

