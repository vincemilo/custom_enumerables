module Enumerable
  def my_each
    return to_enum unless block_given?

    if instance_of?(Array)
      for v in self do
        yield v
      end
    elsif instance_of?(Hash)
      for k[v] in self do
        yield k[v]
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
    else
      my_each { |item| all_true = false unless arg === item }
    end
    all_true
  end
end

numbers = [1, 2, 3, 4, 5]
h = { foo: 0, bar: 1, baz: 2 }
puts "each"
numbers.each { |item| puts item }
h.each {|key, value| puts "#{key}: #{value}"}
p numbers.each
puts "my_each"
numbers.my_each  { |item| puts item }
h.each {|key, value| puts "#{key}: #{value}"}
p numbers.my_each

puts "each_with_index"
numbers.each_with_index { |v, i| puts "#{i} #{v}" }
p numbers.each_with_index
puts "my_each_with_index"
numbers.my_each_with_index { |v, i| puts "#{i} #{v}" }
p numbers.my_each_with_index

puts "my_select vs select"
a = [:foo, 'bar', :bam]
h = { foo: 0, bar: 1, baz: 2 }
a1 = a.select { |e| e.to_s.start_with?('b') }
h1 = h.select { |_k, v| v < 2 }
puts a1
puts h1
a2 = a.my_select { |e| e.to_s.start_with?('b') }
h2 = h.my_select { |_k, v| v < 2 }
puts a2
puts h2

a = %w[food fool foot]
b = [0, 1, 2]
puts "all?"
p a.all?(/foo/)
p b.all? { |e| e < 3 }
puts "my_all?"
p a.my_all?(/foo/)
p b.my_all? { |e| e < 3 }
