note
	description: "This class transforms the current position, with the direction"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVEMENT_UTILITY

feature --
	transform(pos: TUPLE[pos_row: INTEGER; pos_col: INTEGER]; dir: TUPLE[dir_row:INTEGER; dir_col: INTEGER]): TUPLE[INTEGER, INTEGER]
		do
			Result := [0,0]
		end

end
