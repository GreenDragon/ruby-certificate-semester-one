##
# Student Name: John Howe
# Homework Week: 3
#

# haha... you thought there'd be code here for you!

# ok... ok... just one:

def problem_1
  true
end

def problem_2
  "happy"
end

def problem_3(a,b)
  a + b
end

# I don't quite understand how test is stripping out the _edge name 
# from the tests
# For example, def test_problem_3_numbers calls problem_3 and not 
# problem_3_numbers
# Is that some ruby magick?

#def problem_3_strings
#  a + b
#end

#def problem_3_arrays
#  what?
#end

# yeah... not much help, but it is a start. :)
# enjoy!

# From Week 2 Homework:
#
# Write a function that takes a number and returns the 'fizzbang'
# output for that number. If the number is evenly divisible by 3,
# have it also print "Fizz". If the number is evenly divisible by 5,
# have it also print "Buzz". Thus, numbers evenly divisible by 15 will
# show "FizzBuzz".
#
# Use this starter function. Write tests for it that drive the
# behavior.

def fizzbang(number)
  if (number % 15).to_i == 0 then
		"#{number}. FizzBuzz"
	elsif ( number % 5 ).to_i == 0 then
		"#{number}. Buzz"
	elsif ( number % 3 ).to_i == 0 then
		"#{number}. Fizz"
	else
		 "#{number}."
	end
end

# if you run this file, it'll run fizzbuzz from 1 to 100
if __FILE__ == $0 then
  1.upto(100) do |n|
    puts fizzbang(n)
  end
end
