note
	description: "Summary description for {BANK_CARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BANK_CARD
feature
	balance: INTEGER
	withdraw(amount:INTEGER)
		require no_overdraw: amount <= balance
		do
		ensure balance = old balance - amount
		end
end
