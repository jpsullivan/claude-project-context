#!/usr/bin/env ruby
# files-to-claude.rb

require 'optparse'
require 'fileutils'

options = {
  output_dir: nil,
  repo_url: "git+https://github.com/simonw/files-to-prompt"
}

# Parse command line options
option_parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby files-to-claude.rb <path> [options]"
  
  opts.on("-o", "--output-dir DIRECTORY", "Output directory for all results") do |dir|
    options[:output_dir] = dir
  end
  
  opts.on("-r", "--repo URL", "Repository URL for files-to-prompt (default: #{options[:repo_url]})") do |url|
    options[:repo_url] = url
  end
  
  opts.on("-h", "--help", "Show this help message") do
    puts opts
    exit
  end
end

begin
  option_parser.parse!
rescue OptionParser::InvalidOption => e
  puts e.message
  puts option_parser
  exit 1
end

# Check if a path argument was provided
if ARGV.length != 1
  puts option_parser
  exit 1
end

input_path = ARGV[0]

# Ensure the input path exists
unless Dir.exist?(input_path)
  puts "Error: The specified path '#{input_path}' does not exist."
  exit 1
end

# Create output directory if specified and it doesn't exist
if options[:output_dir]
  unless Dir.exist?(options[:output_dir])
    begin
      FileUtils.mkdir_p(options[:output_dir])
      puts "Created output directory: #{options[:output_dir]}"
    rescue => e
      puts "Error creating output directory: #{e.message}"
      exit 1
    end
  end
end

# Command base with uvx
command_base = "uvx --with #{options[:repo_url]} files-to-prompt"

# Helper method to run files-to-prompt with different formats
def run_files_to_prompt(command_base, path, output_path, format)
  # Determine file extension based on format
  ext = format == "--cxml" ? "claude.txt" : "md"
  
  # Append appropriate extension to output path
  output_file = "#{output_path}.#{ext}"
  
  # Create the command to run
  command = "#{command_base} #{path} --ignore \"stories\" --ignore \"__tests__\" #{format} -o #{output_file}"
  
  puts "Running: #{command}"
  
  # Execute the command
  result = system(command)
  
  if result
    puts "✓ Successfully generated #{format} output for: #{path}"
  else
    puts "✗ Error generating #{format} output for: #{path} (exit code: #{$?.exitstatus})"
  end
  
  return result
end

# First, process the entire input path
puts "Processing the entire directory: #{input_path}"

# Determine output path base for the complete source code
complete_output_base = if options[:output_dir]
                         File.join(options[:output_dir], "complete_source_code")
                       else
                         File.join(input_path, "complete_source_code")
                       end

# Run files-to-prompt for both formats on the entire directory
run_files_to_prompt(command_base, input_path, complete_output_base, "--cxml")
run_files_to_prompt(command_base, input_path, complete_output_base, "--markdown")

# Get all subdirectories in the specified path
subdirs = Dir.entries(input_path).select do |entry|
  full_path = File.join(input_path, entry)
  File.directory?(full_path) && ![".", ".."].include?(entry)
end

if subdirs.empty?
  puts "No subdirectories found in '#{input_path}'."
  exit 0
end

# Process each subdirectory
puts "Processing #{subdirs.length} subdirectories..."
subdirs.each do |dir|
  full_dir_path = File.join(input_path, dir)
  
  # Determine output path base based on options
  output_base = if options[:output_dir]
                  # Use the output directory with subdirectory name
                  output_subdir = File.join(options[:output_dir], dir)
                  FileUtils.mkdir_p(output_subdir) unless Dir.exist?(output_subdir)
                  File.join(output_subdir, "output")
                else
                  # Use the original directory
                  File.join(dir, "output")
                end
  
  # Run files-to-prompt for both formats on each subdirectory
  run_files_to_prompt(command_base, full_dir_path, output_base, "--cxml")
  run_files_to_prompt(command_base, full_dir_path, output_base, "--markdown")
end

puts "All directories processed."
