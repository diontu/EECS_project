note
	description: "Summary description for {BLUE_GIANT_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLUE_GIANT_ENT

inherit
	STAR_ENT

create
	make

feature {NONE} -- Constructor
	make
		do
			position := [0,0]
		end

feature -- commdans
	add_pos(pos: TUPLE[INTEGER, INTEGER])
		do
			position := pos
		end

feature -- attribute
	luminosity: INTEGER
		do
			Result := 5
		end

	position: TUPLE[INTEGER,INTEGER]

end
