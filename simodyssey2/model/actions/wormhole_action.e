note
	description: "WORMHOLE_ACTION object is only created in ETF_WORMHOLE"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE_ACTION

inherit
	ACTION

create
	make

feature -- constructor
	make
		do
			action := "wormhole"
		end

feature -- attribute
	action: STRING

end
