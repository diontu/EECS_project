note
	description: "LAND_ACTION object is only created in ETF_LAND"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LAND_ACTION

inherit
	ACTION

create
	make

feature -- constructor
	make
		do
			action := "land"
		end

feature -- attribute
	action: STRING

end
