note
	description: "Summary description for {ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT
create
	make
feature
	balance: attached INTEGER
	id: attached INTEGER

	deposit(sum: attached INTEGER)
		do

		end

	withdraw(sum: attached INTEGER)
		do

		end

feature {NONE}
	make (id_: attached INTEGER)
		do
			id := id_
		end

invariant
	balance >= 0
end
