
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name              = "dolphin"
  s.version           = "0.3"
  s.summary           = "The friendly feature flipper"
  s.author            = "Matt Johnson"
  s.email             = "grillpanda@gmial.com"
  s.homepage          = "http://grillpanda.com"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)

  # Add any extra files to include in the gem
  s.files             = %w(README.rdoc MIT-LICENSE) + Dir.glob("{spec,lib/**/*}")
  s.require_paths     = ["lib"]

  # If your tests use any gems, include them here
  s.add_development_dependency("rspec")
end
