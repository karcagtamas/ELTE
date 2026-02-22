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

feature {NONE}
	make
		local
			p: attached UNSAFE_PAIR [STRING, STRING]
			k: attached UNSAFE_PAIR [STRING, STRING]
			a: attached SPARSE_VECTOR [REAL_32]
			b: attached SPARSE_VECTOR [REAL_32]
			c: attached SPARSE_VECTOR [REAL_32]
		do
			create p.set ("String", Void)
			p.set_left ("Alma")
			p.set_right ("Korte")
			p.set_left (Void)
			print (p.is_equal (p).out)
			print ((p ~ p).out)
				--p.set_right (Void)

			create k.set (Void, "Korte")
			print (p.is_equal (k).out)

			create a.make (10)
			a.set (1, 1.0)
			a.set (2, 2.0)
			a.set (3, 3.0)
			a.set (1, 1.1)
			print (a.item (1).out)
			print (a [2].out)
			print (a [4].out)

			create b.make (10)
			create c.make (10)

			b.set (1, 1.0)
			c.set (1, 1.0)

			print (a.is_equal (a).out)
			print (a.is_equal (b).out)
			print (b.is_equal (c).out)
			print ("Hello Eiffel World!%N")
		end

end
