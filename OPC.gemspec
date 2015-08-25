Gem::Specification.new do |s|
  s.name = 'OPC'
  s.version = '0.0.1'
  # s.default_executable = "list"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ['Daryn McCool']
  s.date = 2015-03-12
  s.description = 'REST API Interface for Oracle Public Cloud, exposes REST calls as Ruby methods'
  s.email = 'mdaryn@hotmail.com'
  s.files += Dir['lib/**/*.rb']
  s.homepage = 'http://rubygems.org/gems/'
  s.require_paths = ['lib']
  s.rubygems_version = '1.6.2'
  s.summary = 'OPC'
  s.license = 'Apache-2.0'
  if s.respond_to? :specification_version
    s.specification_version = 3
    # if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
  end
end
