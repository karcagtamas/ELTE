note
	description: "Summary description for {CAT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CAT
inherit ANIMAL
	redefine prefers
	end
feature
	talk: attached STRING
		--do
		--once
		attribute -- Not func. - it is an attribute
			Result := "Miaow!"
		end
	prefers: attached MILK do create Result end -- covariant result type
	feature feed (m: attached MILK)
		do
			
		end
end
