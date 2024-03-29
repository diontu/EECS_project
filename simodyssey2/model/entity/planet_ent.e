note
	description: "Summary description for {PLANET_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET_ENT

inherit
	ENTITY

create
	make

feature {NONE} -- Constructor
	make
		do
			attached_to_star := false
			supports_life := false
			visited := false
			turns_left := 0
			position := [0,0]
			is_dead := false
		end

feature -- commands
	set_turns(turns: INTEGER)
		do
			turns_left := turns
		end

	support_life
		do
			supports_life := true
		end

	attach_to_star
		do
			attached_to_star := true
		end

	decrease_turns
		do
			turns_left := turns_left - 1
		end

	set_visited
		do
			visited := true
		end

	add_pos(pos: TUPLE[INTEGER, INTEGER])
		do
			position := pos
		end

	died
		do
			is_dead := true
		end

feature -- attributes
	attached_to_star: BOOLEAN

	supports_life: BOOLEAN

	visited: BOOLEAN

	turns_left: INTEGER

	position: TUPLE[row : INTEGER; column: INTEGER]

	is_dead: BOOLEAN

end
