note
	description: "Summary description for {IDOPONT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IDOPONT
inherit
	DATUM
		redefine make_masnap, from_array
	end
create
	make,
	make_masnap
feature
	ora,perc: attached INTEGER

	from_array(arr: attached ARRAY[INTEGER])
		require else
			arr.count = 5
		do


		ensure then
			ora = 0 or else ora = arr[arr.lower + 3] \\ 24
			perc = 0 or else perc = arr[arr.lower + 4] \\ 60
		end

feature {NONE}
	make_masnap (d: attached DATUM)
		do
			Precursor(d)
			if attached {IDOPONT} d as ip then
				ora := ip.ora
				perc := ip.perc
			end
		end
invariant
	ora_nem_tul_kicsi: ora >= 0
	ora_nem_tul_nagy: ora < 24
	perc_nem_tul_kics: perc >= 0
	perc_nem_tul_nagy: perc < 60

end
