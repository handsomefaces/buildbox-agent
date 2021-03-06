#!/usr/bin/env ruby

raise "Missing GITHUB_RELEASE_ACCESS_TOKEN" unless ENV['GITHUB_RELEASE_ACCESS_TOKEN']

# Find out the current version of the agent
root_dir = File.expand_path(File.join(File.expand_path(File.dirname(__FILE__)), '..'))
version_file = File.read(File.join(root_dir, 'buildbox', 'version.go'))
version_number = version_file.match(/Version = "(.+)"/)[1]
version = "v#{version_number}"

# Is it prerelease?
prerelease = !!(version =~ /beta|alpha/)

# Collect the files that need to be uploaded
files = Dir[File.join(root_dir, "pkg", "*.tar.gz")]

# Output information
puts "Version: #{version}"
puts "Prerelease: #{prerelease ? "Yes" : "No"}"
puts "Assets:"
files.each do |file|
  puts " - #{File.basename(file)}"
end
puts ""

# Build the command to run
command = [ %{github-release #{version} #{files.join(' ')} --github-repository "buildboxhq/buildbox-agent"} ]
command << "--prerelease" if prerelease

# Show and execute the command
final_command = command.join(' ')

puts "$ #{final_command}\n\n"
exec final_command
