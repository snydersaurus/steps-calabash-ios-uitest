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

def run_calabash_test!(path)
  system("cd \"#{path}\" && cucumber")
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
  opts.on('-d', '--device device', 'Device') { |d| options[:device] = d unless d.to_s == '' }
  opts.on('-o', '--os os', 'OS') { |o| options[:os] = o unless o.to_s == '' }
  opts.on('-p', '--project project', 'Path to Xcode project directory')  { |p| options[:project] = p unless p.to_s == '' }
  opts.on('-c', '--calabash calabash', 'Path to the calabash directory')  { |c| options[:path] = c unless c.to_s == '' }
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
unless options[:project].nil?
  project_path = options[:project]
  if project_path.end_with?('.xcworkspace') || project_path.end_with?('.xcodeproj')
    project_path = File.join(project_path, '..')
  end
  ENV['PROJECT_DIR'] = File.absolute_path(project_path)
end

#
# Print configs
puts
puts "\e[34mConfiguration\e[0m"
puts " * cucumber_path: #{options[:path]}"
puts " * simulator_device: #{options[:device]}"
puts " * simulator_os: #{options[:os]}"
puts " * simulator_UDID: #{udid}"
puts " * project_path: #{options[:project]}" unless options[:project].nil?

#
# Run calabash test
puts
puts "\e[34mRunning calabash tests\e[0m"
run_calabash_test!(options[:path])

system('envman add --key BITRISE_CALABASH_TEST_RESULT --value succeeded')
