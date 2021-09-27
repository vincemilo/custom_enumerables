# numbers = [1, 2, 3, 4, 5]
# h = { foo: 0, bar: 1, baz: 3 }
# a = [:foo, 'bar', :bam]

# def test_a(arr)
#   arr.each { |e| p e }
# end

# def test_h(hash)
#   hash.each { |k, v| p k, v }
# end

# test_a(a)
# test_h(h)

# p h.assoc(:bar)

# p a.count('bar')

nums = (5..10)
block = proc { |sum, n| sum + n }

def func(arg, &blk)
  i = 0
  arg.each { |e| i = blk.call(i, e) }
  i
end

p func(nums, &block)
