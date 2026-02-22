note
	description: "Summary description for {CREDIT_CARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CREDIT_CARD
inherit
	BANK_CARD redefine withdraw end
feature
	withdraw(amount: INTEGER)
		require else True
		do
			
		end
end
