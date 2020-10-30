# rubocop:disable Style/CaseEquality
module Enumerable
#1.- my_each Method
  def my_each
    return to_enum(:my_each) unless block_given?
    arr = self.to_a
    (arr.length).times do |indx|
      yield(arr[indx])
    end
    self
  end


#2.- my_each_with_index Method
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    target_arr = self.to_a
    top = target_arr.length
    0.upto(top - 1) do |i|
      yield(target_arr[i], i)
    end
    self
  end


#3.- my_select Method 
end
