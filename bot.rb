require 'yaml'
require './wordplay'

# creatng the bot class
class Bot
	attr_reader :name
	
	# initialise what's always happening in this class initially.
	def initialize(options)
		@name = options[:name] || "Unnamed Bot"
		begin
		# Load data files
			@data = YAML.load(File.read(options[:data_file]))
		# In case data cannot be loaded
		rescue
			raise "Can't load bot data"
		end
	end
	# Defining the greeting by the bot
	def greeting
		random_response :greeting
	end
	#Defining the farewell by the bot
	def farewell
		random_response :farewell
	end
	#Defining the response to method.
	def response_to(input)
		prepared_input = preprocess(input).downcase # Taking the input, processing and prepare it
		sentence = best_sentence(prepared_input) # Finding the best sentence to use based on input
		responses = possible_responses(sentence) # Finding what responses are suitable based on the sentence
		responses[rand(responses.length)] # Randomly picking one of the sentences.
	end
	
	##not sure if below should be private..
	
	private
	
	
	def possible_responses(sentence)
		responses = []  # Creating an empty array
		
		#Find all patterns to try and match against
		@data[:responses].keys.each do |pattern|  # CHecking all keys in data file 
			next unless pattern.is_a?(String) # Only checking strings, not foreign characters
			
			#For each pattern, see if the supplied sentence contains
			#a match. Remove substitution symbols (*) before checking.
			#Push all resopnses to the responses array created above
			
			if sentence.match('\b' + pattern.gsub(/\*/, '') + '\b')
				#If the pattern contains substitution placeholder,
				# perfomr the substitutions
				if pattern.include?('*')
					responses << @data[:responses][pattern].collect do |phrase|
						#first, erase everything before the placeholder
						# and leave everything after it
						matching_section = sentence.sub(/^.*#{pattern}\s+/,'')
						#Then substitute the text after the placeholder, with 
						# Pronouns switched.			
						phrase.sub('*', Wordplay.switch_pronouns(matching_section))
					end
				else
				#No placeholder? Then we add the response to the array
				responses << @data[:responses][pattern]
				end
			end
		end
		#if there were no matches, add default ones
		responses <<  @data[:responses][:default] if responses.empty?
		#Flatten the blocks of responses to a flat array
		responses.flatten
	end	
			

	
	def random_response(key)
		random_index = rand(@data[:responses][key].length)
		@data[:responses][key][random_index].gsub(/\[name\]/, @name)
	end
	
	def preprocess(input)
		perform_substitutions input
	end
	
	def perform_substitutions(input)
		@data[:presubs].each { |s| input.gsub!(s[0], s[1])}
		input
	end
	
	def best_sentence(input)
		hot_words = @data[:responses].keys.select do |k|
			k.class == String && k =~ /^\w+$/
			
		end
		Wordplay.best_sentence(input.sentences, hot_words)
	end
end
