# rubocop:disable Style/CaseEquality
module Enumerable
#1.- my_each Method
  def my_each
    arr = self.to_a
    (arr.length).times do |indx|
      yield(arr[indx])
    end
    self
  end
end
