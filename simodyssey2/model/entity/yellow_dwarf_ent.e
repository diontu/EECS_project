note
	description: "Summary description for {YELLOW_DWARF_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	YELLOW_DWARF_ENT

inherit
	STAR_ENT

create
	make

feature {NONE} -- Constructor
	make
		do
			position := [0,0]
		end

feature -- commands
	add_pos(pos: TUPLE[INTEGER, INTEGER])
		do
			position := pos
		end

feature -- attribute
	luminosity: INTEGER
		do
			Result := 2
		end

	position: TUPLE[INTEGER,INTEGER]

end
