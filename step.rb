require 'optparse'
require_relative 'utils/logger'
require_relative 'utils/simulator'

# -----------------------
# --- functions
# -----------------------

def to_bool(value)
  return true if value == true || value =~ (/^(true|t|yes|y|1)$/i)
  return false if value == false || value.nil? || value == '' || value =~ (/^(false|f|no|n|0)$/i)
  fail_with_message("Invalid value for Boolean: \"#{value}\"")
end

def run_calabash_test!
  puts
  puts 'cucumber'
  system('cucumber')
  fail_with_message('cucumber -- failed') unless $?.success?
end

# -----------------------
# --- main
# -----------------------

#
# Input validation
options = {
  device: nil,
  os: nil
}

parser = OptionParser.new do|opts|
  opts.banner = 'Usage: step.rb [options]'
  opts.on('-b', '--device device', 'Device') { |b| options[:device] = b unless b.to_s == '' }
  opts.on('-c', '--os os', 'OS') { |c| options[:os] = c unless c.to_s == '' }
  opts.on('-p', '--project project', 'Path to Xcode project')  { |p| options[:project] = p unless p.to_s == '' }
  opts.on('-h', '--help', 'Displays Help') do
    exit
  end
end
parser.parse!

fail_with_message('simulator_device not specified') unless options[:device]
fail_with_message('simulator_os_version not specified') unless options[:os]

udid = simulator_udid(options[:device], options[:os])
fail_with_message('failed to get simulator udid') unless udid

ENV['DEVICE_TARGET'] = udid
ENV['PROJECT_DIR'] = options[:project] unless options[:project].nil?

#
# Print configs
puts
puts "\e[34mConfiguration\e[0m"
puts " * simulator_device: #{options[:device]}"
puts " * simulator_os: #{options[:os]}"
puts " * simulator_UDID: #{udid}"
puts " * project_path: #{options[:project]}" unless options[:project].nil?

#
# Run calabash test
puts
puts "\e[34mRunning calabash tests\e[0m"
run_calabash_test!

system('envman add --key BITRISE_CALABASH_TEST_RESULT --value succeeded')
