note
	description: "project application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

-- inherit {NONE} -- private inheritance, APPLICATION won't be subtype of MATH, it just inherit its functions
--	MATH

create
	make

feature {NONE} -- Initialization

	make
		local
			c: attached COMPLEX
			pc: attached POLAR_COMPLEX
			f: attached FRACTION
			r: REAL_64
		do
			create {POLAR_COMPLEX} c
			create pc
			c := pc -- upcast (implicit): from POLAR_COMPLEX (derived) to COMPLEX (base)

				-- pc := c -- downcast (implicit): from COMPLEX (base) to POLAR_COMPLEX (dervice) ==> COMPILATION ERROR

				-- downcast (explicit)
			if attached {POLAR_COMPLEX} c as p then
					-- dynamic type check
				pc := p
			end

			f := 3
			f := f / 4
			r := f / 4
			f := 4 / f
		end

end
