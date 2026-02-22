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
		local
			a_cat: CAT
			some_grass: GRASS
			polymorphic: ANIMAL
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")

			create a_cat
			create some_grass
			-- a_cat.feed (some_grass) error in compile time
			polymorphic := a_cat
			polymorphic.feed (some_grass)
		end

end
