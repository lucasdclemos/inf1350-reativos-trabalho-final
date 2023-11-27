local mqtt = require("mqtt_library")

local linha = 0
local coluna = 0
local matriz = {}
local jogador = 1

for i = 0, 1, 2, 3, 4, 5, 6, 7 do
  for j = 0, 1, 2, 3, 4, 5, 6, 7 do
    matriz[i][j] = 0
  end  
end

function controller(msg)
  
end

function mqttcb(t,m)
  if(t == "paraloveA14") then
  end
  print("MENSAGEM RECEBIDA: "..m)
  controller(m)
  
    
end

function love.draw()
  -- DESENHAR O TABULEIRO
end

function love.update(dt)
  mqtt_client:handler()
end