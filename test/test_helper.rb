require 'simplecov'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

if ENV['COVERAGE']
  SimpleCov.start do
    require 'simplecov-lcov'

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = 'coverage/lcov.info'
    end

    formatter SimpleCov::Formatter::LcovFormatter
    add_filter ['version.rb', 'initializer.rb']
  end
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require_relative './bullet_helper'
require 'rails/test_help'

class ActiveSupport::TestCase
  include BulletHelper
  include FactoryBot::Syntax::Methods
  include ActionMailer::TestHelper

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include AuthHelper

  def after_teardown
    def remove_uploaded_files
      FileUtils.rm_rf(ActiveStorage::Blob.service.root)
    end

    remove_uploaded_files
  end
end
