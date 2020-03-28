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
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS

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
			entity_ids := entity_ids_access.entity_ids
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
		local
			explorer_entity_alphabet: ENTITY_ALPHABET
		do
			-- must attach the model here... idk why but the one in constructor is broken
			model := model_access.m
			entity_ids := entity_ids_access.entity_ids

			-- next turn state
			model.new_turn_state

			-- attach explorer with entity alphabet
			explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)

			--logic
			act(action)
			-- if error exists, then skip entire if block
-------------- print the outputs at the end of the if statement if no errors -------------
			if model.ok_or_error.is_equal ("ok") then
				-- perform check(entity), etc
				check_entity (explorer_entity_alphabet)
				-- display the outputs after the turn
				model.output_states
				model.output_movements
				if model.mode.is_equal ("test") then
					model.output_sectors
					model.output_descriptions
					model.output_deaths
				end
				model.output_galaxy

				-- entering this if statement ends the game
				if model.is_gameover then
					model.not_in_game_mode
					model.not_gameover
				end
			end
		end

feature {NONE} -- make private features
	act (action: ACTION)
		local

		explorer_entity_alphabet : ENTITY_ALPHABET

		do
			entity_ids := entity_ids_access.entity_ids
			explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
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
				wormhole_command.execute(explorer_entity_alphabet)
			end
		end




feature {NONE} -- check_entity
	check_entity (ent_alpha: ENTITY_ALPHABET)
		local
			sector: SECTOR
			variable_deaths_msg: STRING -- bc the death_msg could change from death by fuel to death by blackhole
		do
			-- current sector
			if attached {ENTITY} ent_alpha.entity as ent then
				-- could be somthing wrong OVER HERE
				sector := model.galaxy.grid[ent.position.row, ent.position.col]

				-- includes explorer, benign, malevolent, janitaur

				-- if the entity didn't use the wormhole
				if attached {FUELED_ENT} ent as fueled_ent then
					if not fueled_ent.used_wormhole then
						fueled_ent.decrement_fuel_by (1)
					end
					if fueled_ent.used_wormhole then
						fueled_ent.not_in_wormhole
					end
				end

				-- if the entity got to a sector with a star
				if attached {FUELED_ENT} ent as fueled_ent and sector.has_star then
					if sector.has_yd then
						fueled_ent.increment_fuel_by (2)
					elseif sector.has_bg then
						fueled_ent.increment_fuel_by (5)
					end
				end

				-- if the entity ran out of fuel
				create variable_deaths_msg.make_empty
				if attached {FUELED_ENT} ent as fueled_ent then
					if fueled_ent.fuel = 0 then
						-- entity dies
						-- use the sector.delete(ent_alpha)?

						-- deletes the entity_alphabet from the board and entity_ids
--						sector.delete (ent_alpha)

						model.an_entity_died

						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("    ")
						variable_deaths_msg.append ("[")
						variable_deaths_msg.append (ent_alpha.id.out)
						variable_deaths_msg.append (",")
						variable_deaths_msg.append (ent_alpha.item.out)
						variable_deaths_msg.append ("]")
						variable_deaths_msg.append ("->")
						if attached {EXPLORER_ENT} fueled_ent as explorer then
							variable_deaths_msg.append ("fuel:")
							variable_deaths_msg.append (explorer.fuel.out)
							variable_deaths_msg.append ("/3")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("life:")
							variable_deaths_msg.append (explorer.life.out)
							variable_deaths_msg.append ("/3")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("landed?:")
							variable_deaths_msg.append (explorer.is_landed.out.at (1).out)
							variable_deaths_msg.append (",")
							variable_deaths_msg.append ("%N")
							variable_deaths_msg.append ("      ")
							variable_deaths_msg.append ("Explorer got lost in space - out of fuel at Sector:")
							variable_deaths_msg.append (ent.position.row.out)
							variable_deaths_msg.append (":")
							variable_deaths_msg.append (ent.position.col.out)

							-- make it so that the game has to end
							model.gameover

						elseif attached {BENIGN_ENT} fueled_ent as benign then
							variable_deaths_msg.append ("fuel:")
							variable_deaths_msg.append (benign.fuel.out)
							variable_deaths_msg.append ("/3")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("actions_left_until_reproduction:")
							variable_deaths_msg.append (benign.actions_left.out)
							variable_deaths_msg.append ("/1")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("turns_left:")
							variable_deaths_msg.append (benign.turns_left.out)
							variable_deaths_msg.append (",")
							variable_deaths_msg.append ("%N")
							variable_deaths_msg.append ("      ")
							variable_deaths_msg.append ("Benign got lost in space - out of fuel at Sector:")
							variable_deaths_msg.append (ent.position.row.out)
							variable_deaths_msg.append (":")
							variable_deaths_msg.append (ent.position.col.out)
						elseif attached {MALEVOLENT_ENT} fueled_ent as malevolent then
							variable_deaths_msg.append ("fuel:")
							variable_deaths_msg.append (malevolent.fuel.out)
							variable_deaths_msg.append ("/3")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("actions_left_until_reproduction:")
							variable_deaths_msg.append (malevolent.actions_left.out)
							variable_deaths_msg.append ("/1")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("turns_left:")
							variable_deaths_msg.append (malevolent.turns_left.out)
							variable_deaths_msg.append ("%N")
							variable_deaths_msg.append ("      ")
							variable_deaths_msg.append ("Malevolent got lost in space - out of fuel at Sector:")
							variable_deaths_msg.append (ent.position.row.out)
							variable_deaths_msg.append (":")
							variable_deaths_msg.append (ent.position.col.out)
						elseif attached {JANITAUR_ENT} fueled_ent as janitaur then
							variable_deaths_msg.append ("fuel:")
							variable_deaths_msg.append (janitaur.fuel.out)
							variable_deaths_msg.append ("/5")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("load:")
							variable_deaths_msg.append (janitaur.load_level.out)
							variable_deaths_msg.append ("/2")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("actions_left_until_reproduction:")
							variable_deaths_msg.append (janitaur.actions_left.out)
							variable_deaths_msg.append ("/2")
							variable_deaths_msg.append (", ")
							variable_deaths_msg.append ("turns_left:")
							variable_deaths_msg.append (janitaur.turns_left.out)
							variable_deaths_msg.append ("%N")
							variable_deaths_msg.append ("      ")
							variable_deaths_msg.append ("Janitaur got lost in space - out of fuel at Sector:")
							variable_deaths_msg.append (ent.position.row.out)
							variable_deaths_msg.append (":")
							variable_deaths_msg.append (ent.position.col.out)
						end
					end
				end

-- ========================================================================================
-- ERROR: whenever I delete from the entity from above and run the sector.has_bh command
-- I get an infinite loop
-- ========================================================================================
				-- if the entity is in a quadrant with a blackhole
				if sector.has_bh then
					-- entity dies in the blackhole
					-- use the sector.delete(ent_alpha)?
					create variable_deaths_msg.make_empty

--					sector.delete (ent_alpha)

					model.an_entity_died

					variable_deaths_msg.append ("%N")
					variable_deaths_msg.append ("    ")
					variable_deaths_msg.append ("[")
					variable_deaths_msg.append (ent_alpha.id.out)
					variable_deaths_msg.append (",")
					variable_deaths_msg.append (ent_alpha.item.out)
					variable_deaths_msg.append ("]")
					variable_deaths_msg.append ("->")
					if attached {EXPLORER_ENT} ent as explorer then
						variable_deaths_msg.append ("fuel:")
						variable_deaths_msg.append (explorer.fuel.out)
						variable_deaths_msg.append ("/3")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("life:")
						variable_deaths_msg.append (explorer.life.out)
						variable_deaths_msg.append ("/3")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("landed?:")
						variable_deaths_msg.append (explorer.is_landed.out.at (1).out)
						variable_deaths_msg.append (",")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Explorer got devoured by blackhole (id: -1) at Sector:3:3")

						-- make it so that the game has to end
						model.gameover

					elseif attached {BENIGN_ENT} ent as benign then
						variable_deaths_msg.append ("fuel:")
						variable_deaths_msg.append (benign.fuel.out)
						variable_deaths_msg.append ("/3")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("actions_left_until_reproduction:")
						variable_deaths_msg.append (benign.actions_left.out)
						variable_deaths_msg.append ("/1")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("turns_left:")
						variable_deaths_msg.append (benign.turns_left.out)
						variable_deaths_msg.append (",")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Benign got devoured by blackhole (id: -1) at Sector:3:3")
					elseif attached {MALEVOLENT_ENT} ent as malevolent then
						variable_deaths_msg.append ("fuel:")
						variable_deaths_msg.append (malevolent.fuel.out)
						variable_deaths_msg.append ("/3")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("actions_left_until_reproduction:")
						variable_deaths_msg.append (malevolent.actions_left.out)
						variable_deaths_msg.append ("/1")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("turns_left:")
						variable_deaths_msg.append (malevolent.turns_left.out)
						variable_deaths_msg.append (",")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Malevolent got devoured by blackhole (id: -1) at Sector:3:3")
					elseif attached {JANITAUR_ENT} ent as janitaur then
						variable_deaths_msg.append ("fuel:")
						variable_deaths_msg.append (janitaur.fuel.out)
						variable_deaths_msg.append ("/5")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("load:")
						variable_deaths_msg.append (janitaur.load_level.out)
						variable_deaths_msg.append ("/2")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("actions_left_until_reproduction:")
						variable_deaths_msg.append (janitaur.actions_left.out)
						variable_deaths_msg.append ("/2")
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("turns_left:")
						variable_deaths_msg.append (janitaur.turns_left.out)
						variable_deaths_msg.append (",")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Janitaur got devoured by blackhole (id: -1) at Sector:3:3")
					elseif attached {PLANET_ENT} ent as planet then
						variable_deaths_msg.append ("attached?:")
						variable_deaths_msg.append (planet.attached_to_star.out.at (1).out)
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("support_life?:")
						variable_deaths_msg.append (planet.supports_life.out.at (1).out)
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("visited?:")
						variable_deaths_msg.append (planet.visited.out.at (1).out)
						variable_deaths_msg.append (", ")
						variable_deaths_msg.append ("turns_left:")
						variable_deaths_msg.append (planet.turns_left.out)
						variable_deaths_msg.append (",")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Planet got devoured by blackhole (id: -1) at Sector:3:3")
					elseif attached {ASTEROID_ENT} ent as asteroid then
						variable_deaths_msg.append ("turns_left:")
						variable_deaths_msg.append (asteroid.turns_left.out)
						variable_deaths_msg.append (",")
						variable_deaths_msg.append ("%N")
						variable_deaths_msg.append ("      ")
						variable_deaths_msg.append ("Asteroid got devoured by blackhole (id: -1) at Sector:3:3")
					end
				end

				if model.entities_died then
-- ==========================================================================================
-- SOLVED: delete the entity at the end
-- ==========================================================================================
					sector.delete (ent_alpha)
					model.deaths_msg_append (variable_deaths_msg)
				end

			end
		end

end
