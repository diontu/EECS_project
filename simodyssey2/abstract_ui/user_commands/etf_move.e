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
--		local
--			move_action: MOVE_ACTION
    	do
			-- perform some update on the model state
--			move_action := create {MOVE_ACTION}.make ("move", [1,1])

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
