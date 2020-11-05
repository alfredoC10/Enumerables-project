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
  def my_select
    return to_enum(:my_select) unless block_given?
    if self.is_a? Hash
      new_hsh = {}
      self.my_each do |key, value| 
        if yield(key, value)
          new_hsh[key] = value
        end
      end
      new_hsh
    elsif self.is_a? String
      return "Wrong input"
    else
      new_arr = []
      self.my_each do |elmt|
        if yield(elmt)
          filtered_arr.push(elmt)
        end
      end
      return new_arr
    end
  end

#4.- my_all? method
  def my_all?(*arg)
    counter = 0

    if block_given?
      self.my_each do |elmt| 
        if yield(elmt) == true
          counter += 1 
        end
      end
      if counter == self.to_a.length 
        true
      else
        false
      end

    elsif arg[0].instance_of? Class 
      self.my_each do |elmt|
        if elmt.class == arg[0]
          counter += 1
        end
      end
      if counter == self.to_a.length 
        true
      else
        false
      end

    elsif arg[0].is_a? Object

      if arg[0].class == Regexp
        self.my_each do |elmt|
          if elmt.class != String
            false
          elsif elmt.match?(arg[0])
            counter += 1
          end
        end
        if counter == self.to_a.length
          true
        else
          false
        end

      elsif arg.size == 0
        self.my_each do |elmt|
          if elmt != false && elmt != nil
            counter +=1
          end
        end
        if counter == self.to_a.length
          true
        else
          false
        end

      else
        self.my_each do |elmt|
          if elmt == arg[0]
            counter += 1
          end
        end
        if counter == self.to_a.length 
          true
        else
          false
        end
      end

    end

  end

#5.- my_any? method
  def my_any?(*arg)
    counter = 0
  # Was a block given to the method?
    if block_given?
      self.my_each do |elmt| 
        if yield(elmt) == true
          counter += 1 
        end
      end
      if counter > 0 
        true
      else
        false
      end
    # Is the argument an Integer, Float, string, etc.?
    elsif arg[0].instance_of? Class 
      self.my_each do |elmt|
        if elmt.class == arg[0]
          counter += 1
        end
      end
      if counter > 0 
        true
      else
        false
      end
    # When my_any is used to find if there's a specific object within the collection 
    elsif arg[0].is_a? Object

      if arg[0].class == Regexp #Does any of the elements match the regular expression?
        self.my_each do |elmt|
          if elmt.class != String
            false
          elsif elmt.match?(arg[0])
            counter += 1
          end
        end
        if counter > 0
          true
        else
          false
        end
      #When my_any is used without a block nor an argument
      elsif arg.size == 0
        self.my_each do |elmt|
          if elmt != false && elmt != nil
            counter +=1
          end
        end
        if counter > 0
          true
        else
          false
        end

      else
        self.my_each do |elmt|
          if elmt == arg[0]
            counter += 1
          end
        end
        if counter > 0 
          true
        else
          false
        end
      end

    end

  end

end
