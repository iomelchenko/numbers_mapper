class Indexer
  attr_reader :file_path, :index_file_path, :mapping, :index

  def initialize
    @index           = {}
    @mapping         = mapping
    @file_path       = DICTIONARY_FILE_PATH
    @index_file_path = INDEX_FILE_PATH
  end

  def execute
    words = fetch_words
    index = build_index words
    save_index_file
  end

  private

  def save_index_file
    File.open(index_file_path, "w") { |index_file| index_file.write Marshal.dump(index.to_h) }
  end

  def build_index(words)
    words.each do |word|
      key = generate_word_index_key(word)
      index_element = build_word_index_element(key, word)
      index.merge!(key => index_element)
    end
  end

  def generate_word_index_key(word)
    key = ''
    word.each_char { |char| key << mapping[char] }
    key.to_i
  end

  def build_word_index_element(key, word)
    index_element = index[key] || []
    index_element << word
  end

  def fetch_words
    File.read(file_path).split.map do |word|
      word_length = word.length
      if (word_length > 2 && word_length < 8) || word_length == 10
        word.downcase
      end
    end.compact

  rescue => error
    puts error
  end

  def mapping
    {
      "a" => "2", "b" => "2", "c" => "2",
      "d" => "3", "e" => "3", "f" => "3",
      "g" => "4", "h" => "4", "i" => "4",
      "j" => "5", "k" => "5", "l" => "5",
      "m" => "6", "n" => "6", "o" => "6",
      "p" => "7", "q" => "7", "r" => "7", "s" => "7",
      "t" => "8", "u" => "8", "v" => "8",
      "w" => "9", "x" => "9", "y" => "9", "z" => "9"
    }
  end
end
