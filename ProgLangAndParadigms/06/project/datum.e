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
	ev,honap,nap: attached INTEGER

	from_array(arr : attached ARRAY[INTEGER])
		require
			arr.count = 3
		do
			ev := arr[arr.lower]
			honap := 1 + (arr[arr.lower + 1].abs - 1) \\ 12
			nap := 1 + (arr[arr.lower + 2].abs - 1) \\ 31
		ensure
			ev = arr[arr.lower]
			honap = 1 + (arr[arr.lower + 1].abs - 1) \\ 12
			nap = 1 + (arr[arr.lower + 2].abs - 1) \\ 31
		end

feature {NONE}
	make
		do

		end
	make_masnap(d: attached DATUM)
		do

		end

invariant
	honap_nem_tul_kicsi: honap >= 1
	honap_nem_tul_nagy: honap <= 12
	nap_nem_tul_kicsi: nap >= 1
	nam_nem_tul_nagy: nap <= 31
end
