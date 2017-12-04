#!/usr/bin/env ruby
#
# IPMI fru fact(s)
#
# these are basic facts from ipmitool mc info

def parse_ipmitool_output ipmitool_output
  ipmitool_output.each_line do |line|
    case line.strip
    when /^Board Mfg\s*:\s+(\S.*)/
      add_ipmi_fact("fru_board_manufacturer", $1)
    when /^Board Serial\s*:\s+(\S.*)/
      add_ipmi_fact("fru_board_serial", $1)
    when /^Board Product\s*:\s+(\S.*)/
      add_ipmi_fact("fru_board_product", $1)
    when /^Product Serial\s*:\s+(\S.*)/
      add_ipmi_fact("fru_product_serial", $1)
    when /^Product Name\s*:\s+(\S.*)/
      add_ipmi_fact("fru_product_name", $1)
    end
  end
end

def add_ipmi_fact name, value
  fact_names = []
  # default channels: supermicro = 1, hp = 2
  fact_names.push("ipmi_#{name}")
  fact_names.each do |name|
    Facter.add(name) do
      confine :kernel => "Linux"
      setcode do
        value
      end
    end
  end
end

if Facter::Util::Resolution.which('ipmitool') and Facter.value(:manufacturer) != 'HP'
  ipmitool_output = Facter::Util::Resolution.exec("timeout 5 ipmitool fru 2>&1")
  if ipmitool_output
    parse_ipmitool_output ipmitool_output
  end
end

