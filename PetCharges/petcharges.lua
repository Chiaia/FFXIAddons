--[[
Copyright © 2017, Sammeh of Quetzalcoatl
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of PetCharges nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Sammeh BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]


_addon.name = 'PetCharges'
_addon.author = 'Sammeh'
_addon.version = '1.0'
_addon.command = 'petcharges'

config = require('config')
texts = require('texts')
res = require 'resources'
packets = require('packets')

abilitytxt = {}
abilitytxt.pos = {}
abilitytxt.pos.x = -80
abilitytxt.pos.y = 45
abilitytxt.text = {}
abilitytxt.text.font = 'Arial'
abilitytxt.text.size = 10
abilitytxt.flags = {}
abilitytxt.flags.right = true

abilities_list = texts.new('${value}', abilitytxt)

showabilities = true


-- Variables for Merits and Job Points saving
merits = 5
jobpoints = 5

function displayabilities()
  
  if pet then
	abilitylist = windower.ffxi.get_abilities().job_abilities
	local list = "Charges: "..charges.."\n"
  
	for key,ability in pairs(abilitylist) do
		ability_en = res.job_abilities[ability].en
		ability_type = res.job_abilities[ability].type
		ability_targets = res.job_abilities[ability].targets
		ability_charges = res.job_abilities[ability].mp_cost
		if ability_targets.Self == true and ability_type == 'Monster' then
			if charges >= ability_charges then 
				list = list..'\\cs(0,255,0)'..ability_en..'\\cs(255,255,255)'..'\n'
			else
				list = list..'\\cs(255,255,255)'..ability_en..'\n'
			end
		end
	end
  
	abilities_list.value = list
	abilities_list:visible(true)
  else
	abilities_list:visible(false)
  end
  
  
end

windower.register_event('prerender', function()
	pet = windower.ffxi.get_mob_by_target('pet')
	local gear = windower.ffxi.get_items()
	local mainweapon = res.items[windower.ffxi.get_items(gear.equipment.main_bag, gear.equipment.main).id].en
	local subweapon = res.items[windower.ffxi.get_items(gear.equipment.sub_bag, gear.equipment.sub).id].en
	local legs = res.items[windower.ffxi.get_items(gear.equipment.legs_bag, gear.equipment.legs).id].en
	
	equip_reduction = 0
	if mainweapon == "Charmer's Merlin" or subweapon == "Charmer's Merlin" then 
		equip_reduction = equip_reduction + 5
	end
	if legs == "Desultor Tassets" then
		equip_reduction = equip_reduction + 5
	end
	
	duration = windower.ffxi.get_ability_recasts()[102]
	chargebase = (30 - merits - jobpoints - equip_reduction)
	charges = math.floor(((chargebase * 3) - duration) / chargebase)
	
	displayabilities()
end)

windower.register_event('addon command', function(command,...)
end)

