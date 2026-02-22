note
	description: "Summary description for {PERSON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PERSON
create set_name
feature
	name: STRING assign set_name -- When somebody run person.name := name then the set_name setter will be called
	set_name( new_name: STRING )
		local
			tmp: STRING
		do
			tmp := new_name.mirrored
			name := tmp.mirrored

			name := new_name.twin -- new_name is a reference

			-- Invalid
			-- new_name := name
		end
	set_name_from(person: PERSON)
		do
			-- person.name is only a getter
			-- person.name := name
			person.set_name (name)
		end
end
