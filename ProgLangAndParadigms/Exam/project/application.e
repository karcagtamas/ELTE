note
	description: "project application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
		local
			d: DIGRAPH[INTEGER]
			b: DIGRAPH[INTEGER]
			a: DIGRAPH[INTEGER]
		do
			d := create {DIGRAPH[INTEGER]}.init(10)
			print ("Hello Eiffel World!%N")
			create b.init(10)
			b.add_node (1)
			b.add_node (2)
			d.add_node (3)

			create a.union (d, b)

		end

end
