note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PASS
inherit
	ETF_PASS_INTERFACE
create
	make
feature -- command
	pass
    	do
			-- perform some update on the model state
			model.turn (create {PASS_ACTION}.make)
			etf_cmd_container.on_change.notify ([Current])
    	end

end
