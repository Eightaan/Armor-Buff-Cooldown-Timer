local function format_seconds(raw)
	return string.format("%02d",math.floor(raw % 60))
end

Hooks:PreHook(HUDManager,"_create_teammates_panel","buff_hudmanager_create_teammates_panel",function(self, hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._buffs_master = hud.panel:panel({
		name = "buffs_master",
		x = 1023,
		y = 630,
		w = hud.panel:w(),
		h = hud.panel:h()
	})
end)

Hooks:PostHook(HUDManager,"update","buff_hudmanager_update",function(self, ...)
	local _t = Application:time()
	local player_unit = managers.player and managers.player:local_player()
	if not (player_unit) then 
		managers.player._player_buffs = {}
		return
	end
	
	local buffs = managers.player:get_buffs()

	local buffs_parent_panel = self._buffs_master
	local buff_panel
	local buff_label
	local text = ""
	local buff_data = managers.player:get_buff_data()
	local time_left = 0
	local queued_remove_buffs = {}
	
	for id, buff in pairs(buffs) do
		buff_panel = buffs_parent_panel:child(id)
		buff_label = buff_panel:child("label")	
		if not buff.end_t then 
			table.insert(queued_remove_buffs,id)
			break
		end
		
		time_left = buff.end_t - _t
		text = format_seconds(1 + math.floor(time_left))
		if buff.end_t < _t and not buff_data[id].persistent_timer then 
			table.insert(queued_remove_buffs,id)
		else
			local invuln_timer = player_unit:character_damage()._can_take_dmg_timer
			if invuln_timer and invuln_timer > 0 then 
				buff_label:set_text(text)
				buff_label:set_color(Color("66ff99"))
				buff_label:set_alpha(1)
			else
				buff_label:set_text(text)
				buff_label:set_color(Color("ff6666"))
				buff_label:set_alpha(1)
			end 
		end	
	end
	
	for n,buffid in ipairs(queued_remove_buffs) do
		managers.player:remove_buff(buffid)
	end

end)

--trackers
function HUDManager:add_buff(id)
	local buffs_panel = self._buffs_master
	local buff_data = managers.player:get_buff_data()[id]
	local current_buffs = managers.player:get_buffs()
	local buff = current_buffs[id]

	local label = buff.label or buff_data.label
	
	if buffs_panel:child(id) then
			buffs_panel:child(id):child("label"):set_color(text_color)
	else
		local buff_panel = buffs_panel:panel({
			name = tostring(id)
		})
		local buff_label = buff_panel:text({
			name = "label",
			font_size = 16,
			font = tweak_data.hud.medium_font_noshadow,
			text = label
		})	
	end
end

function HUDManager:remove_buff(id)
	local buffs_panel = self._buffs_master
	if buffs_panel:child(id) then
		buffs_panel:remove(buffs_panel:child(id))
	end
end
