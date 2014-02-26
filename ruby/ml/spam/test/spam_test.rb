require 'yaml'
require_relative '../lib/spam'


describe 'tokenize' do
  it 'breaks a string into words separated by spaces' do
    input = 'these pretzels are making me thirsty'

    expect(tokenize(input)).to eq(
      ['these', 'pretzels', 'are', 'making', 'me', 'thirsty'])
  end

  it 'breaks words on any whitespace' do
    input = "first\tsecond\nthird \t\n\t fourth"

    expect(tokenize(input)).to eq(["first", "second", "third", "fourth"])
  end

  it 'downcases each token' do
    input = 'Faizaan the Wizard'

    expect(tokenize(input)).to eq(['faizaan', 'the', 'wizard'])
  end

  it 'strips out non-alpha characters' do
    input = "foo, ba'r \"baz\" ...bat!!1!"

    expect(tokenize(input)).to eq(['foo', 'bar', 'baz', 'bat'])
  end
end

describe 'word_frequency' do
  it 'calculates frequency of tokens' do
    tokens = ['foo', 'bar', 'baz', 'foo']

    frequencies = word_frequency(tokens)
    expect(frequencies['foo']).to eq(0.5)
    expect(frequencies['baz']).to eq(0.25)
  end

  it 'gives a frequency of zero to non-existent tokens' do
    tokens = ['foo', 'bar', 'baz']

    frequencies = word_frequency(tokens)
    expect(frequencies['bat']).to eq(0.0)
  end

  it 'returns an empty hash when there are no tokens' do
    expect(word_frequency([])).to eq({})
  end
end

describe 'is_spam?' do

  let(:data_dir) { File.join(File.dirname(__FILE__), '../data') }

  let(:spam_freq) do
    freq = YAML.load(File.read(File.join(data_dir, 'spam_freq.yml')))
    freq.default = 0
    freq
  end

  let(:ham_freq) do
    freq = YAML.load(File.read(File.join(data_dir, 'ham_freq.yml')))
    freq.default = 0
    freq
  end

  let(:spam_message) do
    File.read(File.join(data_dir, 'spam_test'))
  end

  let(:ham_message) do
    File.read(File.join(data_dir, 'ham_test'))
  end

  it 'identifies spam' do
    expect(is_spam?(spam_message, spam_freq, ham_freq)).to be_true
  end

  it 'identifies ham' do
    expect(is_spam?(ham_message, spam_freq, ham_freq)).to be_false
  end
end
