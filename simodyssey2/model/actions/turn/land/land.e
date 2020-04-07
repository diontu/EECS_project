note
	description: "Summary description for {LAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LAND

create
	make

feature -- attributes
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS


feature -- constructor
	make
		do
			game_state := game_state_access.gs
			entity_ids := entity_ids_access.entity_ids
		end

feature -- execute
	execute
	local
		explorer: EXPLORER_ENT
		explorer_entity_alphabet: ENTITY_ALPHABET
		sector : SECTOR

		visited : BOOLEAN
		found_life : BOOLEAN

		ctr :INTEGER


		do
		game_state := game_state_access.gs
		entity_ids := entity_ids_access.entity_ids
		visited := false
		found_life := false

		-- set the explorer
		explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
		if attached {EXPLORER_ENT} explorer_entity_alphabet.entity as exp then
		explorer := exp
		end

		if attached{EXPLORER_ENT} explorer as exp then
			if game_state.mode.is_equal ("none") then
					game_state.update_mini_state
					game_state.error_state
					game_state.states_msg_append ("%N")
					game_state.states_msg_append ("  ")
					game_state.states_msg_append ("Negative on that request:no mission in progress.")
					game_state.output_states
			else
			sector := game_state.galaxy.grid[exp.position.row,exp.position.col]
			if exp.is_landed then

						game_state.update_mini_state
						game_state.error_state
						game_state.states_msg_append ("%N")
						game_state.states_msg_append ("  ")
						game_state.states_msg_append ("Negative on that request:you are currently landed at Sector:")
						game_state.states_msg_append (exp.position.row.out)
						game_state.states_msg_append (":")
						game_state.states_msg_append (exp.position.col.out)
						game_state.output_states

			elseif not sector.has_yd then
							game_state.update_mini_state
							game_state.error_state
							game_state.states_msg_append ("%N")
							game_state.states_msg_append ("  ")
							game_state.states_msg_append ("Negative on that request:no yellow dwarf at Sector:")
							game_state.states_msg_append (exp.position.row.out)
							game_state.states_msg_append (":")
							game_state.states_msg_append (exp.position.col.out)
							game_state.output_states


			elseif not sector.has_pl then
				game_state.update_mini_state
							game_state.error_state
							game_state.states_msg_append ("%N")
							game_state.states_msg_append ("  ")
							game_state.states_msg_append ("Negative on that request:no planet at Sector:")
							game_state.states_msg_append (exp.position.row.out)
							game_state.states_msg_append (":")
							game_state.states_msg_append (exp.position.col.out)
							game_state.output_states
			else


from
	ctr := 1

until
	ctr ~ sector.contents.count + 1
loop

	if attached {ENTITY_ALPHABET} sector.contents[ctr] as vs then
		if attached {PLANET_ENT} vs.entity as planet then
							if planet.visited then
							visited := true
							else
							if planet.supports_life then
							found_life := true
							else
								planet.set_visited
							end
							end
						end
					end
					ctr := ctr + 1
end

			if found_life then
							explorer.land -- added to make the turn easier for me to implement
							game_state.update_state
							game_state.states_msg_append ("%N")
							game_state.states_msg_append ("  ")
							game_state.states_msg_append ("Tranquility base here - we've got a life!")
							game_state.gameover
						--	game_state.output_states
			elseif visited then
							game_state.update_mini_state
							game_state.error_state
							game_state.states_msg_append ("%N")
							game_state.states_msg_append ("  ")
							game_state.states_msg_append ("Negative on that request:no unvisited planets at Sector:")
							game_state.states_msg_append (exp.position.row.out)
							game_state.states_msg_append (":")
							game_state.states_msg_append (exp.position.col.out)
							game_state.output_states
			else
							explorer.land
							game_state.update_state
							game_state.states_msg_append ("%N")
							game_state.states_msg_append ("  ")
							game_state.states_msg_append ("Explorer found no life as we know it at Sector:")
							game_state.states_msg_append (exp.position.row.out)
							game_state.states_msg_append (":")
							game_state.states_msg_append (exp.position.col.out)
						--	game_state.output_states
			end
			end
			end
			end
		end

end
