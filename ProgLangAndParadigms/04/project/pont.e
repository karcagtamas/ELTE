note
	description: "Summary description for {PONT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	PONT
feature
	x, y: attached REAL -- Void biztonsag => nem kell invariant
	-- attached means cannot be void => attached can be skipped but on the exam is required
	-- detachable means can be void
end
