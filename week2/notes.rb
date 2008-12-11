#!/opt/local/bin/ruby

fizzable = n % 3 == 0
buzzable = n % 5 == 0

puts "#{n}." 			if !fizzable && !buzzable
puts "#{n}. Fizz" 		if fizzable && !buzzable
puts "#{n}. Buzz" 		if !fizzable && buzzable
puts "#{n}. FizzBuzz" 	if fizzable && buzzable

# blocks

# lamda magic? multi-line lamda?
