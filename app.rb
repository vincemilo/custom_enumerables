module Enumerable
  def my_each
    return to_enum unless block_given?

    if instance_of?(Hash)
      for k, v in self do
        yield k, v
      end
    else
      for v in self do
        yield v
      end
    end
  end

  def my_each_with_index
    return to_enum(:each_with_index) unless block_given?

    for i in 0..self.size - 1 do
      yield self[i], i
    end
  end

  def my_select(&blk)
    return to_enum(:select) unless block_given?

    arr = []
    hash = {}

    if instance_of?(Array)
      my_each { |item| arr.push(item) if blk.call(item) }
      arr
    elsif instance_of?(Hash)
      my_each { |k, v| hash[k] = v if blk.call(k, v) }
      hash
    end
  end

  def my_all?(arg = nil, &blk)
    all_true = true
    if block_given?
      my_each { |item| all_true = false unless blk.call(item) }
    elsif arg
      my_each { |item| all_true = false unless arg === item }
    else
      my_each { |item| all_true = false unless item }
    end
    all_true
  end

  def my_any?(arg = nil, &blk)
    one_true = false
    if instance_of?(Array)
      if block_given?
        my_each { |item| one_true = true if blk.call(item) }
      elsif arg
        my_each { |item| one_true = true if arg === item }
      else
        my_each { |item| one_true = true if item }
      end
    elsif instance_of?(Hash)
      if block_given?
        my_each { |k, v| one_true = true if blk.call(k, v) }
      elsif arg
        my_each { |k, v| one_true = true if arg === [k, v] }
      else
        one_true = true unless empty?
      end
    end
    one_true
  end

  def my_none?(arg = nil, &blk)
    none_true = true
    if block_given?
      my_each { |item| none_true = false if blk.call(item) }
    elsif arg
      my_each { |item| none_true = false if arg === item }
    else
      my_each { |item| none_true = false if item }
    end
    none_true
  end

  def my_count(arg = nil, &blk)
    accumulator = 0
    if block_given?
      if arg
        warn("#{__FILE__}:#{__LINE__}: warning: given block not used")
        my_each { |e| accumulator += 1 if arg === e }
      else
        my_each { |e| accumulator += 1 if blk.call(e) }
      end
    elsif arg
      my_each { |e| accumulator += 1 if arg === e }
    else
      my_each { |e| accumulator += e }
    end
    accumulator
  end

  def my_map(a_proc = nil, &blk)
    arr = []
    if a_proc
      my_each { |e| arr.push(a_proc.call(e)) }
      arr
    else
      return to_enum(:map) unless block_given?

      my_each { |e| arr.push(blk.call(e)) }
    end
    arr
  end

  def my_inject(a = nil, b = nil, &blk)
    accumulator = ''
    accumulator = 0 if instance_of?(Array) && my_all? { |e| e.instance_of?(Integer) } || instance_of?(Range)
    accumulator += a unless a.nil? || a.instance_of?(Symbol)
    accumulator += 1 if a == :* || a == :/
    if block_given?
      my_each { |e| accumulator = blk.call(accumulator, e) }
    elsif a.instance_of?(Symbol)
      case a
      when :+
        my_each { |e| accumulator += e }
      when :-
        my_each { |e| accumulator -= e }
      when :*
        my_each { |e| accumulator *= e }
      when :/
        my_each { |e| accumulator /= e }
      end
    elsif b.instance_of?(Symbol)
      case b
      when :+
        my_each { |e| accumulator += e }
      when :-
        my_each { |e| accumulator -= e }
      when :*
        my_each { |e| accumulator *= e }
      when :/
        my_each { |e| accumulator /= e }
      end
    end
    accumulator
  end
end

numbers = [1, 2, 3, 4, 5]
h = { foo: 0, bar: 1, baz: 2 }
a = [:foo, 'bar', :bam]
a2 = %w[food fool foot]
a3 = [0, 1, 2]

puts ''
puts "each"
numbers.each { |item| puts item }
h.each { |key, value| puts "#{key}: #{value}" }
p numbers.each
puts ''
puts "my_each"
numbers.my_each { |item| puts item }
h.my_each { |key, value| puts "#{key}: #{value}" }
p numbers.my_each

puts ''
puts "each_with_index"
numbers.each_with_index { |v, i| puts "#{i} #{v}" }
p numbers.each_with_index
puts ''
puts "my_each_with_index"
numbers.my_each_with_index { |v, i| puts "#{i} #{v}" }
p numbers.my_each_with_index

puts ''
puts "select"
p a.select { |e| e.to_s.start_with?('b') }
p h.select { |_k, v| v < 2 }
puts ''
puts "my_select"
p a.my_select { |e| e.to_s.start_with?('b') }
p h.my_select { |_k, v| v < 2 }

puts ''
puts "all?"
p a.all?
p a2.all?(/foo/)
p a3.all? { |e| e < 3 }
puts ''
puts "my_all?"
p a.my_all?
p a2.my_all?(/foo/)
p a3.my_all? { |e| e < 3 }

puts ''
puts "any?"
p h.any?([:bar, 1]) # => true
p h.any?([:bar, 0]) # => false
p h.any?([:baz, 1]) # => false
p h.any? {|key, value| value < 3 } # => true
p h.any? {|key, value| value > 3 } # => false
p [nil, 0, false].any? # => true
p [nil, false].any? # => false
p [].any? # => false
p [0, 1, 2].any? {|element| element > 1 } # => true
p [0, 1, 2].any? {|element| element > 2 } # => false
p ['food', 'drink'].any?(/foo/) # => true
p ['food', 'drink'].any?(/bar/) # => false
p [].any?(/foo/) # => false
p [0, 1, 2].any?(1) # => true
p [0, 1, 2].any?(3) # => false

puts ''
puts "my_any?"
p h.my_any?([:bar, 1]) # => true
p h.my_any?([:bar, 0]) # => false
p h.my_any?([:baz, 1]) # => false
p h.my_any? {|key, value| value < 3 } # => true
p h.my_any? {|key, value| value > 3 } # => false
p [nil, 0, false].my_any? # => true
p [nil, false].my_any? # => false
p [].my_any? # => false
p [0, 1, 2].my_any? {|element| element > 1 } # => true
p [0, 1, 2].my_any? {|element| element > 2 } # => false
p ['food', 'drink'].my_any?(/foo/) # => true
p ['food', 'drink'].my_any?(/bar/) # => false
p [].my_any?(/foo/) # => false
p [0, 1, 2].my_any?(1) # => true
p [0, 1, 2].my_any?(3) # => false

puts ''
puts "count"
p [0, 1, 2].count # => 3
p [].count # => 0
p [0, 1, 2, 0].count(0) # => 2
p [0, 1, 2].count(3) # => 0
p [0, 1, 2, 3].count { |element| element > 1 } # => 2
p [0, 1, 2, 3].count(2) { |element| element > 1 } # => 1
puts ''
puts "my_count"
p [0, 1, 2].my_count # => 3
p [].my_count # => 0
p [0, 1, 2, 0].my_count(0) # => 2
p [0, 1, 2].my_count(3) # => 0
p [0, 1, 2, 3].my_count { |element| element > 1 } # => 2
p [0, 1, 2, 3].my_count(2) { |element| element > 1 } # => 1

puts ''
puts "map"
a = [:foo, 'bar', 2]
a1 = a.map {|element| element.class }
p a1 # => [Symbol, String, Integer]
p a.map
puts ''
puts "my_map"
a = [:foo, 'bar', 2]
a1 = a.my_map {|element| element.class }
p a1 # => [Symbol, String, Integer]
p a.my_map

puts ''
puts "inject"
# Sum some numbers
p (5..10).inject(:+) #=> 45
# Same using a block and inject
p (5..10).inject { |sum, n| sum + n } #=> 45
# Multiply some numbers
p (5..10).inject(1, :*) #=> 151200
# Same using a block
p (5..10).inject(1) { |product, n| product * n } #=> 151200
# find the longest word
longest = %w{cat sheep bear}.inject do |memo, word|
  memo.length > word.length ? memo : word
end
p longest #=> "sheep"
puts ''
puts "my_inject"
p (5..10).my_inject(:+)                             #=> 45
p (5..10).my_inject { |sum, n| sum + n }            #=> 45
p (5..10).my_inject(1, :*)
p (5..10).my_inject(1) { |product, n| product * n }
longest = %w{cat sheep bear}.my_inject do |memo, word|
  memo.length > word.length ? memo : word
end
p longest

def multiply_els(arr)
  arr.inject(:*)
end
puts ''
puts 'my_map taking a proc'
block = proc { |e| e }
block2 = proc { |e| e if e %2 == 0 }

p [1,2,3,4,5].my_map(block)
p [1,2,3,4,5].my_map(block2)

