require './enumerables.rb'

describe Enumerable do
  let(:arr_str) {%w[lion ant bear cat fish]}
  let(:arr_int) {[1, 2, 3, 4, 5]}
  describe '#my_each' do
    it 'Returns the same input array' do
      expect(arr_str.my_each {|i| i + 'hi'}).to eql(arr_str)
    end
  end
end