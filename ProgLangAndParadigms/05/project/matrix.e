note
	description: "Summary description for {MATRIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MATRIX
create
	make
feature
	rows, cols: INTEGER

	item alias "[]" (i,j:INTEGER): REAL assign put
		require
			1 <= i; i <= rows; 1 <= j; j <= cols
		do
			Result := data[(i-1)*cols+j]
		end

	put (val: REAL; i,j: INTEGER)
		require 1 <= 1; i <= rows; 1 <= j; j <= cols
		do
			data[(i-1)*cols+j] := val
		ensure
			val ~ item(i,j)
		end
feature {NONE}
	data: attached ARRAY[REAL]

	make (nr_rows, nr_cols: INTEGER)
		require
			nr_rows > 0; nr_cols > 0
		do
			rows := nr_rows
			cols := nr_cols
			create data.make_filled(0.0, 1, rows*cols)
		ensure rows = nr_rows;cols=nr_cols
		end
invariant
	rows > 0 and cols > 0
	data.lower = 1; data.upper = rows*cols
end
