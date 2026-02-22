note
	description: "Summary description for {GIRL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GIRL
inherit SKIER redefine roommate, share end
feature
	roommate: detachable GIRL assign share --covariant attr.
	share (g: detachable GIRL) --covariant parameter
		do
			roommate := g
		end

end
