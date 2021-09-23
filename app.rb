module Enumerable
  def my_each
    for v in self do
      yield v
    end
  end

  def my_each_with_index
    for i in 0..self.size - 1 do
      yield self[i], i
    end
  end

  def my_select(&blk)
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
    blk = Proc.new { |item| item unless item.nil? || !item } unless block_given?
    blk = Proc.new { |item| item if arg === item } unless arg.nil?
    my_each { |item| return false unless blk.call(item) }
    true
  end
end

# puts "my_each vs. each"
# numbers = [1, 2, 3, 4, 5]
# numbers.my_each  { |item| puts item }
# numbers.each { |item| puts item }

# puts "my_each_with_index vs. each_with_index"
# numbers.my_each_with_index { |v, i| puts "#{i} #{v}" }
# numbers.each_with_index { |v, i| puts "#{i} #{v}" }

# puts "my_select vs select"
# a = [:foo, 'bar', :bam]
# h = { foo: 0, bar: 1, baz: 2 }
# a1 = a.select { |e| e.to_s.start_with?('b') }
# h1 = h.select { |_k, v| v < 2 }
# puts a1
# puts h1
# a2 = a.my_select { |e| e.to_s.start_with?('b') }
# h2 = h.my_select { |_k, v| v < 2 }
# puts a2
# puts h2

a = %w[food fool foot]
b = [0, 1, 2]
puts "all?"
puts a.all?(/foo/)
puts b.all? { |e| e < 3 }
puts "my_all?"
p a.my_all?(/foo/)
p b.my_all? { |e| e < 3 }

p (/foo/) === 'food'