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
  def it_raises_on_unknown_keyword(keyword, artificial: false, &block)
    it 'raises ArgumentError on unknown keyword' do
      message = if defined?(Rubinius) && !artificial
        a_string_starting_with("method 'initialize':")
      elsif RUBY_ENGINE == 'ruby' && RUBY_VERSION < '2.2' && !artificial
        a_string_starting_with('wrong number of arguments')
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
      expect(&block).to raise_error(ArgumentError, "missing keyword: #{keyword}")
    end
  end

  def it_raises_on_missing_keywords(*keywords, **metadata, &block)
    message = keywords.pop if keywords.last.is_a?(String)
    description = 'raises ArgumentError on missing keywords'
    description << " #{message}" if message
    example description, metadata do
      expect(&block).to raise_error(ArgumentError, "missing keywords: #{keywords.join(', ')}")
    end
  end

  def it_raises_wrong_number_of_arguments(&block)
    it 'raises ArgumentError on wrong number of arguments' do
      message_start = if defined?(Rubinius)
        "method 'initialize':"
      else
        'wrong number of arguments'
      end
      expect(&block).to raise_error(ArgumentError, a_string_starting_with(message_start))
    end
  end
end

RSpec.configure do |config|
  config.extend RaiseArgumentErrorHelper
end
