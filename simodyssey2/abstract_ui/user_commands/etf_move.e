note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE
inherit
	ETF_MOVE_INTERFACE
create
	make

feature -- command
	move(dir: INTEGER_32)
		require else
			move_precond(dir)
		local
			du: DIRECTION_UTILITY
    	do
			-- perform some update on the model state

			model.turn (create {MOVE_ACTION}.make (du.num_dir (dir)))
			etf_cmd_container.on_change.notify ([Current])
    	end

end
