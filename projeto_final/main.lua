--local mqtt = require("mqtt_library")

local linha = 0
local coluna = 0
local matriz = {}
local jogador = 1
local numLinhas = 8
local numColunas = 8
local tamanhoCasa = 64
-- Peça branca - 1
-- Peça preta - 0
-- Desocupado - -1

function controller(msg)
  
end

function mqttcb(t,m)
  if(t == "paraloveA14") then
  end
  print("MENSAGEM RECEBIDA: "..m)
  controller(m)
  
    
end

function love.load()
    love.window.setMode(numColunas * tamanhoCasa, numLinhas * tamanhoCasa)
    tabuleiro = {}
    for linha = 1, numLinhas do
        tabuleiro[linha] = {}
        for coluna = 1, numColunas do
            if (linha + coluna) % 2 == 0 then
                if linha <= 3 then
                    tabuleiro[linha][coluna] = 1
                elseif linha >= numLinhas - 2 then
                    tabuleiro[linha][coluna] = 0
                else
                    tabuleiro[linha][coluna] = -1
                end
            else
                tabuleiro[linha][coluna] = -1
            end
        end
    end
end

function love.draw()
    for linha = 1, numLinhas do
        for coluna = 1, numColunas do
            local x, y = (coluna - 1) * tamanhoCasa, (linha - 1) * tamanhoCasa

            love.graphics.setColor(love.math.colorFromBytes(255, 199, 143))
            if (linha + coluna) % 2 == 0 then
                love.graphics.rectangle("fill", x, y, tamanhoCasa, tamanhoCasa)
            else
                love.graphics.setColor(love.math.colorFromBytes(176, 146, 106))
                love.graphics.rectangle("fill", x, y, tamanhoCasa, tamanhoCasa)
            end

            if tabuleiro[linha][coluna] == 1 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.circle("fill", x + tamanhoCasa / 2, y + tamanhoCasa / 2, tamanhoCasa / 2 - 5)
            elseif tabuleiro[linha][coluna] == 0 then
                love.graphics.setColor(0, 0, 0)
                love.graphics.circle("fill", x + tamanhoCasa / 2, y + tamanhoCasa / 2, tamanhoCasa / 2 - 5)
            end
        end
    end
end

--function love.update(dt)
--  mqtt_client:handler()
--end