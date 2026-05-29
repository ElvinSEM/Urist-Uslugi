ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# Bootsnap is optional at boot time; if the local yaml gem install is incomplete,
# disable Bootsnap rather than failing before Rails starts.
yaml_spec = Gem::Specification.find_all_by_name("yaml").find do |spec|
  File.exist?(File.join(spec.full_gem_path, "lib", "yaml.rb"))
end
ENV["DISABLE_BOOTSNAP"] = "1" if yaml_spec.nil?

begin
  require "bootsnap/setup" # Speed up boot time by caching expensive operations.
rescue LoadError => e
  warn "[boot] skipping bootsnap: #{e.message}"
end
