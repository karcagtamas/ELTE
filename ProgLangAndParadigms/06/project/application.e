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
			a: attached ACCOUNT
			sa: attached SAVINGS_ACCOUNT

		do
			create a.make (1989191)

			-- sa.set_interest (10)
			a.deposit (10)
			--| Add your code here

			if attached {SAVINGS_ACCOUNT} a as bsa then
				bsa.set_interest(10)
			end

			create sa.make (1212, 10)
			print ("Hello Eiffel World!%N")
		end

end
