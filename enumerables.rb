module Enumerable
  # 1.- ---- my_each Method ----

  def my_each
    return to_enum(:my_each) unless block_given?

    arr = to_a
    arr.length.times do |indx|
      yield(arr[indx])
    end
    self
  end

  # 2.- ---- my_each_with_index Method ----

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    target_arr = to_a
    top = target_arr.length
    0.upto(top - 1) do |i|
      yield(target_arr[i], i)
    end
    self
  end

  # 3.- ---- my_select Method ----

  def my_select
    return to_enum(:my_select) unless block_given?

    if is_a? Hash
      new_hsh = {}
      my_each do |key, value|
        new_hsh[key] = value if yield(key, value)
      end
      new_hsh
    elsif is_a? String
      'Wrong input'
    else
      new_arr = []
      my_each do |elmt|
        filtered_arr.push(elmt) if yield(elmt)
      end
      new_arr
    end
  end
end

module Enumerable
  # 4.- ---- my_all? Method ----

  def my_all?(*arg)
    counter = 0
    #  Was a block given to the method?
    if block_given?
      my_each do |elmt|
        counter += 1 if yield(elmt) == true
      end

    #  If there's no block, is the given argument the name of a data type like Integer, String, Array etc.?
    elsif arg[0].is_a? Class
      my_each do |elmt|
        counter += 1 if elmt.class == arg[0] or elmt.is_a? arg[0]
      end

    #  Is my_all? used to find if the collection is made of a specific thing?
    elsif arg[0].is_a? Object

      if arg[0].class == Regexp # Do all of the elements match the regular expression?
        my_each do |elmt|
          if elmt.class != String
            false
          elsif elmt.match?(arg[0])
            counter += 1
          end
        end

      # Not there a block or an argument?
      elsif arg.empty?
        my_each do |elmt|
          counter += 1 if elmt != false && !elmt.nil?
        end

      # My_all? will be used to find out if the collection is made of a specific object
      else
        my_each do |elmt|
          counter += 1 if elmt == arg[0]
        end
      end
    end
    counter == to_a.length
  end
end

module Enumerable
  # 5.- ---- my_any? Method ----

  def my_any?(*arg)
    counter = 0
  #  Was a block given to the method?
    if block_given?
      self.my_each do |elmt| 
        if yield(elmt) == true
          counter += 1 
        end
      end

    #  If there's no block, is the given argument the name of a data type like Integer, String, Array etc.?
    elsif arg[0].instance_of? Class 
      self.my_each do |elmt|
        if elmt.class == arg[0] or elmt.is_a? arg[0]
          counter += 1
        end
      end
    #  Is my_any? used to find if there's a specific thing within the collection? 
    elsif arg[0].is_a? Object

      if arg[0].class == Regexp # Does any of the elements match the regular expression?
        self.my_each do |elmt|
          if elmt.class != String
            false
          elsif elmt.match?(arg[0])
            counter += 1
          end
        end
      # Not there a block or an argument?
      elsif arg.size == 0
        self.my_each do |elmt|
          if elmt != false && elmt != nil
            counter +=1
          end
        end
      # My_any? will be used to look for a specific object within the collection
      else
        self.my_each do |elmt|
          if elmt == arg[0]
            counter += 1
          end
        end
      end
    end

    if counter > 0 
      true
    else
      false
    end

  end

  # 6.- ---- my_none? Method ----

  def my_none?(*arg)

    counter = 0
    #  Was a block given to the method?
    if block_given?
      self.my_each do |elmt| 
        if yield(elmt) == true
          counter += 1 
        end
      end
      if counter == 0 
        true
      else
        false
      end
    #  If there's no block, is the given argument the name of a data type like Integer, String, Array etc.?
    elsif arg[0].instance_of? Class 
      self.my_each do |elmt|
        if elmt.class == arg[0] or elmt.is_a? arg[0]
          counter += 1
        end
      end
      if counter == 0 
        true
      else
        false
      end
    #  Here my_none? will find if a specific thing isn't within the collection
    elsif arg[0].is_a? Object

      if arg[0].class == Regexp # Do none of the elements match the regular expression?
        self.my_each do |elmt|
          if elmt.class != String
            false
          elsif elmt.match?(arg[0])
            counter += 1
          end
        end
        if counter == 0
          true
        else
          false
        end
      # Not there a block or an argument?
      elsif arg.size == 0
        self.my_each do |elmt|
          if elmt != false && elmt != nil
            counter +=1
          end
        end
        if counter == 0
          true
        else
          false
        end
      #  Here my_none? is going to check that a specific object isn't inside the collection
      else
        self.my_each do |elmt|
          if elmt == arg[0]
            counter += 1
          end
        end
        if counter == 0 
          true
        else
          false
        end
      end

    end

  end
end

module Enumerable
  # 7.- ---- my_count Method ----

  def my_count(*arg)

    count = 0

    if block_given?
      self.my_each do |elmt|
        if yield(elmt)
          count += 1
        end
      end
    elsif arg.empty?
      count = self.size
    else
      self.my_each do |elmt|
        if elmt == arg[0]
          count += 1
        end
      end
    end
    count
  end

  # 8.- ---- my_map Method ----

  def my_map

    return to_enum(:my_map) unless block_given?
    new_arr = []
  
    if self.class == Array or self.class == Range
      self.my_each { |i| new_arr.push(yield(i)) }
    elsif self.class == Hash
      self.my_each {|key, value| new_arr.push(yield(key, value))}
    end
    new_arr
  end

end

module Enumerable
  # 9.- ---- my_inject Method ----

  def my_inject(*args) # Variable arguments or parameters

    memo = self.to_a[0]

  # Case 1: arguments are given but not a block
    if !args.empty? && !block_given? 
      if (args[0].is_a? Numeric or args[0].class == String) && args[1].class == Symbol # There are an initial value and a symbol which indicates the operation to perform  
        memo = args[0]
        if args[1] == :+
          self.my_each {|elmt| memo = memo + elmt}
        elsif args[1] == :-
          self.my_each {|elmt| memo = memo - elmt}
        elsif args[1] == :*
          self.my_each {|elmt| memo = memo * elmt}
        elsif args[1] == :/
          self.my_each {|elmt| memo = memo / elmt}
        elsif args[1] == :**
          self.my_each {|elmt| memo = memo ** elmt}
        elsif args[1] == :%
          self.my_each {|elmt| memo = memo % elmt}
        end

      elsif args.size == 1 && args[0].class == Symbol # There's only the operation's symbol
        if args[0] == :+
          self[1..-1].my_each {|elmt| memo = memo + elmt}
        elsif args[0] == :-
          self[1..-1].my_each {|elmt| memo = memo - elmt}
        elsif args[0] == :*
          self[1..-1].my_each {|elmt| memo = memo * elmt}
        elsif args[0] == :/
          self[1..-1].my_each {|elmt| memo = memo / elmt}
        elsif args[0] == :**
          self[1..-1].my_each {|elmt| memo = memo ** elmt}
        elsif args[0] == :%
          self[1..-1].my_each {|elmt| memo = memo % elmt}
        end 

      end

  # Case 2: an initial value is given as an argument along with a block
    elsif (args[0].is_a? Numeric or args[0].class == String) && block_given?
      memo = args[0]
      self.my_each {|elmt| memo = yield(memo, elmt)}

  # Case 3: only a block is given 
    elsif args.empty? && block_given?
      self[1..-1].my_each {|elmt| memo = yield(memo, elmt)}
    end

    memo

  end

  # 10.- ---- Method created for testing my_inject method ----

  def multiply_els(array)

    array.my_inject(:*)
  end

  # 11.- ---- Modified my_map method that takes proc ----

  def my_map(&my_proc)

    new_arr = []

    if self.class == Array or self.class == Range
      self.my_each do |i|
        new_arr.push(my_proc.call(i))
      end
    elsif self.class == Hash
      self.my_each do |key, value|
        new_arr.push(my_proc.call(key, value))
      end
    end
    new_arr
  end

  # 12.- ---- Modified my_map method that takes proc or block ----

  def my_map(*my_proc)

    return "Only a proc must given as argument" if my_proc.size > 1
    new_arr = []

    if block_given? # Case 1: When the method takes a block
      if self.class == Array or self.class == Range
        self.my_each do |elmt|
          new_arr.push(yield(elmt))
        end
      elsif self.class == Hash
        self.my_each do |key, value|
          new_arr.push(yield(key, value))
        end
      end
      new_arr

    elsif my_proc[0].class == Proc  # Case 2: When the method takes a proc
      if self.class == Array or self.class == Range
        self.my_each do |i|
          new_arr.push(my_proc[0].call(i))
        end
      elsif self.class == Hash
        self.my_each do |key, value|
          new_arr.push(my_proc[0].call(key, value))
        end
      end
      new_arr

    elsif my_proc.empty? && !block_given? # Case 3: When there's no block or proc, the method returns enumerator
      to_enum(:my_map)
    end
  end

end