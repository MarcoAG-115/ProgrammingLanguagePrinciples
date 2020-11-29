# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Parser Class
#
load "Token.rb"
load "Lexer.rb"
class Parser < Scanner
	#Error counter
	@@error_count = 0 #Edit

	def initialize(filename)
    	super(filename)
    	consume()
   	end
   	
	def consume()
      	@lookahead = nextToken()
      	while(@lookahead.type == Token::WS)
        	@lookahead = nextToken()
      	end
   	end
  	
	def match(dtype)
		  if (@lookahead.type != dtype)
			begin	#Edit
				raise "Expected #{dtype} found #{@lookahead.text}" #Edit
			rescue => error	#Edit
				puts error.message	#Edit
			end		#Edit
			@@error_count = @@error_count + 1	#Edit
			 
      	end
      	consume()
   	end
   	
	def program()
      	while( @lookahead.type != Token::EOF)
        	puts "Entering STMT Rule"
			statement()  
		  end
		puts "There were " + @@error_count.to_s + " parse errors found."	#Edit
   	end

	def statement()
		if (@lookahead.type == Token::PRINT)
			puts "Found PRINT Token: #{@lookahead.text}"
			match(Token::PRINT)
			#puts "Entering EXP Rule"	#Edit
			exp_rule()		#Edit
		else
			puts "Entering ASSGN Rule"
			assign_rule()		#Edit
			puts "Exiting ASSGN Rule"	#Edit
		end
		puts "Exiting STMT Rule"
	end

#Edit
#BNF Rules

	def id_rule()
		if (@lookahead.type == Token::ID)
			puts "Found ID Token: #{@lookahead.text}"
		end
		match(Token::ID)
	end

	def term_rule()
		puts "Entering TERM Rule"
		factor_rule()
		puts "Exiting TERM Rule"
		puts "Entering ETAIL Rule"
		etail_rule()
		puts "Exiting ETAIL Rule"
	end

	def etail_rule()
		if (@lookahead.type == Token::ADDOP)
			puts "Found ADDOP Token: #{@lookahead.text}"
			consume()
			term_rule()
		elsif (@lookahead.type == Token::SUBOP)
			puts "Found SUBOP Token: #{@lookahead.text}"
			consume()
			term_rule()
		else
			puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
		end
	end

	def exp_rule()
		puts "Entering EXP Rule"
		term_rule()
		puts "Exiting EXP Rule"
		if (@lookahead.type == Token::RPAREN)
			puts "Found RPAREN Token: #{@lookahead.text}"
			consume()
		end
	end

	def assign_rule()
		id_rule()
		if (@lookahead.type == Token::ASSGN)
			puts "Found ASSGN Token: #{@lookahead.text}"
		end
		match(Token::ASSGN)
		exp_rule()
	end

	def factor_rule()
		puts "Entering FACTOR Rule"
		if (@lookahead.type == Token::ID)
			puts "Found ID Token: #{@lookahead.text}"
			consume()
		elsif (@lookahead.type == Token::INT)
			puts "Found INT Token: #{@lookahead.text}"
			consume()
		elsif (@lookahead.type == Token::LPAREN)
			puts "Found LPAREN Token: #{@lookahead.text}"
			consume()
			exp_rule()
		else
			puts "Expected ( or INT or ID found #{@lookahead.text}"
			@@error_count = @@error_count + 1
			consume()
		end
		puts "Exiting FACTOR Rule"
		puts "Entering TTAIL Rule"
		ttail_rule()
		puts "Exiting TTAIL Rule"
	end

	def ttail_rule()
		if (@lookahead.type == Token::MULTOP)
			puts "Found MULTOP Token: #{@lookahead.text}"
			consume()
			factor_rule()
		elsif (@lookahead.type == Token::DIVOP)
			puts "Found DIVOP Token: #{@lookahead.text}"
			consume()
			factor_rule()
		else
			puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
		end
	end

end

## Inverted order of all if-elsif statements