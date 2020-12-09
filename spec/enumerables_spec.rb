require './enumerables.rb'

describe Enumerable do
  let(:arr_str) {%w[lion ant bear cat fish]}
  let(:arr_int) {[1, 2, 3, 4, 5]}

  describe '#my_each' do
    it 'Returns the same input array' do
      expect(arr_str.my_each { |i| i + 'hi' }).to eql(arr_str)
    end

    it 'Creates an enumererator if no block is given' do
      expect(arr_str.my_each.is_a? Enumerator).to eql(true)
    end

    it "Performs the specified operation in the given block with each of an array's items" do
      nw = []
      arr_int.my_each { |x| nw.push(x + 2) }
      expect(nw).to eql([3, 4, 5, 6, 7])
      empt = []
      arr_str.my_each { |i| empt.push(i + '-hi') }
      expect(empt).to eql(%w[lion-hi ant-hi bear-hi cat-hi fish-hi])
    end
  end

  describe '#my_each_with_index' do
    it 'Returns an array and it index'do
      expect(arr_int.my_each_with_index { |val, idx| }).to eql(arr_int.each_with_index { |val, idx| })
  end
end