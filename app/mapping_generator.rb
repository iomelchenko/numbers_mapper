class MappingGenerator
  attr_reader :index_file_path, :phone_number, :index

  def initialize(phone_number)
    @index_file_path = INDEX_FILE_PATH
    @phone_number    = phone_number
    @index           = fetch_index
  end

  def execute
    results = []
    pairs = fetch_words(pair_combinations)
    combine_pair_results pairs, results
    results = sort_pairs results
    puts results.to_s
    results
  end

  private

  def fetch_index
    Marshal.load File.read index_file_path
  rescue => error
    puts "#{error}. Please create index file"
  end

  def pair_combinations
    (3..7).map do |first_el|
      first_el.to_s + (10 - first_el).to_s
    end
  end

  def combine_pair_results(pairs, results)
    pairs.each do |pair|
      pair[0].each do |el_0|
        pair[1].each do |el_1|
          results << [el_0, el_1]
        end
      end
    end
  end

  def sort_pairs(results)
    results.sort_by { |el| el[1] }.sort_by { |el| el[0] }
  end

  def fetch_words(combinations)
    all_words = []
    combinations.each do |el|
      words_for_number = []
      start_idx = 0
      length = el.split('').map(&:to_i)
      fetch_for_number_part(length, words_for_number, start_idx)

      unless words_for_number.empty? || words_for_number.length < length.count
        all_words << words_for_number
      end
    end

    all_words
  end

  def fetch_for_number_part(length, words_for_number, start_idx)
    length.each do |len|
      words_for_part_number = index[phone_number[start_idx, len].to_i]
      break unless words_for_part_number
      words_for_number << words_for_part_number
      start_idx += len
    end
  end
end
