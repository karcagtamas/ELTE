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
			-- Run application.
		do
				--| Add your code here
			print ("Hello Eiffel World!%N")
		end
	gcd (a, b: INTEGER): INTEGER
		local
			number: INTEGER
		do
			from
				Result := a
				number := b
			until
				Result = number
			loop
				if Result > number
				then Result := Result - number
				else number := number - Result
				end
			end
		end

	szokoev (ev: INTEGER): BOOLEAN
		do
				-- // Egesz osztas (DIV)
				-- \\ Maradek osztas (MOD)
			if ev \\ 400 = 0 then Result := True
			elseif ev \\ 100 = 0 then Result := False
			elseif ev \\ 4 = 0 then Result := True
			else Result := False
			end
		end

	napok_szama_a_honapban (honap: INTEGER): INTEGER
		do
			inspect honap
			when 1, 3, 5, 7, 8, 10, 12 then Result := 31
			when 4, 6, 9, 11 then Result := 30
			when 2 then
				if szokoev (2000) then Result := 29
				else Result := 28
				end
			end
		end
	test: BOOLEAN
		do
			across <<1969, 7, 20, 20, 17, 40>> as i
			loop
				print (i.item.out)
				print ("%N")
			end

			Result := across <<7, 20, 20, 17, 40>> as i all i.item > 0 end
			Result := across <<7, 20, 20, 17, 40>> as i some i.item = 17 end

			Result := True
		end

end
