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
			p,q,r,s: attached FRACTION
			x: MAYBE[INTEGER]
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")

			create p.set (3, 4)
			create q.set (5, 3)

			r := p.divided_by (q)
			p.divide_by (q)

			s := -r

			create x.just (121)

			if x.has then print (x.item.out)

			end
		end

	my_routine
		local
			already_tried: BOOLEAN
		do
			if not already_tried then
				-- norm
			else
				-- plan b
			end
		rescue
			if not already_tried then -- in the else branch the exception goes upper
				already_tried := True
				retry -- re-run the body with the modified state
			end
		end
end
