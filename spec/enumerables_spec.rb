require './enumerables.rb'

describe Enumerable do
  let(:arr_str) { %w[lion ant bear cat fish] }
  let(:arr_int) { [1, 2, 3, 4, 5] }
  let(:arr_dtyp) { [Integer, String, Numeric, Float] }
  let(:arr_rgx) { %w[door box mouse transformer board] }
  let(:rng) { (3..10) }
  let(:hsh) { { one: 30, two: 17 } }

  describe '#my_each' do
    it 'Returns the same input array' do
      expect(arr_str.my_each { |i| i + 'hi' }).to eql(arr_str)
    end

    it 'Creates an enumererator if no block is given' do
      expect((arr_str.my_each.is_a? Enumerator)).to eql(true)
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
    it 'Returns an array and it index' do
      expect(arr_int.my_each_with_index { |val, idx| }).to eql(arr_int.each_with_index { |val, idx| })
    end

    it 'Returns the elements and their indexes of a range converted to an array' do
      expect(rng.my_each_with_index.to_a).to eql(rng.each_with_index.to_a)
    end

    it 'Returns the elements and their indexes of a hash converted to an array' do
      expect(hsh.my_each_with_index.to_a).to eql(hsh.each_with_index.to_a)
    end
  end

  describe '#my_select' do
    it 'Creates an enumererator if no block is given' do
      expect((arr_str.my_select.is_a? Enumerator)).to eql(true)
    end

    it 'Returns a new array only with those elements that meet the condition' do
      expect(rng.my_select { |itm| itm.odd? }).to eql([3, 5, 7, 9])
    end

    it 'Returns an array with the selected elements even when they are strings' do
      expect(arr_str.my_select { |itm| itm == 'fish' }).to eql(['fish'])
    end
  end

  describe '#my_all?' do
    it 'Is true if all the elements in a collection meet the given condition in a block' do
      expect(arr_str.my_all? { |itm| itm.length > 2 }).to eql(arr_str.all? { |itm| itm.length > 2 })
    end

    it 'Is true if all the elements are names of datatypes and no block is given' do
      expect((arr_dtyp.my_all? Class)).to eql((arr_dtyp.all? Class))
    end

    it "Is true if all the elements match the Regex and there's no block" do
      expect(arr_rgx.my_all? /'o'/).to eql(arr_rgx.all? /'o'/)
    end

    it 'Is true if none of the elements equals false or nil, when no block nor argument is given' do
      expect(arr_rgx.my_all?).to be_truthy
    end

    it "Is true if each of the elements is the same object given as argument" do
      expect(arr_str.my_all? 'cat').not_to be_truthy
    end
  end

  describe '#my_any?' do
    it 'Looks for any element in the collection to fulfill the condition given in a block' do
      expect(rng.my_any? { |itm| 4 < itm && itm < 7 }).to eql(rng.any? { |itm| 4 < itm && itm < 7 })
    end

    it 'Is true once an element matches the Regex given as argument' do
      expect(arr_str.my_any? /h/).to be_truthy
    end

    it 'Is true once an element is different from false or nil, when no argument nor block is given' do
      expect(hsh.my_any?).to be_truthy
    end
  end

  describe '#my_none?' do
    it "Looks for none of a collection's elements to fulfill the condition given in a block" do
      expect(rng.none? { |itm| 2 > itm }).to eql(rng.my_none? { |itm| 2 > itm })
    end

    it 'Looks for none of the elements to match the Regex given as argument' do
      expect(hsh.none? /h/).to be_truthy
    end

    it 'Looks for all the elements to be equal to false or nil, when no block nor argument is given' do
      arr_test = [nil, false, 4, nil, 3, false]
      expect(arr_test.my_none?).to eql(arr_test.none?)
    end

    it 'Looks for none of the elements to be same given object as argument' do
      expect(arr_str.my_none? 'moose').to eql(arr_str.none? 'moose')
    end
  end  

  describe '#my_count?' do
    it 'Returns the number of elements are in a collection when is no block given nor argument' do
      expect(arr_int.my_count).to eql(arr_int.count)
    end

    it 'Returns the number of elements that are the given element in the argument' do
      arr_tst = [1, 3, 3, 4, 5, 7, 5, 3]
      expect(arr_tst.my_count(7)).to eql(1)
    end

    it 'Returns the number of elements that meets the condition in the block' do
      expect(arr_int.my_count { |itm| itm.is_a? Numeric }).to eql(5)
    end
  end

  describe '#my_map' do
    it 'Modifys the elements of a range according to the block and returns an array with these new values' do
      expect(rng.my_map { |i| i * 2 }).to eql(rng.map { |i| i * 2 })
    end

    it 'Modifys the elements of an array according to the proc given and returns an array with these new values' do
      myproc = Proc.new { |itm| itm * 3}
      expect(arr_int.my_map(myproc)).to eql([3, 6, 9, 12, 15])
    end

    it 'Creates an enumererator if no block and no proc is given' do
      expect(hsh.my_map.is_a? Enumerator).to eql(true)
    end
  end

  describe '#my_inject' do
    it 'Merges all the items of a collection in an arithmetic operation result, using an initial value and a symbol as given arguments' do
      expect(rng.my_inject(2, :+)).to eql(rng.inject(2, :+))
    end

    it 'Merges all the items of a collection in an arithmetic operation result, using only a symbol as given argument' do
      expect(arr_int.my_inject(:*)).to eql(arr_int.inject(:*))
    end

    it 'Merges all the items of a collection in an operation result, using an initial value as argument and passing a block' do
      expect(arr_int.my_inject(11) { |memo, num| memo + (2 * num) }).to eql(arr_int.inject(11) { |memo, num| memo + (2 * num) })
    end

    it 'Merges all the items of a collection in an operation result, passing only a block' do
      expect(arr_int.my_inject { |memo, num| memo + 1 + num }).to eql(arr_int.inject { |memo, num| memo + 1 + num })
    end
  end

  describe '#multiply_els' do
    it 'Returns the product of all the element in the array given as argument' do
      expect(multiply_els(arr_int)).to eql(120)
    end
  end
end