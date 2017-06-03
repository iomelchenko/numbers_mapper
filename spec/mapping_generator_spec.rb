describe MappingGenerator do
  let(:phone_numbers_mapping) { { "6686787825" => [["motor","usual"], ["noun", "struck"],
                                                   ["nouns", "truck"], ["nouns","usual"],
                                                   ["onto", "struck"], "motortruck"] ,
                                  "2282668687" => [["act","amounts"], ["act", "contour"],
                                                   ["acta", "mounts"], ["bat","amounts"],
                                                   ["bat", "contour"],["cat", "contour"],
                                                    "catamounts"] }
                              }
  let(:phone_number_1) { phone_numbers_mapping.keys[0] }
  let(:phone_number_2) { phone_numbers_mapping.keys[1] }

  it "should create valid mapping for phone_number 6686787825" do
    expect(described_class.new(phone_number_1).execute).to eql phone_numbers_mapping[phone_number_1]
  end

  it "should create valid mapping for phone_number 2282668687" do
    expect(described_class.new(phone_number_2).execute).to eql phone_numbers_mapping[phone_number_2]
  end

  it "should be performed within 1000ms" do
    expect(Benchmark.realtime { described_class.new(phone_number_1).execute }).to be < 1
  end
end
