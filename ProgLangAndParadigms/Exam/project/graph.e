class
	GRAPH [T -> attached HASHABLE]

inherit
	DIGRAPH [T]
		redefine
			add_line
		end
create
	init
feature
	add_line (k1, k2: attached T)
		do
			Precursor (k1, k2)
			Precursor (k2, k1)
		ensure then has_line_from_to (k2, k1)
		end

end
