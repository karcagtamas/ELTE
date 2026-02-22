note
	description: "Summary description for {SKIER3}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SKIER3
feature
	roommate: detachable like Current assign share -- adaptive attr. type

	share(s: like roommate) -- adaptive parameter type
		do
			roommate := s
		end
end
