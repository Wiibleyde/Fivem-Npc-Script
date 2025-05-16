--A list of all the animations can be found here: https://alexguirre.github.io/animations-list/

Config = {}
Config.Invincible = true --Peds to be invincible?
Config.Frozen = true --Peds to be unable to move?
Config.Stoic = true --Peds to react to what is happening in their surroundings?
Config.Fade = true --Peds to fade into/out of existence? It looks better than just *POP* its there.
Config.Distance = 100.0 --The distance at which the peds will be spawned. This is the distance from the player.

Config.MarkerDistance = 1.3 --The distance at which the marker will be displayed. This is the distance from the ped.
Config.InteractionText = "Appuyez sur ~INPUT_CONTEXT~ pour interagir" --The text that will be displayed when near a ped

--If so, set this to true. You'll have to adjust the coordinates for defaults down - 1 if you set false.
Config.MinusOne = true

Config.PedList = {
    {
        model = "a_m_y_epsilon_01", --Skin
        coords = vector3(-28.61,-143.49,57.01), --Position
        heading = 180.0, --Orientation
        gender = "male", --Male or female (only for dev usage)
        animDict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@", --Anim dict played
        animName = "med_right_down", --Anim name played (need anim dict)
        isRendered = false, --To disable set to true
        ped = nil, --For the script
        interactionText = "Appuyez sur ~INPUT_CONTEXT~ pour interagir (Étape 1)", -- Custom text for the ped
		-- Following config is for NUI
		title = "Étape 1",
		description = "Vous devez trouver le code de la porte. Il est caché dans la pièce à côté.",
		image = "./img/testImg.png", -- Path to the image
    },
	{
		model = "a_m_y_epsilon_02", --Skin
		coords = vector3(-31.61,-143.49,57.01), --Position
		heading = 180.0, --Orientation
		gender = "male", --Male or female (only for dev usage)
		animDict = "", --Anim dict played
		animName = "", --Anim name played (need anim dict)
		isRendered = false, --To disable set to true
		ped = nil, --For the script
		interactionText = "Appuyez sur ~INPUT_CONTEXT~ pour interagir (Étape 2)", -- Custom text for the ped
		-- Following config is for NUI
		title = "Étape 2",
		description = "Vous devez trouver le code de la porte. Il est caché dans la pièce à côté.",
		image = "./img/testImg.png", -- Path to the image
	},
	{
		model = "a_m_y_musclbeac_01", --Skin
		coords = vector3(-34.61,-143.49,57.01), --Position
		heading = 180.0, --Orientation
		gender = "male",
		animDict = "", --Anim dict played
		animName = "", --Anim name played (need anim dict)
		isRendered = false, --To disable set to true
		ped = nil, --For the script
		interactionText = "Appuyez sur ~INPUT_CONTEXT~ pour interagir (Étape 3)", -- Custom text for the ped
		-- Following config is for NUI
		title = "Étape 3",
		description = "Vous devez trouver le code de la porte. Il est caché dans la pièce à côté.",
		image = "./img/testImg.png", -- Path to the image
	},
}