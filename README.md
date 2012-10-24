# Who's in the office?

Who is a sinatra app that parses the output of nmap and figures out
who's currently in the office. It's intended for the Raspberry Pi,
which is why I chose an in-memory Database.

The whole thing is optimized for minimum Disk I/O.

**THIS USES NMAP TO PROBE YOUR NETWORK. YOUR NETWORK ADMIN MIGHT MURDER
YOU IN THE FACE IF YOU USE THIS WITHOUT PERMISSION!**

## Installation

* Install Raspian (wheezy).
* Install Ruby 1.9.3 and Rubygems as described here:

    http://elinux.org/RPi_Ruby
* Clone repo
* Install bundler gem:

    gem install bundler

* Add your sudo password in scanner.sh
* Add scanner.sh as a cron job like this (runs every 15 minutes):

    */15 * * * * nohup /var/www/who/scanner.sh > /dev/null 2>&1 &

* Start the sinatra app like this

    rackup /var/www/who/config.ru

* Test it with curl:

    http://localhost:9292 | pythone -mjson.tool
