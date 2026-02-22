note
	description: "Summary description for {MATH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MATH
feature
	Pi: REAL = 3.14

	cosine (v:REAL):REAL
		external
			"C signature (double): double use <math.h>"
		alias
			"cos"
		end
	sine (v:REAL):REAL
		external
			"C signature (double): double use <math.h>"
		alias
			"sin"
		end
end
