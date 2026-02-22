note
	description: "Summary description for {TRIPLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TRIPLE
inherit PAIR -- TRIPLE won't be subtype of PAIR, because PAIR is expanded
feature
	c: INTEGER
end
