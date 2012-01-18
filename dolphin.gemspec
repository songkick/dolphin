
spec = Gem::Specification.new do |s|
  s.name              = "dolphin"
  s.version           = "0.6"
  s.summary           = "The friendly feature flipper"
  s.author            = "Matt Johnson"
  s.email             = "grillpanda@gmial.com"
  s.homepage          = "http://grillpanda.com"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)

  s.files             = %w(README.rdoc MIT-LICENSE) + Dir.glob("{spec,lib/**/*}")
  s.require_paths     = ["lib"]

  s.add_development_dependency("rspec")
end
