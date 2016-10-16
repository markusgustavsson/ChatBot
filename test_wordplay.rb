require 'test/unit'
require './wordplay'

class TestWordPlay < Test::Unit::TestCase

def test_sentences
	assert_equal(["a", "b", "c d", "e f g"], "a. b. c d. e f g.".sentences)
	
	test_text = %q{Hello. This is a test sentence. This is a long test sentence. 
	We work on separation. lets see how it goes. in the test.}
	assert_equal("This is the end of the test", test_text.sentences[2])
end

end