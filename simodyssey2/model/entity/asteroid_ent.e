note
	description: "Summary description for {ASTEROID_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASTEROID_ENT

inherit
	ENTITY

create
	make

feature {NONE} -- constructor
	make
		do
			turns_left := 0
			position := [0,0]
			is_dead := false
		end

feature -- add the position	
	add_pos(pos: TUPLE[INTEGER, INTEGER])
		do
			position := pos
		end

feature -- turns
	set_turns (amount: INTEGER)
		require
			valid_amount: amount >=0 and amount <= 3
		do
			turns_left := amount
		end

	decrement_turns
		do
			turns_left := turns_left - 1
		end

	died
		do
			is_dead := true
		end

feature -- attributes
	position: TUPLE[INTEGER, INTEGER]
	turns_left: INTEGER
	is_dead: BOOLEAN

end
