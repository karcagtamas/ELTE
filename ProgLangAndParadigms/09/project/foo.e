note
	description: "Summary description for {FOO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FOO
feature
	dummy (a, b: INTEGER): BOOLEAN
		do
			if a = b then Result := true end -- reference equal (if the type is reference, otherwise it is ~)
			if a ~ b then Result := true end -- value equal
			if equal(a,b) then Result := true end -- From ANY
			if a.is_equal (b) then Result := true end -- Binary equal

			-- Object identity
			-- reference equality a = b -> expanded tipus eseten (a = b) = (a ~ b)

			-- Object equality (tartalmi)
			-- shallow
			-- custom a ~ b = equal(a,b) = a.is_equal(b)
			-- deep
		end

end
