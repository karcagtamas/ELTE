note
	description: "Summary description for {DATUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATUM
create
	make, make_masnap
feature
	ev, honap, nap: INTEGER -- attributes

	Januar: INTEGER = 1 -- constants
	December: INTEGER = 12

	make (ev_, honap_, nap_: INTEGER)
		require
			honap_ >= Januar; honap_ <= December; nap_ >= 1; nap_ <= 31 -- ; can be replaced with and
			-- We can named this checks also like in class invariant
		do
			ev := ev_
			honap := honap_
			nap := nap_
		ensure
			ev = ev_ and honap = honap_ and nap = nap_
		end

	make_masnap (d: DATUM)
		do

		end

	masnap: DATUM
		do
			create Result.make_masnap (Current) -- Current: this class reference
				-- We can initialize the Result object
		end

invariant
	honap_nem_tul_kicsi: honap >= Januar -- [CHECK_NAME]: {CHECK}
	honap <= December
	nap >= 1
	nap <= 31 -- it could be a function: napok_szama_a_honapban

end
