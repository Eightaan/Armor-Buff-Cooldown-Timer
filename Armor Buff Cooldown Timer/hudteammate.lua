function HUDTeammate:_add_buff(id)
	local buffs_panel = self._khud_buffs_panel
	local buff_data = managers.player:get_buff_data()[id]
	local current_buffs = managers.player:get_buffs()
	local buff = current_buffs[id]
	local num = 0
	for id in pairs(current_buffs) do
		num = num + 1
	end

	local label = buff.label or buff_data.label
	
	if buffs_panel:child(id) then
			buffs_panel:child(id):child("label"):set_color(text_color)
	else
		local buff_x = 175 * math.floor(num / 6)
		local buff_panel = buffs_panel:panel({
			name = tostring(id),
			x = buff_x,
			y = buffs_panel:h() - (num * (32 + 10)),
			w = 175,
			h = 32,
			layer = 4
		})
		local buff_label = buff_panel:text({
			name = "label",
			layer = 3,
			font_size = 16,
			font = tweak_data.hud_players.ammo_font,
			text = label,
			x = (32 * 1) + 5,
			y = (32 * 1 / 3), --not quite bottom
			color = Color.white
		})	
	end
end

function HUDTeammate:_remove_buff(id)
	local buffs_panel = self._khud_buffs_panel
	if buffs_panel:child(id) then
		buffs_panel:remove(buffs_panel:child(id))
	end
end

Hooks:PostHook(HUDTeammate,"init","khud_hudteammate_init",function(self,i,teammates_panel,is_player,width)
	if is_player then 
		local buffs = self:_create_khud_buffs()
	end
end)

function HUDTeammate:_create_khud_buffs()
	local hud_panel = managers.hud._khud_buffs_master --self._khud_player

	local khud_buffs_panel = hud_panel:panel({
		name = "khud_buffs_panel",
		layer = 1,
		x = 32,
		y = hud_panel:h() - (300 + 176),
		w = 400,
		h = 300
	})
	self._khud_buffs_panel = khud_buffs_panel
	return khud_buffs_panel
end

function HUDTeammate:_layout_khud_buffs(params)
	local buffs_panel = self._khud_buffs_panel
	buffs_panel:set_x(947)
	buffs_panel:set_y(386)
end