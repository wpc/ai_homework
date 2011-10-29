def linear_regression(xset, yset)
  raise 'xsize not eq to y size' unless xset.size == yset.size

  data = Hash[xset.zip(yset)]
  m = data.size.to_f
  w1 = (m * data.inject(0) { |sum, pair| sum + pair.first * pair.last } - xset.inject(:+) * yset.inject(:+)) / (m * xset.inject(0) { |sum, x| sum + x * x} - xset.inject(:+) * xset.inject(:+) )
  w0 = yset.inject(:+).to_f / m - w1 * xset.inject(:+) / m

  [w1, w0]
end

linear_regression([0, 1, 2, 3, 4], [3, 6, 7, 8, 11])
