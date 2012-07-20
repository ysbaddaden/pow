#! /bin/bash
source /etc/lsb-release

if [ -z "$SRC" ]; then echo "Usage: SRC=/path/to/pow/ $0"; exit 1; fi
echo "SRC is set to $SRC"

mkdir -p ~/.config/Pow/
ln -sfT $SRC ~/.config/Pow/Current/

# Starts Pow on user session:
cp $SRC/linux/pow.desktop $HOME/.config/autostart/pow.desktop

# Configures the system (requires root privileges)
if [ "$DISTRIB_ID" == "Ubuntu" ]; then
  if [ `dpkg -l iptables | egrep ^ii | wc -l` -eq 0 ]; then
    echo "Installing iptables..."
    sudo apt-get install iptables
  fi
  
  if [ `dpkg -l dnsmasq | egrep ^ii | wc -l` -eq 0 ]; then
    echo "Installing dnsmasq..."
    sudo apt-get install dnsmasq
  fi
  
  if [ `dpkg -l openresolv | egrep ^ii | wc -l` -eq 0 ]; then
    if [ `dpkg -l resolvconf | egrep ^ii | wc -l` -eq 0 ]; then
      echo "Installing openresolv..."
      sudo apt-get install openresolv
    else
      echo "Using resolvconf."
    fi
  fi
  
  echo "Configuring dnsmasq..."
  sudo su -c "cat $SRC/linux/dnsmasq.conf > /etc/dnsmasq.d/pow"
  
  if [ -f /etc/resolvconf.conf ]; then
    echo "Configuring openresolv..."
    if [ `grep "# Pow nameserver" /etc/resolvconf.conf | wc -l` -eq 0 ]; then
      sudo su -c "cat $SRC/linux/openresolv.conf >> /etc/resolvconf.conf"
    fi
  elif [ -f /etc/resolvconf/resolv.conf.d/base ]; then
    echo "Configuring resolvconf..."
    if [ `grep "# Pow nameserver" /etc/resolvconf/resolv.conf.d/base | wc -l` -eq 0 ]; then
      sudo su -c "cat $SRC/linux/resolvconf.conf >> /etc/resolvconf/resolv.conf.d/base"
    fi
  fi
fi
