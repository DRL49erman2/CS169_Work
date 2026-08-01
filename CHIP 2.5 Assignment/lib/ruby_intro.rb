# When done, submit this entire file to the autograder.

# Part 1

def sum(arr)
  # YOUR CODE HERE
  #An array of integers as an argument
  #Returns the sum of its elements
  total = 0
  arr.each do |elements|
    total = total + elements
  end
  return total
end

def max_2_sum(arr)
  # YOUR CODE HERE
  #An array of integers as an argument
  #Returns the sum of its TWO LARGEST elements
  biggest = -Float::INFINITY
  second_biggest = -Float::INFINITY
  if arr.empty?
    return 0
  end 
  if arr.length == 1
    return arr.first
  end
  arr.each do |elements|
    if elements >= biggest
      second_biggest = biggest
      biggest = elements
    elsif elements > second_biggest
      second_biggest = elements
    end
  end
  return biggest + second_biggest
end

def sum_to_n?(arr, n)
  # YOUR CODE HERE
  #An array of integers as an argument
  #n as an argument
  #Returns True if any two elements in arr sum to name
  if arr.empty?
    return false
  end
  if arr.length == 1
    return false
  end
  arr.combination(2).any? {|a, b| a + b == n}
    #Compare second element to rest and so on
end


# Part 2

def hello(name)
  # YOUR CODE HERE
  return "Hello, #{name}"
end

def starts_with_consonant?(s)
  # YOUR CODE HERE
  if "#{s}".start_with?("A", "E", "I", "O", "U", "a", "e", "i", "o", "u")
    return false
  elsif "#{s}".match?(Regexp.new('^[^A-Za-z]')) 
    return false
  elsif "#{s}".match?(Regexp.new("^$"))
    return false
  elsif "#{s}".match?(Regexp.new('^[0-9]'))
    return false
  else
    return true
  end
end

def binary_multiple_of_4?(s)
  # YOUR CODE HERE
  if s.match?(/\A([01]+)?00\z/) || s == "0"
    return true
  else
    return false
  end
end

# Part 3

class BookInStock
  # YOUR CODE HERE
  def initialize(isbn, price)
    @isbn = isbn
    @price = price
    if price <= 0
      raise ArgumentError
    end
    if isbn == ""
      raise ArgumentError
    end
  end

  def isbn
    @isbn
  end

  def isbn=(new_isbn)
    @isbn = new_isbn
  end

  def price
    @price
  end

  def price=(new_price)
    @price = new_price
  end

  def price_as_string()
    return "$#{sprintf('%.2f', @price)}"
  end
end