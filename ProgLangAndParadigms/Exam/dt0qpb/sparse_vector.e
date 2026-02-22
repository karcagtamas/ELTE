note
	description: "Summary description for {SPARSE_VECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPARSE_VECTOR [frozen T -> NUMERIC create default_create end]

inherit ANY
	redefine is_equal
	end
create
	make
feature {SPARSE_VECTOR}
	list: attached LINKED_LIST [PAIR [INTEGER, T]]
feature
	size: INTEGER
	make (n: INTEGER)
		require
			n > 0
		do
			size := n
			create list.make
		ensure
			size = n
			list.count = 0
		end

	item alias "[]" (i: INTEGER): T
		require
			i > 0
			i <= size
		local
			d: T
		do
			find (i)

			if list.off then
				create d
				Result := d.zero
			else
				Result := list.item.right
			end
		ensure
			list.off implies Result = 0.0
			not list.off implies Result = list.item.right
		end

	set (i: INTEGER; v: T)
		require
			i > 0
			i <= size
			v /~ v.zero
		do
			find (i)

			if not list.off then
				list.remove
			end

			list.put_front (create {PAIR [INTEGER, T]}.set (i, v))
		ensure
			list.first.left = i
			list.first.right = v
		end

	is_equal(other: like Current): BOOLEAN
		do
			Result := across list as i all other.item(i.item.left) ~ i.item.right  end
		end

feature {NONE}
	find (i: INTEGER)
		require
			i > 0
			i <= size
		do
			from
				list.start
			until
				list.off or else list.item.left = i
			loop
				list.forth
			variant list.count - list.index + 1
			end
		ensure
			not list.off implies list.item /= Void
		end

invariant
	list.count <= size
	size > 0
end
