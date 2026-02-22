note
	description: "Summary description for {GIRL2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GIRL2
inherit SKIER2 redefine roommate end
feature
	roommate: detachable GIRL2 assign share

end
