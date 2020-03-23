note
    description: "[
       Alphabet allowed to appear on the galaxy board.
    ]"
    author: "Kevin Banh"
    date: "April 30, 2019"
    revision: "1"

class
    ENTITY_ALPHABET

inherit
    ANY
        redefine
            out,
            is_equal
        end

create
    make

feature -- Constructor

    make (a_char: CHARACTER)
--    	local
--    		entity_ids: ENTITY_IDS
--    		entity_ids_access: ENTITY_IDS_ACCESS
        do
            item := a_char
        	-------------------- ADDED start --------------------
            if item.is_equal ('E') then
            	id := 0
            	entity := (create {EXPLORER_ENT}.make)
            elseif item.is_equal ('P') then
            	id := shared_info.movable_id
            	shared_info.increment_movable_id
            	entity := (create {PLANET_ENT}.make)
            elseif item.is_equal ('O') then
            	id := -1
            	entity := (create {BLACKHOLE_ENT}.make)
            elseif item.is_equal ('Y') then
            	id := shared_info.stationary_id
            	shared_info.decrement_stationary_id
            	entity := (create {YELLOW_DWARF_ENT}.make)
            elseif item.is_equal ('*') then
            	id := shared_info.stationary_id
            	shared_info.decrement_stationary_id
            	entity := (create {BLUE_GIANT_ENT}.make)
            elseif item.is_equal ('W') then
            	id := shared_info.stationary_id
            	shared_info.decrement_stationary_id
            	entity := (create {WORMHOLE_ENT}.make)
            else -- will never occur
            	id := -100
            	entity := (create {PLANET_ENT}.make)
            end

			--position := [0,0] -- entity will never be in this position
--            entity_ids := entity_ids_access.entity_ids
--            entity_ids.add (id, current)
            -------------------- ADDED end --------------------
        end

feature -- Attributes

    item: CHARACTER
    -------------------- ADDED start --------------------
    entity: ENTITY

    id: INTEGER

	shared_info_access: SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result := shared_info_access.shared_info
		end
	-------------------- ADDED end --------------------

feature -- commands
	add_pos(pos: TUPLE[INTEGER, INTEGER])
		do
			--position := pos
			if item.is_equal ('E') then
            	if attached {EXPLORER_ENT} entity as explorer then
            		explorer.add_pos(pos)
            	end
            elseif item.is_equal ('P') then
            	if attached {PLANET_ENT} entity as planet then
            		planet.add_pos(pos)
            	end
            elseif item.is_equal ('O') then
            	if attached {BLACKHOLE_ENT} entity as blackhole then
            		blackhole.add_pos(pos)
            	end
            elseif item.is_equal ('Y') then
            	if attached {YELLOW_DWARF_ENT} entity as yellow_dwarf then
            		yellow_dwarf.add_pos(pos)
            	end
            elseif item.is_equal ('*') then
            	if attached {BLUE_GIANT_ENT} entity as blue_giant then
            		blue_giant.add_pos(pos)
            	end
            elseif item.is_equal ('W') then
            	if attached {WORMHOLE_ENT} entity as wormhole then
            		wormhole.add_pos(pos)
            	end
            else -- will never occur

            end
		end

feature -- Query

    out: STRING
            -- Return string representation of alphabet.
        do
            Result := item.out
        end

    is_equal(other : ENTITY_ALPHABET): BOOLEAN
        do
            Result := current.item.is_equal (other.item)
        end

    is_stationary: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'W' or item = 'Y' or item = '*' or item = 'O' then
           		Result := True
           end
        end

invariant
    allowable_symbols:
        item = 'E' or item = 'P' or item = 'A' or item = 'M' or  item = 'J' or item = 'O' or item = 'W' or item = 'Y' or item = '*' or item='B'
end
