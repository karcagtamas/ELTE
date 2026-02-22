note
	description: "Summary description for {PAIR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PAIR [L, R]
inherit
	UNSAFE_PAIR [L, R]
	redefine
		left, right
	end
create set

feature
	left: attached L
	right: attached R

end
