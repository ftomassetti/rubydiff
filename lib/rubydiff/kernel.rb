module RubyDiff

class Diff
	attr_reader :type, :details

	def initialize(type,details)
		@type = type
		@details = details
	end

	def to_s
		"[#{type}] #{details}"
	end
end

class Diffs

	def initialize
		@diffs = []
		@sub   = {}
	end

	def add(diff)
		@diffs << diff
	end

	def add_all(diffs)
		@diffs.concat(diffs.diffs)
		diffs.subs.each do |s|
			@sub[s] = diffs.sub(s)
		end
	end

	def add_sub(subname,diffs)
		@sub[subname]=diffs unless diffs.empty?
	end

	def subs
		@sub.keys
	end

	def sub(key)
		@sub[key]
	end

	def empty?
		@sub.empty? && @diffs.empty?
	end

	def size
		@sub.size + @diffs.size
	end

	def diffs(type=nil)
		if type
			@diffs.select {|d| d.type==type}
		else
			@diffs
		end
	end

	def to_s
		"main diffs: #{@diffs}, sub diffs: #{@sub}"
	end

	def pretty_to_s(ntabs=0)
		tab = "  "
		s = ""
		space = tab*ntabs
		@diffs.each {|d| s+="#{space}#{d}\n"}
		@sub.each do |k,subdiff|
			s+="#{space}#{k} ->\n"
			s+=subdiff.pretty_to_s(ntabs+1)
		end
		s
	end

end

class HashDiffer
	def diff(a,b)
		diffs = Diffs.new
		if a.keys!=b.keys
			diffs.add(Diff.new(:different_keys,"#{a.keys} vs. #{b.keys}"))
		else
			a.keys.each do |k|
				diffs.add_sub("key '#{k}'",Differ.diff(a[k],b[k]))
			end
		end
		diffs
	end
end

class ArrayDiffer
	def diff(a,b)
		diffs = Diffs.new
		if a.count!=b.count
			diffs.add(Diff.new(:different_size,"#{a.count} vs. #{b.count}"))
		else
			a.each_with_index do |el_a, i|
				diffs.add_sub("index #{i}",Differ.diff(el_a,b[i]))
			end
		end
		diffs
	end
end

class BasicDiffer
	def diff(a,b)
		diffs = Diffs.new
		diffs.add(Diff.new(:not_the_same,"#{a} vs #{b}")) unless a.eql?(b)
		diffs
	end
end

module Differ

	@@specific_differs = {}
	@@specific_differs[Fixnum] = BasicDiffer.new
	@@specific_differs[String] = BasicDiffer.new
	@@specific_differs[Array] = ArrayDiffer.new
	@@specific_differs[Hash] = HashDiffer.new

	def self.diff(a,b)
		diffs = Diffs.new
		if a.class!=b.class
			diffs.add(Diff.new(:different_class, "#{a.class},#{b.class}"))
		else
			differ = differ_for(a.class)
			raise "No differ registered for #{a.class}" unless differ
			diffs.add_all(differ.diff(a,b))
		end
		diffs
	end

	def self.differ_for(clazz)
		@@specific_differs[clazz]
	end

end

end