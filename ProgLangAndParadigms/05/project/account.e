note
	description: "Summary description for {ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT

feature
	balance: INTEGER
	id: INTEGER

	deposit(amount: INTEGER)
		require
			amount > 0
		do
			balance := balance + amount
		ensure
			balance_updated: balance = old balance + amount -- old - access the starter value for the variable (before body execution)
			frame: id = old id -- not changed cond.
			frame2: strip(balance) ~ old strip(balance) -- other way for not changed - we add what should change
		end
end
