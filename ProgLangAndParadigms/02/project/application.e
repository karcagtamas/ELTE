note
	description: "project application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization
	ev: INTEGER
	honap: INTEGER
	make
			-- Run application.
		local
			num: INTEGER
			jack: PERSON
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")

			num := 1
			create{PERSON} jack.set_name ("Jack")

			iterate
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
	szokoev: BOOLEAN -- If there is no any parameter, then the parenthesses not required
		do
			-- // => DIV
			-- \\ => MOD
			if ev \\ 400 = 0 then Result := True
			elseif ev \\ 100 = 0 then Result := False
			elseif ev \\ 4 = 0 then Result := True
			else Result := False
			end
		end
	napok_szama_a_honapban: INTEGER
		do
			inspect honap
			when 1,3,5,7,8,10,12 then Result := 31
			when 4,6,9,11 then Result := 30
			when 2 then
				if szokoev then Result := 29
				else Result := 28
				end
			end
		end
	iterate
		do
			across <<1691, 7, 29>> as i
			loop
				print (i.item.out)
				print ("%N")
			end
		end
end
