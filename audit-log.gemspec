$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'audit-log/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'audit-log'
  spec.version     = AuditLog::VERSION
  spec.authors     = ['Jason Lee']
  spec.email       = ['huacnlee@gmail.com']
  spec.homepage    = 'https://github.com/rails-engine/audit-log'
  spec.summary     = 'Trail audit logs (Operation logs) into the database for user behaviors, including a web UI to query logs'
  spec.description = 'Trail audit logs (Operation logs) into the database for user behaviors, including a web UI to query logs.'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'kaminari', '>= 0.15'
  spec.add_dependency 'rails', '>= 5.2'
end
