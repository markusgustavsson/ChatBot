class Wordplay

#Not fully confident what this formula is doing, apart from finding good words
def self.best_sentence(sentences, desired_words)
	ranked_sentences = sentences.sort_by do |s|
	s.words.length - (s.downcase.words - desired_words).length
	end
	ranked_sentences.last
end
	#method for changing pronouns from me to you, etc.
	def self.switch_pronouns(text)
	text.gsub(/\b(I am|You are|I|You|Me|Your|My)\b/i) do |pronoun|
		case pronoun.downcase
			when "i"
				"you"
			when "you"
				"me"
			when "me"
				"you"
			when "I am"
				"you are"
			when "you are"
				"I am"
			when "your"
				"my"
			when "my"
				"your"
			end
		end.sub(/^me\b/i, 'i')
	end
end

class String

#Finding sentences in the string and splitting
	def sentences
		gsub(/\n|\r/, ' ').split(/\.\s*/)
	end
	
	#splitting sentences by words
	def words
		scan(/\w[\w\'\-]*/)
	end
end

#Testing the functionality
puts Wordplay.switch_pronouns("I gave you life")
puts Wordplay.switch_pronouns("your cat is fighting with me")

#while input = gets
#	puts '>> '+ Wordplay.switch_pronouns(input).chomp + '?'
#end