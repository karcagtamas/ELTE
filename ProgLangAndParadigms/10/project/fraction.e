note
	description: "Summary description for {FRACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRACTION
create
	set,
	from_integer
convert
	from_integer({INTEGER}),
	to_real:{REAL_64} -- {TYPE} manifests
feature
	numerator, denominator: attached INTEGER

	set(n,d: attached INTEGER)
	require
		denominator /= 0
	do
		numerator := n
		denominator := d
	ensure
		numerator = n
		denominator = d
		denominator /= 0
	end

	from_integer(i: INTEGER)
	do
		set(i, 1)
	end

	to_real: REAL_64
	do
		Result := numerator / denominator
	end

	divided_by alias "/" convert (other: attached like Current): attached like Current
	do
		Result := Current
	end
invariant
	denominator /= 0
end
