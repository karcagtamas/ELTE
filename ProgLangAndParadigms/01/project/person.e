note
	description: "Summary description for {PERSON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PERSON
create set_name
feature
	name: STRING assign set_name
	set_name (new_name: STRING)
		local
			tmp: STRING
		do
			tmp := new_name.mirrored
			name := tmp.mirrored

			-- name := new_name.twin
		end
	set_friends_name(friend: PERSON)
		do
			friend.set_name (name)
			friend.name := name -- Assign mellett mukodik
		end
end


-- john: PERSON -- Void ertekre inicializalodik
-- id: INTEGER -- 0 ertekre inicializalodik

-- create john.set_name("John") -- utasitas
-- create id

-- create{PERSON}.set_name("Peter") -- Expr.

