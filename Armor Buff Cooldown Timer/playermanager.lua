_G.ArmorBuff = {}

Hooks:PostHook(PlayerManager,"init","buff_init_playermanager",function(self)
	self._player_buffs = {}
end)

function PlayerManager:add_buff(id,params)
	if not (managers.hud and id) then return end
	params = params or {}
	local current_buffs = self:get_buffs()
	local t = Application:time()
	local buff_data = self:get_buff_data()[id]
	if not buff_data then 
		return
	end

	current_buffs[id] = params
	if params.duration then
		current_buffs[id].end_t = (t + params.duration or buff_data.duration or 5)
	end
	managers.hud:add_buff(id)
end

function PlayerManager:remove_buff(id)
	self:get_buffs()[id] = nil
	managers.hud:remove_buff(id)
end

ArmorBuff.buff_data = { ["armor_break_invulnerable"] = {}}

function PlayerManager:get_buff_data()
	if buffid then
		return ArmorBuff.buff_data[buffid]
	else
		return ArmorBuff.buff_data
	end
end

function PlayerManager:get_buffs()
	return self._player_buffs
end

Hooks:PostHook(PlayerManager,"activate_temporary_upgrade","buff_activate_temporary_upgrade",function(self, category, upgrade)
	local t = self._temporary_upgrades[category] and self._temporary_upgrades["temporary"]["armor_break_invulnerable"] and self._temporary_upgrades["temporary"]["armor_break_invulnerable"].expire_time
	self:add_buff(upgrade,{end_t = t})
end)