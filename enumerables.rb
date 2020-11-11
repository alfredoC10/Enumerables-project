# rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/AbcSize
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

  def my_all?(arg = nil)
    counter = 0
    #  Was a block given to the method?
    if block_given?
      my_each { |elmt| counter += 1 if yield(elmt) == true }

    #  If there's no block, is the given argument the name of a data type like Integer, String, Array etc.?
    elsif arg.is_a? Class
      my_each { |elmt| counter += 1 if elmt.class == arg or elmt.is_a? arg }

    # Do all of the elements match the regular expression?
    elsif arg.class == Regexp
      arr_str = map { |x| x.to_s }
      arr_str.my_each { |elmt| counter += 1 if elmt.match?(arg) }

    # Not there a block or an argument?
    elsif arg.nil?
      my_each { |elmt| counter += 1 if elmt != false && !elmt.nil? }

    # My_all? will be used to find out if the collection is made of a specific object
    else
      my_each { |elmt| counter += 1 if elmt == arg }
    end
    counter == to_a.length
  end
end

module Enumerable
  # 5.- ---- my_any? Method ----

  def my_any?(arg = nil)
    counter = 0

    #  Was a block given to the method?
    if block_given?
      my_each { |elmt| counter += 1 if yield(elmt) == true }

    #  If there's no block, is the given argument the name of a data type like Integer, String, Array etc.?
    elsif arg.is_a? Class
      my_each { |elmt| counter += 1 if elmt.class == arg or elmt.is_a? arg }

    # Does any of the elements match the regular expression?
    elsif arg.class == Regexp
      arr_str = map { |x| x.to_s }
      arr_str.my_each { |elmt| counter += 1 if elmt.match?(arg) }

    # Not there a block or an argument?
    elsif arg.nil?
      my_each { |elmt| counter += 1 if elmt != false && !elmt.nil? }

    # My_any? will be used to find out if the collection is made of a specific object
    else
      my_each { |elmt| counter += 1 if elmt == arg }
    end
    counter.positive?
  end
end

module Enumerable
  # 4.- ---- my_none? Method ----

  def my_none?(arg = nil)
    counter = 0

    #  Was a block given to the method?
    if block_given?
      my_each { |elmt| counter += 1 if yield(elmt) == true }

    #  If there's no block, is the given argument the name of a data type like Integer, String, Array etc.?
    elsif arg.is_a? Class
      my_each { |elmt| counter += 1 if elmt.class == arg or elmt.is_a? arg }

    # Do none of the elements match the regular expression?
    elsif arg.class == Regexp
      arr_str = map { |x| x.to_s }
      arr_str.my_each { |elmt| counter += 1 if elmt.match?(arg) }

    # Not there a block or an argument?
    elsif arg.nil?
      my_each { |elmt| counter += 1 if elmt != false && !elmt.nil? }

    # My_none? will be used to find out if the collection is not made of a specific object
    else
      my_each { |elmt| counter += 1 if elmt == arg }
    end
    counter.zero?
  end
end

module Enumerable
  # 7.- ---- my_count Method ----

  def my_count(*arg)
    count = 0

    if block_given?
      my_each do |elmt|
        count += 1 if yield(elmt)
      end
    elsif arg.empty?
      count = size
    else
      my_each do |elmt|
        count += 1 if elmt == arg[0]
      end
    end
    count
  end

  # 8.- ---- my_map Method ----

  def my_map
    return to_enum(:my_map) unless block_given?

    new_arr = []

    if self.class == Array or self.class == Range
      my_each { |i| new_arr.push(yield(i)) }
    elsif self.class == Hash
      my_each { |key, value| new_arr.push(yield(key, value)) }
    end
    new_arr
  end
end

module Enumerable
  # 9.- ---- my_inject Method ----

  def my_inject(*args)
    memo = to_a[0]

    # Case 1: arguments are given but not a block
    if !args.empty? && !block_given?
      # There are an initial value and a symbol which indicates the operation to perform
      if (args[0].is_a? Numeric or args[0].class == String) && args[1].class == Symbol
        memo = args[0]
        if args[1] == :+
          my_each { |elmt| memo += elmt }
        elsif args[1] == :-
          my_each { |elmt| memo -= elmt }
        elsif args[1] == :*
          my_each { |elmt| memo *= elmt }
        elsif args[1] == :/
          my_each { |elmt| memo /= elmt }
        elsif args[1] == :**
          my_each { |elmt| memo **= elmt }
        elsif args[1] == :%
          my_each { |elmt| memo %= elmt }
        end

      elsif args.size == 1 && args[0].class == Symbol # There's only the operation's symbol
        if args[0] == :+
          self[1..-1].my_each { |elmt| memo += elmt }
        elsif args[0] == :-
          self[1..-1].my_each { |elmt| memo -= elmt }
        elsif args[0] == :*
          self[1..-1].my_each { |elmt| memo *= elmt }
        elsif args[0] == :/
          self[1..-1].my_each { |elmt| memo /= elmt }
        elsif args[0] == :**
          self[1..-1].my_each { |elmt| memo **= elmt }
        elsif args[0] == :%
          self[1..-1].my_each { |elmt| memo %= elmt }
        end

      end

      # Case 2: an initial value is given as an argument along with a block
    elsif (args[0].is_a? Numeric or args[0].class == String) && block_given?
      memo = args[0]
      my_each { |elmt| memo = yield(memo, elmt) }

      # Case 3: only a block is given
    elsif args.empty? && block_given?
      self[1..-1].my_each { |elmt| memo = yield(memo, elmt) }
    end

    memo
  end

  # 10.- ---- Method created for testing my_inject method ----

  def multiply_els(array)
    array.my_inject(:*)
  end

  # 11.- ---- Modified my_map method that takes proc ----

  def my_map_proc(&my_proc)
    new_arr = []

    if self.class == Array or self.class == Range
      my_each do |i|
        new_arr.push(my_proc.call(i))
      end
    elsif self.class == Hash
      my_each do |key, value|
        new_arr.push(my_proc.call(key, value))
      end
    end
    new_arr
  end

  # 12.- ---- Modified my_map method that takes proc or block ----

  def my_map_proc_block(*my_proc)
    return 'Only a proc must given as argument' if my_proc.size > 1

    new_arr = []

    if block_given? # Case 1: When the method takes a block

      if self.class == Array or self.class == Range
        my_each do |elmt|
          new_arr.push(yield(elmt))
        end
      elsif self.class == Hash
        my_each do |key, value|
          new_arr.push(yield(key, value))
        end
      end
      new_arr

    elsif my_proc[0].class == Proc # Case 2: When the method takes a proc
      if self.class == Array or self.class == Range
        my_each do |i|
          new_arr.push(my_proc[0].call(i))
        end
      elsif self.class == Hash
        my_each do |key, value|
          new_arr.push(my_proc[0].call(key, value))
        end
      end
      new_arr

    elsif my_proc.empty? && !block_given? # Case 3: When there's no block or proc, the method returns enumerator
      to_enum(:my_map)
    end
  end
end
