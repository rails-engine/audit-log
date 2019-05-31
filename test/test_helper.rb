# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require_relative '../test/dummy/config/environment'
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]
require 'rails/test_help'

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

require 'rails/test_unit/reporter'
Rails::TestUnitReporter.executable = 'bin/test'

require 'factory_bot'
FactoryBot.definition_file_paths = [File.expand_path('factories', __dir__)]
FactoryBot.find_definitions

require 'audit-log'

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path('fixtures', __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + '/files'
  ActiveSupport::TestCase.fixtures :all
end

# Load fixtures from the engine
class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end

class ActionView::TestCase
  include Rails.application.routes.url_helpers
end

class ActionDispatch::IntegrationTest
  def sign_in(user)
    post main_app.user_session_path \
      'user[email]' => user.email,
      'user[password]' => user.password
  end

  def sign_in_session(user)
    open_session do |app|
      app.post main_app.user_session_path \
        'user[email]' => user.email,
        'user[password]' => user.password
      assert app.controller.user_signed_in?, "login_with_session #{user.email} 没有成功, #{app.flash[:alert]}"
    end
  end

  def assert_required_user
    assert_response :redirect
    assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
  end

  def assert_access_denied
    assert_response :redirect
    assert_equal 'Access denied.', flash[:alert]
  end
end
