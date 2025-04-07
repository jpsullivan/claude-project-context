#!/usr/bin/env ruby
# files-to-claude.rb

require 'optparse'
require 'fileutils'

options = {
  output_dir: nil,
  repo_url: "git+https://github.com/simonw/files-to-prompt",
  max_depth: nil,
  ignore_dirs: []
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
  
  opts.on("-d", "--max-depth DEPTH", Integer, "Maximum depth for directory traversal (default: unlimited)") do |depth|
    options[:max_depth] = depth
  end
  
  opts.on("-i", "--ignore PATTERN", "Directories to ignore (can be specified multiple times)") do |pattern|
    options[:ignore_dirs] << pattern
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
def run_files_to_prompt(command_base, path, output_path, format, ignore_patterns=[])
  # Determine file extension based on format
  ext = format == "--cxml" ? "claude.txt" : "md"
  
  # Append appropriate extension to output path
  output_file = "#{output_path}.#{ext}"
  
  # Create the ignore flags
  ignore_flags = ignore_patterns.map { |pattern| "--ignore \"#{pattern}\"" }.join(" ")
  
  # Create the command to run
  command = "#{command_base} #{path} #{ignore_flags} #{format} -o #{output_file}"
  
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

# Helper method to check if a directory should be ignored
def should_ignore?(dir_name, ignore_patterns)
  ignore_patterns.any? do |pattern|
    File.fnmatch(pattern, dir_name, File::FNM_PATHNAME)
  end
end

# Process directories recursively
def process_directory(path, base_output_dir, command_base, options, current_depth=0)
  # Check if max depth is set and reached
  if options[:max_depth] && current_depth > options[:max_depth]
    puts "Max depth reached for: #{path}"
    return
  end
  
  rel_path = options[:output_dir] ? path.sub(/^#{Regexp.escape(File.expand_path(ARGV[0]))}\//, '') : path
  
  # Determine output path base for this directory
  if options[:output_dir]
    # Create directory with the same structure in the output directory
    output_path = File.join(base_output_dir, rel_path)
    FileUtils.mkdir_p(output_path) unless Dir.exist?(output_path)
    output_base = File.join(output_path, "output")
  else
    # Use the original directory
    output_base = File.join(path, "output")
  end
  
  puts "\nProcessing directory: #{path} (depth: #{current_depth})"
  
  # Run files-to-prompt for both formats on this directory
  run_files_to_prompt(command_base, path, output_base, "--cxml", options[:ignore_dirs])
  run_files_to_prompt(command_base, path, output_base, "--markdown", options[:ignore_dirs])
  
  # Get all subdirectories
  subdirs = Dir.entries(path).select do |entry|
    full_path = File.join(path, entry)
    File.directory?(full_path) && ![".", ".."].include?(entry) && !should_ignore?(entry, options[:ignore_dirs])
  end
  
  # Process each subdirectory recursively
  if subdirs.any?
    puts "Found #{subdirs.length} subdirectories in '#{path}'..."
    subdirs.each do |dir|
      full_dir_path = File.join(path, dir)
      process_directory(full_dir_path, base_output_dir, command_base, options, current_depth + 1)
    end
  end
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
ignore_patterns = ["stories", "__tests__"] + options[:ignore_dirs]
run_files_to_prompt(command_base, input_path, complete_output_base, "--cxml", ignore_patterns)
run_files_to_prompt(command_base, input_path, complete_output_base, "--markdown", ignore_patterns)

# Now process all directories recursively
puts "\nStarting recursive directory processing..."
options[:ignore_dirs] += ["stories", "__tests__"] unless options[:ignore_dirs].include?("stories") || options[:ignore_dirs].include?("__tests__")
process_directory(input_path, options[:output_dir] || input_path, command_base, options)

puts "\nAll directories processed."