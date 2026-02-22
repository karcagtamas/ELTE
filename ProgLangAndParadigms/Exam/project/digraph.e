class
	DIGRAPH [T -> attached HASHABLE]

inherit
	HASH_TABLE [ARRAYED_SET [T], T]
		rename make as init
		end
create
	init, union
feature
	union (g1, g2: attached like Current)
		do
			init (g1.count + g2.count)

			across g1 as i loop
				if not has_key (i.key) then
					add_node (i.key)
				end

				across i.item as e loop
					add_line (i.key, e.item)
				end
			end

			across g2 as i loop
				if not has_key (i.key) then
					add_node (i.key)
				end

				across i.item as e loop
					add_line (i.key, e.item)
				end
			end
		end

	add_node (key: attached T)
		require
			not_has_this_key: not has_key (key)
		do
			put (create {ARRAYED_SET [T]}.make (3), key)
		ensure
			has_key: has_key (key)
		end

	add_line (k1, k2: attached T)
		require
			has_start: has_key (k1)
			has_end: has_key (k2)
		do
			if attached item (k1) as i then
				i.put (k2)
			end
		ensure
			item_added: has_line_from_to (k1, k2)
		end

	has_line (k1, k2: attached T): BOOLEAN
		require
			has_k1: has_key (k1)
			has_k2: has_key (k2)
		do
			Result := False
			if has_line_from_to (k1, k2) then
				Result := True
			end

			if has_line_from_to (k2, k1) then
				Result := True
			end
		ensure
			really_has_line: has_line_from_to (k1, k2) or has_line_from_to (k2, k1)
		end
feature {NONE}
	has_line_from_to (k1, k2: attached T): BOOLEAN
		require
			has_k1: has_key (k1)
			has_k2: has_key (k2)
		do
			Result := False
			if attached item (k1) as i1 then
				if i1.has (k2) then
					Result := True
				end
			end
		end
end
