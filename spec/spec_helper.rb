$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kwattr'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end

module RaiseArgumentErrorHelper
  def it_raises_on_unknown_keyword(keyword, &block)
    it 'raises ArgumentError on unknown keyword' do
      message = if RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.7'
        "unknown keyword: :#{keyword}"
      else
        "unknown keyword: #{keyword}"
      end
      expect(&block).to raise_error(ArgumentError, message)
    end
  end

  def it_raises_on_missing_keyword(keyword, message = nil, &block)
    description = 'raises ArgumentError on missing keyword'
    description << " #{message}" if message
    example description do
      message = if RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.7'
        "missing keyword: :#{keyword}"
      else
        "missing keyword: #{keyword}"
      end
      expect(&block).to raise_error(ArgumentError, message)
    end
  end

  def it_raises_on_missing_keywords(*keywords, **metadata, &block)
    message = keywords.pop if keywords.last.is_a?(String)
    description = 'raises ArgumentError on missing keywords'
    description << " #{message}" if message
    example description, metadata do
      message = if RUBY_ENGINE == 'ruby' && RUBY_VERSION >= '2.7'
        "missing keywords: #{keywords.map(&:inspect).join(', ')}"
      else
        "missing keywords: #{keywords.join(', ')}"
      end
      expect(&block).to raise_error(ArgumentError, message)
    end
  end

  def it_raises_wrong_number_of_arguments(given:, expected:, &block)
    it 'raises ArgumentError on wrong number of arguments' do
      message_match = if RUBY_ENGINE == "jruby" || RUBY_ENGINE == "ruby" && RUBY_VERSION < "2.3"
        "#{given} for #{expected}"
      else
        "given #{given}, expected #{expected}"
      end
      expect(&block).to raise_error(ArgumentError, a_string_matching(message_match))
    end
  end
end

RSpec.configure do |config|
  config.extend RaiseArgumentErrorHelper
end
