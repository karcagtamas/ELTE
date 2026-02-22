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
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

	gcd(a, b: INTEGER): INTEGER
	require
		0 < a; 0 < b -- Function step in contract
	local
		number: INTEGER
	do
		from
			Result := a
			number := b
		invariant 0 < Result; 0 < number; -- Loop contract - assert this preconditions during the execiton - it has to be true
		variant Result + number -- Loop variant - it changes with the loop execution and ensure the termination
		until Result = number
		loop
			if Result > number
			then Result := Result - number
			else number := number - Result
			end
		end
	ensure
		Result > 0; a \\ Result = 0; b \\ Result = 0; -- Function step out contract
	end

end
