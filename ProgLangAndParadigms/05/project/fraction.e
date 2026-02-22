note
	description: "Summary description for {FRACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FRACTION
create
	set
feature
	numerator, denominator: attached INTEGER

	set (numerator_, denominator_: attached INTEGER)
		require
			denominator /= 0
		do
			numerator := numerator_
			denominator := denominator_
		ensure
			denominator /= 0
		end

	divide_by (other: attached FRACTION)
		require
			other.numerator /= 0
		do
			if Current = other then
				numerator := 1
				denominator := 1
			else
				numerator := numerator * other.denominator
				denominator := denominator * other.numerator
			end
		end

	divided_by alias "/" (other: attached FRACTION): attached FRACTION -- / operator overload
		require
			other.numerator /= 0
		do
			create Result.set (numerator * other.denominator, denominator * other.numerator)
		end

	reciprocal alias "-" : attached FRACTION
		require
			numerator /= 0
		do
			create Result.set(denominator,numerator)
		end

invariant
	denominator /= 0

end
