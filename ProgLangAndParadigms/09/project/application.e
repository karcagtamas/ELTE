note
	description: "project application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			g: SKIER3
			e: SKIER3
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
			create e
			create {GIRL3} g
			-- g.share (e) -- catcall
		end

end
