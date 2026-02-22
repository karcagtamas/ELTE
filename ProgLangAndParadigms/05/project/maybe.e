note
	description: "Summary description for {MAYBE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAYBE[T]
create
	nothing, just
feature
	has: BOOLEAN
	item: attached T
		require has_item: has
		do
			check attached value as attached_value then
				Result := attached_value
			end
		end
feature {NONE}
	value: detachable T

	nothing
		do
			has := False
		ensure not has
		end

	just(v: attached T)
		do
			has := True
			value := v
		ensure has and item ~ v
		end
invariant
	has implies attached value
end
