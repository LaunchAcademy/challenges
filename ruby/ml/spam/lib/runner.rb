require_relative 'spam'

# The script will test if a given email is spam or not spam (aka ham). Save the
# email to a file and run it through the script with the following command:
#
# $ ruby lib/runner.rb <path to email>
#
# e.g. ruby lib/runner data/spam_test

if ARGV.count < 1
  puts "usage: ruby #{__FILE__} <TEST_EMAIL_PATH>"
  exit 1
end

test_email_filepath = ARGV[0]

if !File.exists?(test_email_filepath)
  puts "fatal: no file exists at #{test_email_filepath}"
  exit 1
end

data_dir = File.join(File.dirname(__FILE__), '../data')

raw_spam = File.read(File.join(data_dir, 'raw_spam'))
raw_ham = File.read(File.join(data_dir, 'raw_ham'))

spam_freq = word_frequency(tokenize(raw_spam))
ham_freq = word_frequency(tokenize(raw_ham))

email_contents = File.read(ARGV[0])

if is_spam?(email_contents, spam_freq, ham_freq)
  puts "VERDICT: SPAM"
else
  puts "VERDICT: HAM"
end
