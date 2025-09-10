require 'benchmark'

class ArraySet < Set
  def initialize(arr=[])
    super(arr)
    @arr = self.to_a
  end

  def add(el)
    unless self.include?(el)
      super(el)
      @arr.append(el)
    end
  end

  def to_a
    if @arr.nil?
      super
    else
      @arr
    end
  end
  
  def [](i)
    @arr[i]
  end
end

def run_benchmark
  n = 100_000
  Benchmark.bm do |x|
    x.report("Set#to_a") { 
      s = Set.new
      0.upto(n) do |i|
        s.add(i)
        s.to_a
      end
    }

    x.report("ArraySet#to_a") { 
      s = ArraySet.new
      0.upto(n) do |i|
        s.add(i)
        s.to_a
      end
    }
  end
end

# > run_benchmark
#                    user     system      total        real
# Set#to_a       3.143631   2.833048   5.976679 (  6.364861)
# ArraySet#to_a  0.017347   0.001403   0.018750 (  0.019443)