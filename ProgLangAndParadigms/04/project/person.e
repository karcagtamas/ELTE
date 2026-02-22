note
	description: "Summary description for {PERSON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PERSON
create
	set_name
feature
	name: attached STRING

	set_name (str: attached STRING)
		do
			name := str.twin
		end

	set_name_d (str: detachable STRING)
		do
			if attached str as strd then
				name := strd
			end
		end
end
