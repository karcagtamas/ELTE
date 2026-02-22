note
	description: "Summary description for {UNSAFE_PAIR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNSAFE_PAIR [L, R]
inherit ANY
	redefine is_equal
	end
create
	set
feature
	left: detachable L assign set_left
	right: detachable R assign set_right

	set (l: like left; r: like right)
		require
			l = Void and r = Void implies False
		do
			left := l
			right := r
		ensure
			left = l
			right = r
		end

	set_left (l: like left)
		require
			right = Void implies l /= Void
		do
			left := l
		ensure
			left = l
			right = old right
		end

	set_right (r: like right)
		require
			left = Void implies r /= Void
		do
			right := r
		ensure
			right = r
			left = old left
		end

	is_equal(other: like Current): BOOLEAN
		do
			Result := left ~ other.left and then right ~ other.right
		end
invariant
	left = Void and right = Void implies False
end
