Gem::Specification.new do |s|
  s.name = 'OPC'
  s.version = '0.2.2'
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ['Daryn McCool']
  s.date = Date.today.to_s
  s.description = 'REST API Interface for Oracle Public Cloud. Exposes REST calls as Ruby methods'
  s.email = 'mdaryn@hotmail.com'
  s.files += Dir['lib/**/*.rb']
  s.homepage = 'https://github.com/mccoold/OPC'
  s.required_ruby_version = '>= 1.8'
  s.require_paths = ['lib']
  s.rubygems_version = '1.6.2'
  s.summary = 'OPC'
  s.license = 'Apache-2.0'
  if s.respond_to? :specification_version
    s.specification_version = 3
  end
end
