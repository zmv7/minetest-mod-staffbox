local staffbox = {}
staffs = { --add names in this table
  "singleplayer"

}

local function intable(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

minetest.register_node("staffbox:box", {
  paramtype = "light",
  description = "StaffBox",
  tiles = {"staffbox.png"},
  after_place_node = function(pos, placer, itemstack)
    local meta = minetest.get_meta(pos)
    meta:set_string("infotext", "StaffBox")
    local inv = meta:get_inventory()
    inv:set_size("main", 16*8)
    inv:set_size("drop", 1)
  end,
  on_rightclick = function(pos, node, clicker, itemstack)
    local meta = minetest.get_meta(pos)
    local player = clicker:get_player_name()
    local meta = minetest.get_meta(pos)
    if intable(staffs,player) then
      minetest.show_formspec(
        player,
        "staffbox:staff",
        staffbox.get_staff_formspec(pos))
    else
      minetest.show_formspec(
        player,
        "staffbox:player",
        staffbox.get_player_formspec(pos))
    end
  end,
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    if listname == "drop" and inv:room_for_item("main", stack) then
      inv:remove_item("drop", stack)
      inv:add_item("main", stack)
    end
  end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
    if listname == "main" then
      return 0
    end
    if listname == "drop" then
      local meta = minetest.get_meta(pos)
      local inv = meta:get_inventory()
      if inv:room_for_item("main", stack) and stack:get_name() == "default:book_written" then  --recieve written books only!
        return -1
      else
        return 0
      end
    end
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
    local meta = minetest.get_meta(pos)
    if not intable(staffs,player:get_player_name()) then
      return 0
    end
    return stack:get_count()
  end,
  allow_metadata_inventory_move = function(pos)
    return 0
  end,
})

function staffbox.get_staff_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"size[16,13]"..
		"list[nodemeta:"..spos..";main;0,0;16,13;]"..
		"list[current_player;main;4,9;8,4;]listring[]"
	return formspec
end

function staffbox.get_player_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"size[8,7]"..
		"label[2.7,0;Put here written books only]"..
		"list[nodemeta:"..spos..";drop;3.5,1;1,1;]"..
		"list[current_player;main;0,3;8,4;]listring[]"
	return formspec
end
