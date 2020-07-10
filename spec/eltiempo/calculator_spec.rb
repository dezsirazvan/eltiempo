RSpec.describe Eltiempo::Calculator do
  it "returns error because the city don t exist" do
    expect(Eltiempo::Calculator.new('Test City').today).to eql(nil)
  end

  it "returns error because the token is invalid" do
    expect(Eltiempo::Calculator.new('Gavà', 'testtoken').today).to eql(nil)
  end

  it "returns the average min temperature" do
    expect(Eltiempo::Calculator.new("Gavà").today.is_a? Array).to eql(true)
  end

  it "returns the average min temperature" do
    expect(Eltiempo::Calculator.new("Gavà").av_min.is_a? Integer).to eql(true)
  end

  it "returns the average max temperature" do
    expect(Eltiempo::Calculator.new("Gavà").av_max.is_a? Integer).to eql(true)
  end
end