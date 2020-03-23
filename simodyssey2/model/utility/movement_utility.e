note
	description: "This class transforms the current position, with the direction"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVEMENT_UTILITY

create
	make

feature -- constructor
	make
		do
			
		end

feature --
	transform(pos: TUPLE[pos_row: INTEGER; pos_col: INTEGER]; dir: TUPLE[dir_row:INTEGER; dir_col: INTEGER]): TUPLE[INTEGER, INTEGER]
		local
			new_pos_col: INTEGER
			new_pos_row: INTEGER
		do
--			if attached {INTEGER} movement.at (1) as move_left_right and attached {INTEGER} movement.at (2) as move_up_down then
			if (dir.dir_row + pos.pos_col) > 5 then
				new_pos_col := 1
			elseif (dir.dir_row + pos.pos_col) < 1 then
				new_pos_col := 5
			else
				new_pos_col := dir.dir_row + pos.pos_col
			end

			if (dir.dir_col + pos.pos_row) > 5 then
				new_pos_row := 1
			elseif (dir.dir_col + pos.pos_row) < 1 then
				new_pos_row := 5
			else
				new_pos_row := dir.dir_col + pos.pos_row
			end

			Result := [new_pos_row, new_pos_col]
--			end
		end

end
