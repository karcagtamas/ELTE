note
	description: "Summary description for {SKIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SKIER
feature
	roommate: detachable SKIER assign share
	
	share(s: detachable SKIER)
		do
			roommate := s
		end

end
