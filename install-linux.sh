#! /bin/sh
source /etc/lsb-release

ROOT="`basename $0`"

# Starts Pow on user session:
cp $SRC/linux/pow.desktop $HOME/.config/autostart/pow.desktop

# Configures the system (requires root privileges)
if [ "$DISTRIB_ID" -eq "Ubuntu" ]
  if [ `dpkg -l iptables | egrep ^ii | wc -l` -eq 0 ]
    echo "Installing iptables..."
    sudo apt-get install iptables
  fi
  
  if [ `dpkg -l dnsmasq | egrep ^ii | wc -l` -eq 0 ]
    echo "Installing dnsmasq..."
    sudo apt-get install dnsmasq
  fi
  
  if [ `dpkg -l openresolv | egrep ^ii | wc -l` -eq 0 ]
    if [ `dpkg -l resolvconf | egrep ^ii | wc -l` -eq 0 ]
      echo "Installing openresolv..."
      sudo apt-get install openresolv
    else
      echo "Using resolvconf."
    fi
  fi
  
  echo "Configuring dnsmasq..."
  sudo su -c "cat $SRC/linux/dnsmasq.conf > /etc/dnsmasq.d/pow"
  
  if [ -f /etc/resolvconf.conf ]
    echo "Configuring openresolv..."
    if [ `grep "# Pow nameserver" /etc/resolvconf.conf | wc -l` -eq 0 ]
      sudo su -c "cat $SRC/linux/openresolv.conf >> /etc/resolvconf.conf"
    fi
  elif [ -f /etc/resolvconf/resolv.conf.d/base ]
    echo "Configuring resolvconf..."
    if [ `grep "# Pow nameserver" /etc/resolvconf/resolv.conf.d/base | wc -l` -eq 0 ]
      sudo su -c "cat $SRC/linux/resolvconf.conf >> /etc/resolvconf/resolv.conf.d/base"
    fi
  fi
fi
