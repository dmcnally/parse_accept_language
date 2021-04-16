require 'spec_helper'
require 'pry'

=begin
parse_accept_language("en", ["en-US", "fr-CA", "fr-FR"])
returns: ["en-US"]

parse_accept_language("fr", ["en-US", "fr-CA", "fr-FR"])
returns: ["fr-CA", "fr-FR"]

parse_accept_language("fr-FR, fr", ["en-US", "fr-CA", "fr-FR"])
returns: ["fr-FR", "fr-CA"]
=end

def parse_accept_language(preferred_language, available_languages)
  preferred_languages = preferred_language.split(',').map(&:strip)

  accepted_languages = []
  preferred_languages.each do |language|
    available_languages.select {|available_language| matches_language_full_or_partial?(available_language, language) }.each do |matched_language|
      accepted_languages << matched_language unless accepted_languages.include?(matched_language)
    end
  end
  accepted_languages
end

def matches_language_full_or_partial?(available_language, language)
  available_language.split('-').first == language or available_language == language
end

describe 'Parsing accepted languages' do

  let(:accepted_languages) { ["en-US", "fr-CA", "fr-FR"] }

  it 'returns en-US for en' do
    result = parse_accept_language("en", accepted_languages)

    expect(result).to eq(['en-US'])
  end

  it 'returns fr-CA and fr-FR for fr' do
    result = parse_accept_language("fr", accepted_languages)

    expect(result).to eq(["fr-CA", "fr-FR"])
  end

  it 'returns fr-CA for fr-CA' do
    result = parse_accept_language("fr-CA", accepted_languages)

    expect(result).to eq(["fr-CA"])
  end

  it 'returns fr-FR and fr-CA for fr-FR, fr' do
    result = parse_accept_language("fr-FR, fr", accepted_languages)

    expect(result).to eq(["fr-FR", "fr-CA"])
  end

end
