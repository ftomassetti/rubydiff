require "test/unit"
require "rubydiff"

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

end