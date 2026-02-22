note
	description: "Summary description for {POLAR_COMPLEX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	POLAR_COMPLEX
inherit COMPLEX
create from_polar, default_create
feature
	r: REAL assign set_r
	arg: REAL assign set_arg
	re: REAL
		do
			Result := re_from_polar(r,arg)
		end
	im: REAL
		do
			Result := im_from_polar(r,arg)
		end

	from_polar(r_, arg_:REAL)
		do
			set_r(r_)
			set_arg(arg_)
		end
	set_r(r_:REAL)
		do
			r:= r_
		end
	set_arg(arg_:REAL)
		do
			arg:= arg_
		end

	times alias "*" (other: COMPLEX):POLAR_COMPLEX
		do
			create {POLAR_COMPLEX} Result.from_polar(r * other.r, arg + other.arg)
		end

	divided_by alias "/" (other: COMPLEX): POLAR_COMPLEX
		do
			create Result.from_polar(r / other.r, arg - other.arg)
		end
end
