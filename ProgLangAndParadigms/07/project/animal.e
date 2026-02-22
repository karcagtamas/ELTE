note
	description: "Summary description for {ANIMAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ANIMAL
feature
	talk: attached STRING
		deferred
		end
	prefers: detachable FOOD do end
	frozen this: attached like Current
		do
			Result:=twin
		end
	feed (f: attached FOOD) deferred end
end
