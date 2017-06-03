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
    singles = index[phone_number.to_i] || []
    combine_pair_results(pairs, results, singles)
    results = sort_pairs(results)
    combine_single_results(singles, results)

    if results.flatten.empty?
      deltas = fetch_words(delta_combinations)
      combine_deltas_results(deltas, results)
      results = sort_deltas(results)
    end

    print_results(results)
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

  def combine_pair_results(pairs, results, single = [])
    pairs.each do |pair|
      pair[0].each do |el_0|
        pair[1].each do |el_1|
          insert_result(results, [el_0, el_1], single)
        end
      end
    end
  end

  def sort_pairs(results)
    results.sort_by { |el| el[1] }.sort_by { |el| el[0] }
  end

  def delta_combinations
    %w[3 3 4].permutation.map(&:join).uniq
  end

  def combine_deltas_results(deltas, results, single = [])
    deltas.each do |delta|
      delta[0].each do |el_0|
        delta[1].each do |el_1|
          delta[2].each do |el_2|
            insert_result(results, [el_0, el_1, el_2], single)
          end
        end
      end
    end
  end

  def sort_deltas(results)
    results.sort_by { |el| el[2] }.sort_by { |el| el[1] }.sort_by { |el| el[0] }
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

  def insert_result(results, el, single)
    results.push(el) unless already_exists_single?(el, single)
  end

  def combine_single_results(single, results)
    single.each { |el| results << el }
  end

  def already_exists_single?(el, single)
    single.include? el.join
  end

  def print_results(results)
    puts results.to_s.gsub('"', '&quot;')
  end
end
