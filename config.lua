---------------------------------------------
-- Nosso Discord
-- https://discord.gg/UajwX4a
---------------------------------------------

local config = {}

-- Coordenada Para Inicar o Serviçp
config.startLoc = vector3( -1348.51, 142.73, 56.44 )

-- Tempo da Animação
config.animTime = 10

-- Setar se a Base é Creative Ou Não
config.isCreative = false

-- Locais onde serão plantadas as flores
config.locs = {
	[1] =  { ['x'] = -1368.32, 	['y'] = 46.57, 		['z'] = 53.91  	},
	[2] =  { ['x'] = -1346.85, 	['y'] = 120.5, 		['z'] = 56.37  	},
	[3] =  { ['x'] = -1370.17, 	['y'] = 66.53, 		['z'] = 53.92  	},
	[4] =  { ['x'] = -1372.97, 	['y'] = 172.81,		['z'] = 58.02 	},
	[5] =  { ['x'] = -1323.31, 	['y'] = 64.3, 		['z'] = 53.54  	},
	[6] =  { ['x'] = -1322.29, 	['y'] = 56.09, 		['z'] = 53.55 	},
	[7] =  { ['x'] = -1218.48, 	['y'] = 107.57,		['z'] = 58.04  	},
	[8] =  { ['x'] = -1108.74, 	['y'] = 157.63,		['z'] = 63.04  	},
	[9] =  { ['x'] = -987.46, 	['y'] = -101.82, 	['z'] = 40.58  	},
	[10] = { ['x'] = -1112.58, 	['y'] = -106.0, 	['z'] = 41.85 	},
}

-- Setar se as rotas serão Random, ou Sequencial
config.isRandom = true

-- Valor a Receber por Plantar a Flores
config.reward = 150

return config