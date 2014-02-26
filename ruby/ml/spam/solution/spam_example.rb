SMOOTHING_FACTOR = 1e-10

def tokenize(input)
  input.downcase.gsub(/[^a-z\s]/, '').split
end

def word_frequency(tokens)
  counts = Hash.new(0)

  tokens.each do |token|
    counts[token] += 1
  end

  frequencies = Hash.new(0.0)
  total_tokens = tokens.length

  counts.each do |token, count|
    frequencies[token] = count.to_f / total_tokens
  end

  frequencies
end

def is_spam?(message, spam_freq, ham_freq)
  tokens = tokenize(message)

  spam_prob = tokens.reduce(0.0) do |prob, word|
    prob + Math.log(spam_freq[word] + SMOOTHING_FACTOR)
  end

  ham_prob = tokens.reduce(0.0) do |prob, word|
    prob + Math.log(ham_freq[word] + SMOOTHING_FACTOR)
  end

  spam_prob > ham_prob
end
