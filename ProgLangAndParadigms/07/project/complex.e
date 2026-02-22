note
	description: "Summary description for {COMPLEX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	COMPLEX

inherit MATH
feature
	re, im: REAL
		deferred end
	r, arg: REAL
		deferred end
feature
	from_polar (r_, arg_: REAL)
		deferred end
feature
	polar: POLAR_COMPLEX
		do
			create Result.from_polar (r, arg)
		end
	times alias "*" (other: COMPLEX): COMPLEX
		deferred
		end
	divided_by alias "/" (other: COMPLEX): COMPLEX
		require
			nonzero_div: other.r /= 0.0
		deferred
		ensure
			inv_of_times: Current ~ Result * other
		end
feature {NONE}
	frozen re_from_polar (r_, arg_: REAL): REAL
		do
			Result := r_ * cosine (arg_)
		end
	frozen im_from_polar (r_, arg_: REAL): REAL
		do
			Result := r_ * sine (arg_)
		end

invariant
	arg < 2 * Pi
	arg >= 0

end
