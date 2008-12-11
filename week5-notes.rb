Q+A
instance vars vs class vars
attr_*
OptParse.parse!
libraries ( no strings returned )

# If using a class variable

class Person
	@@people = {}
	def initialize(name)
		@@people[name] = self
	end
end

"99 times out of 100 doesn't need class variable"

Bank has access to a bazillion accounts
  @accts={}
    "ryan"  => $$
    "bob"   => $$
    
Hand wavy OO space, no strings from methods. The french argument
Class variables break once you start using multiple banks

attr_accessor
  attr_reader
  attr_writer
  
def name
  @name
end

def name=0
  @name=0
end

attr_accessor :n

def x
  n=42
end

def x
  self.n=42
end