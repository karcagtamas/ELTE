note
	description: "Summary description for {SKIER2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SKIER2
feature
	roommate: detachable SKIER2 assign share

	share(s: like roommate) -- adaptive parameter type
		do
			roommate := s
		end
end
