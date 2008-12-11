#!/usr/bin/env ruby -w

problem = (ARGV.shift || 1).to_i

##
#
# set ts=2
#
# Student Name:		John Howe
# Homework Week: 	2
#
# This week's homework will be freeform, not self-testing...
#

case problem
when 1                  # Problem 1) "Number Guesser"

  # Develop an interactive program that will guess the user's number,
  # asking for >, <, or = as feedback for whether the current guess is
  # higher, lower, or equal to the actual number. For now, let it
  # guess for a number between 1 and 20.

  # NOTE: I don't care what algorithm you use, this isn't an algs
  # class. More efficient is only better in that it wastes less time.
  
  solved = false
  lobound = nil
  hibound = nil
  max = 20
  
  guess = 1 + rand(max)
  
  puts
  puts "I can read your mind. Please pick a number between 1 and 20..."
  puts
  puts "I understand the following characters \">\", \"<\", or \"=\" for answers..."
  puts
  puts "Got it? Good!"
  
  # basically need to capture guess/upper/lower bounds.
  # answer = gets.chomp
  
  while !solved
    puts
    print "I guess #{guess}. Isn't that right? [>,=,<,q]: "
    answer = gets.chomp
    
    case answer

    when "=" then
      # Maybe nice to ask to try another game, && call self again
      solved = true
			puts
      puts "I have successfully read your mind ... Until we meet again human! Ka'Plach!"
      exit
    when "<" then
      # User says guess is too high
      hibound = guess - 1
      if lobound then
        # Did the user state a lower boundary earlier?
        if lobound > hibound then
          # User lies
					puts
          puts "I sense a disturbance in the force with you, I am leaving for reinforcements"
          exit
        end
        # Guess again between high and low boundaries
        delta = hibound - lobound
        if hibound == lobound
          guess = hibound
        elsif delta == 0
          guess = hibound
        else
          guess = lobound + rand(delta)
        end
      else
        # No lower boundary previously set
        if hibound == 0 then
          # Yeah, too low, bad user!
					puts
          puts "Me thinks you are not being honest with yourself... Goodbye for now"
          exit
        end
        # Guess between 1 and hi bondary
        guess = 1 + rand(hibound)
      end
			puts
      puts "Hmm, lower then..."
    when ">" then
      # User says guess is too low
      lobound = guess + 1
      if guess >= max then
        # User says guees needs to be higher than max boundary! Bad user!
				puts
        puts "I think you are twisting my CPU, cyal8r..."
        exit
      end
      if guess == hibound
        # User repeats previous boundary, bad user!
				puts
        puts "Come on now, you said that was too high earlier. I am bailing..."
        exit
      end
      #
      if hibound then
        delta = hibound - lobound
      else
        delta = max - lobound
      end
      if delta == 1 then
        if hibound then
          guess = hibound
        else
          guess = max
        end
      elsif lobound == hibound
        guess = hibound
      else
        guess = lobound + rand(delta)
      end
			puts
      puts "Hmm, higher then.."
    when /q|quit|b|bye/i then
      # No need for ^+C
			puts
      puts "See you in Stovocore Human!"
      exit
    else
      # Wakarimasen
			puts
      puts "I didn't understand your answer: #{answer}"
    end
  end
    
when 2                  # Problem 2) "FizzBuzz"

  # Write a program that outputs all the numbers between 1 and 100. If
  # the number is evenly divisible by 3, have it also print "Fizz". If
  # the number is evenly divisible by 5, have it also print
  # "Buzz". Thus, numbers evenly divisible by 15 will show "FizzBuzz".
  #
  # Example:
  # 1.
  # 2.
  # 3. Fizz
  # 4.
  # 5. Buzz
  
  (1..100).each do |number|
    if (number % 15).to_i == 0 then
			puts "#{number}. FizzBuzz"
		elsif ( number % 5 ).to_i == 0 then
			puts "#{number}. Buzz"
		elsif ( number % 3 ).to_i == 0 then
			puts "#{number}. Fizz"
		else
			puts "#{number}."
		end
	end

when 3                  # Problem 3) "I have no idea"

  puts "West of House"
  puts "You are standing in an open field west of a white house, with"
  puts "a boarded front door."
  puts "There is a small mailbox here."

  alive = true

  while alive
    print "> "
    cmd = gets
    case cmd

    when /examine\s+(.+)/ then
    	thing = $1
    	puts "There is a package"
    when /walk\s+(.+)/ then
    	direction = $1
		if direction =~ /to(.+) house/ then
			puts "You walk towards the house"
			house = true
		else
    		puts "You walk ten paces #{direction}"
		end
    when /grab\s+(.+)/ then
    	object = $1
		if object =~ /package/ then
			puts "You grab the #{object}, now what?"
		else
			puts "You grab the package"
		end
	when /open\s+(.+)/ then
		object = $1
		if object =~ /package/ then
			puts "You get a tax rebate"
			alive = false
			rebate = true
		elsif object =~ /door/ then
			if house then
				puts "You open a wormhole and are sucked out of the galaxy"
				alive = false
			else
				puts "I think you need to walk towards the house first"
			end
		else
			puts "You open the #{object}"
		end
	when /quit|bye/
		puts
		puts "Leaving already? Bye!"
		puts
		exit
	when /help/
		puts "Tech support is expensive"
		puts "bye|examine|grab|help|open|quit|walk"
    else
      puts "I have no idea what you're talking about"
    end
  end

	puts
	if rebate then
		puts "Next year comes along, and you have to pay taxes on your \"rebate\""
	else
		puts "In this alternate universe, there are no taxes"
	end
	puts
  # keep going. get creative. have fun.

  # NOTE: do NOT write a z-machine. that is beyond the scope of this class.

end

