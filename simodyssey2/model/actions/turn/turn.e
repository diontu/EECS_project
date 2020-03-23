note
	description: "Summary description for {TURN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TURN

create
	make

feature -- model
	model: ETF_MODEL
	model_access: ETF_MODEL_ACCESS

	-- player commands
	land_command: LAND
	liftoff_command: LIFTOFF
	move_command: MOVE
	pass_command: PASS
	wormhole_command: WORMHOLE

feature -- constructor -- ALWAYS MAKE SURE THE MODEL IS ATTACHED
	make
		do
			model := model_access.m

			create land_command.make
			create liftoff_command.make
			create move_command.make
			create pass_command.make
			create wormhole_command.make
		ensure
			attached_model: attached model
		end

feature -- execute

	execute (action: ACTION)
		do
			-- must attach the model here... idk why but the one in constructor is broken
			model := model_access.m

			-- next turn state
			model.new_turn_state

			--logic
			act(action)
			if model.ok_or_error.is_equal ("ok") then
				-- perform check(entity), etc
			end
		end

feature {NONE} -- make private features
	act (action: ACTION)
		do
			if action.action.is_equal ("land") then
				land_command.execute

			elseif action.action.is_equal ("liftoff") then
				liftoff_command.execute

			elseif action.action.is_equal ("move") then
				if attached {MOVE_ACTION} action as moveAction then
					move_command.add_direction (moveAction.direction)
				end
				move_command.execute

			elseif action.action.is_equal ("pass") then
				pass_command.execute

			elseif action.action.is_equal ("wormhole") then
				wormhole_command.execute
			end
		end


end
