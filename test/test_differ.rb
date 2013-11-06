require 'helper'

class TestDiffer < Test::Unit::TestCase

	def test_diff_class
		diffs = RubyDiff::Differ.diff(1,"1")
		assert_equal 1,diffs.size
		assert_equal 1,diffs.diffs(:different_class).count
	end

	def test_same_fixnum
		diffs = RubyDiff::Differ.diff(1,1)
		assert diffs.empty?
	end

	def test_different_fixnum
		diffs = RubyDiff::Differ.diff(1,2)
		assert_equal 1,diffs.size
		assert_equal 1,diffs.diffs(:not_the_same).count
	end

	def test_same_string
		diffs = RubyDiff::Differ.diff("ciao","ciao")
		assert diffs.empty?
	end

	def test_different_fixnum
		diffs = RubyDiff::Differ.diff("ciao","bye")
		assert_equal 1,diffs.size
		assert_equal 1,diffs.diffs(:not_the_same).count
	end	

	def test_array_diff_size
		diffs = RubyDiff::Differ.diff([1,2,3],[1,2])
		assert_equal 1,diffs.size
		assert_equal 1,diffs.diffs(:different_size).count		
	end

	def test_array_diff_element
		diffs = RubyDiff::Differ.diff([1,2,3],[1,2,4])
		assert_equal 1,diffs.size
		assert_equal 1,diffs.subs.count
		assert_equal 1,diffs.sub('index 2').size
		assert_equal 1,diffs.sub('index 2').diffs(:not_the_same).count		
	end	

	def test_hash_diff_keys
		diffs = RubyDiff::Differ.diff({1=>'a',2=>'b',3=>'c'},{1=>'a',2=>'b'})
		assert_equal 1,diffs.size
		assert_equal 1,diffs.diffs(:different_keys).count		
	end	

	def test_hash_diff_element
		diffs = RubyDiff::Differ.diff({1=>'a',2=>'b',3=>'c'},{1=>'a',2=>'b',3=>'d'})
		assert_equal 1,diffs.size
		assert_equal 1,diffs.subs.count
		assert_equal 1,diffs.sub("key '3'").size
		assert_equal 1,diffs.sub("key '3'").diffs(:not_the_same).count		
	end	

	def test_hash_diff_to_s
		diffs = RubyDiff::Differ.diff({1=>'a',2=>'b',3=>'c'},{1=>'a',2=>'b',3=>'d'})
		assert_equal "main diffs: [], sub diffs: {\"key '3'\"=>main diffs: [[not_the_same] c vs d], sub diffs: {}}",diffs.to_s		
	end

	def test_hash_diff_element_pretty_to_s
		diffs = RubyDiff::Differ.diff({1=>'a',2=>'b',3=>'c'},{1=>'a',2=>'b',3=>'d'})	
		assert_equal "key '3' ->\n  [not_the_same] c vs d\n",diffs.pretty_to_s			
	end

end