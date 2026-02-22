note
	description: "Summary description for {SAVINGS_ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAVINGS_ACCOUNT
inherit
	ACCOUNT
		rename make as make_account
	end
create
	make_account, -- inherited from ACCOUNT
	make
feature
	interest: attached INTEGER assign set_interest
	set_interest(interest_: attached INTEGER)
		require
			interest_ >= 0
		do
			interest := interest_
		ensure
			interest = interest_
			balance = old balance
		end
	pay_interest
		do
			deposit(balance*interest//100)
		ensure
			balance = old (balance + balance * interest // 100)
			interest = old interest
		end

feature {NONE}
	make(id_, interest_: attached INTEGER)
		require interest_ >= 0
		do
			make_account(id_)
			interest := interest_
		ensure
			id = id_
			interest = interest_
		end
invariant
	interest >= 0
end
