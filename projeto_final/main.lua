local mqtt = require("mqtt_library")
local estado = 0 -- 0 = Escolha da peça / 1 = Escolha da Jogada
local jogador = 1 -- 1 (branco) - 0 (preto)
local numLinhas = 8
local numColunas = 8
local linha = 0
local coluna = 0
local tamanhoCasa = 64
local destaque_x
local destaque_y
local destacado = 0
local x = 0
local y = 0
local escolhendo_peca = 0
-- Peça branca - 1
-- Peça preta - 0
-- Desocupado - -1
local tabuleiro = {}


function muda_linha()
  if linha < 7 then
    linha = linha + 1
  else
    linha = 0
  end
end

function muda_coluna()
  if coluna < 7 then
    coluna = coluna + 1
  else
    coluna = 0
  end
end

function confirma_peca()
  print("OI")
  if jogador == tabuleiro[linha][coluna] then
    estado = 1
    print("Mudou ESTADO")
  end
end

function controller(msg)
  if msg == "1" then
    --verifica_tabuleiro(destaque_x - 1, destaque_y - 1)
      if estado == 0 then
        print(linha)
        muda_linha()
      end
  elseif msg == "2" then
      if estado == 0 then
        muda_coluna()
      end
    --verifica_tabuleiro(destaque_x - 1, destaque_y + 1)
  elseif msg == "3" then
    if estado == 0 then
      confirma_peca()
    --verifica_tabuleiro(destaque_x + 1, destaque_y - 1)
    end
  else
    --verifica_tabuleiro(destaque_x + 1, destaque_y + 1)
  end
end

--function posicao_confirmada() then
  


function mqttcb(t,m)
  if(t == "paraloveA20") then
  end
  print("MENSAGEM RECEBIDA: "..m)
  controller(m)
end

function verifica_clique(x, y)
  destaque_x = math.floor(x / tamanhoCasa) + 1
  destaque_y = math.floor(y / tamanhoCasa) + 1
  print(destaque_x, destaque_y)
  if tabuleiro[destaque_x][destaque_y] == jogador then
    destacado = 1
  end
  
end

function love.mousepressed(x, y, button, istouch, presses)
  verifica_clique(x, y)
end

function love.load()
    mouseX = 0
    mouseY = 0
    love.window.setMode(numColunas * tamanhoCasa, numLinhas * tamanhoCasa)
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
    mqtt_client = mqtt.client.create("139.82.100.100", 7981, mqttcb)
  -- Trocar XX pelo ID da etiqueta do seu NodeMCU
    mqtt_client:connect("cliente love A20")
    mqtt_client:subscribe({"paraloveA20"})
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
    
    if escolhendo_peca == 0 then
      if jogador == 1 then
        love.graphics.setColor(1, 1, 1)
      elseif jogador == 0 then
        love.graphics.setColor(0, 0, 0)
      end
      love.graphics.rectangle("line", (x - 1)*tamanhoCasa, (y - 1)*tamanhoCasa, tamanhoCasa, tamanhoCasa)
    end
    
    if destacado == 1 then
      if jogador == 1 then
        love.graphics.setColor(1, 1, 1)
      elseif jogador == 0 then
        love.graphics.setColor(0, 0, 0)
      end
      love.graphics.rectangle("line", (destaque_x - 1)*tamanhoCasa, (destaque_y - 1)*tamanhoCasa, tamanhoCasa, tamanhoCasa)
    end
    
    if escolhendo == 1 then
      if jogador == 1 then
        love.graphics.setColor(1, 1, 1)
      elseif jogador == 0 then
        love.graphics.setColor(0, 0, 0)
      end
      love.graphics.rectangle("line", (destaque_x - 1)*tamanhoCasa, (destaque_y - 1)*tamanhoCasa, tamanhoCasa, tamanhoCasa)
    end
end

function love.update(dt)
  mqtt_client:handler()
end