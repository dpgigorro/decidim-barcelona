$:.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'decidim-saml'
  s.version     = '0.0.1'
  s.authors     = ['ASPgems']
  s.email       = ['dperez@aspgems.com']
  s.summary     = 'SAML authorization for Decidim Diputació de Barcelona'
  s.description = 'Login through SAML'
  s.homepage    = 'http://aspgems.com/'
  s.license     = 'AGPLv3'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.test_files = Dir['spec/**/*']

  s.add_dependency 'decidim-core'
  s.add_dependency 'omniauth-saml'

  s.add_development_dependency 'decidim-dev'
end
