rubydiff
========

Find and list differences betweem Ruby objects

== Example

    diffs = RubyDiff::Differ.diff({1=>'a',2=>'b',3=>'c'},{1=>'a',2=>'b',3=>'d'})
    
diff.to_s produces:

    main diffs: [], sub diffs: {
        "key '3'\"=>main diffs: [[not_the_same] c vs d], sub diffs: {}
    }
