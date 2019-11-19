local function format_seconds(raw)
	return string.format("%02d",math.floor(raw % 60))
end

Hooks:PreHook(HUDManager,"_create_teammates_panel","khud_hudmanager_create_teammates_panel",function(self,hud)
	hud = hud or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	self._khud_buffs_master = hud.panel:panel({
		name = "khud_buffs_master",
		halign = "grow",
		valign = "bottom",
		w = hud.panel:w(),
		h = hud.panel:h()
	})
end)

Hooks:PostHook(HUDManager,"update","khud_hudmanager_update",function(self,t,dt)
	local hud_panel = self._teammate_panels[HUDManager.PLAYER_PANEL]
	local _t = Application:time()
	local player_unit = managers.player and managers.player:local_player()
	if not (player_unit) then 
		managers.player._player_buffs = {}
		return
	end
	
	local buffs = managers.player:get_buffs()

	local buffs_parent_panel = hud_panel._khud_buffs_panel
	local buff_panel
	local buff_label
	local text = ""
	local buff_data = managers.player:get_buff_data()
	local time_left = 0
	local buff_num = 1
	local queued_remove_buffs = {} --todo global this
	
	for id, buff in pairs(buffs) do
		buff_panel = buffs_parent_panel:child(id)
		buff_label = buff_panel:child("label")	
			if not buff.end_t then 
				table.insert(queued_remove_buffs,id)
				break --go directly to jail, do not pass go, do not collect $200
			end
			time_left = buff.end_t - _t
			text = format_seconds(1 + math.floor(time_left))
			if buff.end_t < _t and not buff_data[id].persistent_timer then 
				table.insert(queued_remove_buffs,id)
			else

					local invuln_timer = player_unit:character_damage()._can_take_dmg_timer
					if invuln_timer and invuln_timer > 0 then 
						buff_label:set_text(text)
						buff_label:set_color(Color("FFFFFF"))
						buff_label:set_alpha(1)
					else
						buff_label:set_text(text)
						buff_label:set_color(Color("FFFFFF"))
						buff_label:set_alpha(1)
					end 

			end	
			
		buff_panel:set_x(buff_panel:w() * math.floor(buff_num / 6)) --6 is max_per_column
		buff_panel:set_y(buffs_parent_panel:h() - ((buff_num % 6) * (buff_panel:h() + 10))) --6 is max_per_column; todo make pad small with more buffs

		buff_num = buff_num + 1 ---this feels wrong
	end
	
	for n,buffid in ipairs(queued_remove_buffs) do
		managers.player:remove_buff(buffid) --doing this cause it's probably a bad idea to modify the table you're iterating through otherwise
	end

end)

--trackers
function HUDManager:add_buff(id)
	local hud = self._teammate_panels[HUDManager.PLAYER_PANEL]
	hud:_add_buff(id)
end

function HUDManager:remove_buff(id)
	local hud = self._teammate_panels[HUDManager.PLAYER_PANEL]
	hud:_remove_buff(id)
end

function HUDManager:layout_khud_buffs(params)
	self._teammate_panels[HUDManager.PLAYER_PANEL]:_layout_khud_buffs(params)
end