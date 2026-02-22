note
	description: "Summary description for {SKIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SKIER
create
	set
feature
	roommate: detachable like Current

feature {NONE}
	set (mate: detachable like roommate)
		do
			roommate := mate
		end

end
