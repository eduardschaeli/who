require 'rubygems'
require 'supermodel'

class Scan < SuperModel::Base

  def self.users
    [
      {:name => "Eduard iPhone", :mac => "aa:aa:bb:11:0a:04"},
      {:name => "Florian iPhone", :mac => "aa:aa:bb:11:0a:04"}
    ]
  end

  def self.find_active_users
    active_users = []

    Scan.all.each do |row|
      active_user = self.users.select{|user| user[:mac] == row.mac}
      if active_user.size > 0
        active_users << {hostname: row.hostname, ip: row.ip, mac: row.mac, state: row.state, name: active_user.first[:name]}
      end
    end

    return active_users
  end

  def self.last_scan
    @last_scan
  end

  def self.last_scan=(last_scan)
    @last_scan = last_scan
  end

  def self.load_from_textfile
    # check if data is older then last nmap scan
    data_is_outdated = false
    new_scan = File.open('lastscan.txt', 'r').readline

    if self.last_scan != new_scan
      self.last_scan = new_scan
      data_is_outdated = true
    end


    if data_is_outdated
      Scan.destroy_all
      scan_data = []

      host_regex = /^Nmap scan report for\s([^\(\)]+)\s\((\d.+)\)$|^Nmap scan report for\s(\d.+)$/
        mac_regex = /^MAC Address:\s([^\(\)\s]+)\s\(([^\(\)\s]+)\)$/
        state_regex = /^(Host is\sup\s\([0-9.s]+\slatency\)\.$|Host is\sup|down\.$)/

        File.open('nmap-scan.txt', 'r').each_line do |line|
        if line =~ host_regex
          host_match = line.match(host_regex)
          if host_match[3].nil?
            scan_data << {:hostname => host_match[1], :ip => host_match[2]}
          else
            scan_data << {:hostname => '', :ip => host_match[3]}
          end
        end

        if line =~ mac_regex
          mac_match = line.match(mac_regex)
          scan_data.last[:mac] = mac_match[1].nil? ? '' : mac_match[1].downcase
        end

        if line =~ state_regex
          state_match = line.match(state_regex)
          scan_data.last[:state] = 'up' unless state_match.nil?
        end

        end

      scan_data.each do |row|
        unless row[:mac].nil?
          scan = Scan.new
          scan.hostname = row[:hostname]
          scan.ip = row[:ip]
          scan.mac = row[:mac]
          scan.state = row[:state]
          scan.save
        end
      end
    end
  end
end
