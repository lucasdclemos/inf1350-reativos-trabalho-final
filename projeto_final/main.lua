local mqtt = require("mqtt_library")
local estado = 0 -- 0 = Escolha da peça / 1 = Escolha da Jogada
local jogador = 1 -- 1 (branco) - 0 (preto)
local pretas = 12
local brancas = 12
local numLinhas = 8
local numColunas = 8
local linha = 1
local coluna = 1
local tamanhoCasa = 64
local x_escolhendo_peca = 1
local y_escolhendo_peca = 1
local x_escolhendo_jogada = 1
local y_escolhendo_jogada = 1
local tabuleiro = {}
local total_players = 0
local jogador_branco = "A18"
local jogado_preto = "A18"

function muda_coluna()
  if estado == 0 then
    if x_escolhendo_peca == 8 then
      x_escolhendo_peca = 1
    else 
      x_escolhendo_peca = x_escolhendo_peca + 1
    end
  elseif estado == 1 then
    if x_escolhendo_jogada == 8 then
      x_escolhendo_jogada = 1
    else 
      x_escolhendo_jogada = x_escolhendo_jogada + 1
    end
  end
end

function muda_linha()
  if estado == 0 then
    if y_escolhendo_peca == 8 then
      y_escolhendo_peca = 1
    else 
      y_escolhendo_peca = y_escolhendo_peca + 1
    end
  elseif estado == 1 then
    if y_escolhendo_jogada == 8 then
      y_escolhendo_jogada = 1
    else 
      y_escolhendo_jogada = y_escolhendo_jogada + 1
    end
  end
end

function confirma_peca()
  if jogador == tabuleiro[x_escolhendo_peca][y_escolhendo_peca] or tabuleiro[x_escolhendo_peca][y_escolhendo_peca] - 2 == jogador then
    estado = 1
  end
end

function controller(msg)
  if msg == "1" then
    muda_coluna()
  elseif msg == "2" then
    muda_linha()
  elseif msg == "3" then
    if estado == 0 then
      confirma_peca()
    elseif estado == 1 then
      if tabuleiro[x_escolhendo_peca][y_escolhendo_peca] == 0 or tabuleiro[x_escolhendo_peca][y_escolhendo_peca] == 1 then
        confirma_jogada_peca_comum()
      elseif tabuleiro[x_escolhendo_peca][y_escolhendo_peca] == 2 or tabuleiro[x_escolhendo_peca][y_escolhendo_peca] == 3 then
        confirma_jogada_dama()
      end
    end
--  elseif msg == "4" then
--    if total_players == 0 then
--      m = 1
--      mqtt_client:publish("paranodeA20", m)
--      total_players = total_players + 1
--    elseif total_players == 1 then
--      m = 0
--      mqtt_client:publish("paranodeA20", m)
--      total_players = total_players + 1
--    end
--  end
  end
end

function confirma_jogada_dama()
  if math.abs(x_escolhendo_peca - x_escolhendo_jogada) == math.abs(y_escolhendo_peca - y_escolhendo_jogada) then
    if (x_escolhendo_jogada == x_escolhendo_jogada) and (y_escolhendo_jogada == y_escolhendo_peca) then
      print("ta parado porra")
    else
      move_dama()
      muda_jogador()
      estado = 0
    end
  end
end

function move_dama()
  if jogador == 0 then
    outro_jogador = 1
  else
    outro_jogador = 0
  end
  tabuleiro[x_escolhendo_jogada][y_escolhendo_jogada] = jogador + 2
  tabuleiro[x_escolhendo_peca][y_escolhendo_peca] = -1
  dif_x = x_escolhendo_jogada - x_escolhendo_peca
  dif_y = y_escolhendo_jogada - y_escolhendo_peca
  aux_x = dif_x + x_escolhendo_jogada
  aux_y = dif_y + y_escolhendo_jogada
  print(aux_x, aux_y)
  while (aux_x ~= x_escolhendo_peca) and (aux_y ~= y_escolhendo_peca) do
    if tabuleiro[aux_x][aux_y] == outro_jogador or tabuleiro == outro_jogador + 2 then
      tabuleiro[aux_x][aux_y] = -1
      if outro_jogador == 1 then
        brancas = brancas - 1
      else
        pretas = pretas - 1
      end
    end
    aux_x = aux_x - 1
    aux_y = aux_y - 1
  end
end

function move_dama()
  if jogador == 0 then
    outro_jogador = 1
  else
    outro_jogador = 0
  end
  dif_x = x_escolhendo_jogada - x_escolhendo_peca
  dif_y = y_escolhendo_jogada - y_escolhendo_peca
  while dif_x ~= 0 do
    if tabuleiro[x_escolhendo_peca + dif_x][y_escolhendo_peca + dif_y] == outro_jogador or tabuleiro[x_escolhendo_peca + dif_x][y_escolhendo_peca + dif_y] == outro_jogador + 2 then
      tabuleiro[x_escolhendo_peca + dif_x][y_escolhendo_peca + dif_y] = -1
      if outro_jogador == 0 then
        pretas = pretas - 1
      else
        brancas = brancas - 1
      end
    end
  
    if dif_x > 0 then
      dif_x = dif_x - 1
    else 
      dif_x = dif_x + 1
    end
    if dif_y > 0 then
      dif_y = dif_y - 1
    else 
      dif_y = dif_y + 1
    end
  end
  tabuleiro[x_escolhendo_jogada][y_escolhendo_jogada] = jogador + 2
  tabuleiro[x_escolhendo_peca][y_escolhendo_peca] = -1
end

function confirma_jogada_peca_comum()
  print(x_escolhendo_peca, x_escolhendo_jogada)
  if jogador == 0 then
    if ((x_escolhendo_peca - x_escolhendo_jogada) == 1) and (math.abs(y_escolhendo_peca - y_escolhendo_jogada) == 1) then
      verifica_jogada_peca_comum()
    end
  elseif jogador == 1 then
    if ((x_escolhendo_jogada - x_escolhendo_peca) == 1) and (math.abs(y_escolhendo_peca - y_escolhendo_jogada) == 1) then
      verifica_jogada_peca_comum()
    end
  end  
end

function verifica_jogada_peca_comum()
  if tabuleiro[x_escolhendo_jogada][y_escolhendo_jogada] ~= jogador and tabuleiro[x_escolhendo_jogada][y_escolhendo_jogada] >= 0 then
    print("come")
    come_peca_comum()
  elseif tabuleiro[x_escolhendo_jogada][y_escolhendo_jogada] == -1 then
    move_peca_comum()    
  end
  estado = 0
  muda_jogador()
end
  
function come_peca_comum()
  if jogador == 0 then
    outro_jogador = 1
  else
    outro_jogador = 0
  end
  dif_x = x_escolhendo_jogada - x_escolhendo_peca
  dif_y = y_escolhendo_jogada - y_escolhendo_peca
  if x_escolhendo_jogada + dif_x <= 8 and x_escolhendo_jogada + dif_x >= 1 and y_escolhendo_jogada + dif_y <= 8 and y_escolhendo_jogada + dif_y >= 1 then
    if tabuleiro[x_escolhendo_jogada + dif_x][y_escolhendo_jogada + dif_y] == -1 then
      tabuleiro[x_escolhendo_jogada + dif_x][y_escolhendo_jogada + dif_y] = jogador
      tabuleiro[x_escolhendo_jogada][y_escolhendo_jogada] = -1
      tabuleiro[x_escolhendo_peca][y_escolhendo_peca] = -1
    end
    x_escolhendo_jogada = x_escolhendo_jogada + dif_x
    y_escolhendo_jogada = y_escolhendo_jogada + dif_y
    if x_escolhendo_jogada + dif_x <= 8 and x_escolhendo_jogada + dif_x >= 1 and y_escolhendo_jogada + dif_y <= 8 and y_escolhendo_jogada + dif_y >= 1 then
      if tabuleiro[x_escolhendo_jogada + dif_x][y_escolhendo_jogada + dif_y] == outro_jogador then 
        x_escolhendo_peca = x_escolhendo_jogada
        y_escolhendo_peca = y_escolhendo_jogada
        x_escolhendo_jogada = x_escolhendo_jogada + dif_x
        y_escolhendo_jogada = y_escolhendo_jogada + dif_y
        come_peca_comum()
      elseif tabuleiro[x_escolhendo_jogada + dif_x][y_escolhendo_jogada - dif_y] == outro_jogador then
        x_escolhendo_peca = x_escolhendo_jogada
        y_escolhendo_peca = y_escolhendo_jogada
        x_escolhendo_jogada = x_escolhendo_jogada + dif_x
        y_escolhendo_jogada = y_escolhendo_jogada - dif_y
        come_peca_comum()
      end
    end
    if jogador == 1 then
      pretas = pretas - 1
      if x_escolhendo_jogada == 8 then
        print(x_escolhendo_jogada, y_escolhendo_jogada)
        vira_dama()
      end
    elseif jogador == 0 then
      brancas = brancas - 1
      if x_escolhendo_jogada == 1 then
        vira_dama()
      end
    end
  end
end
  
function muda_jogador()
  if brancas == 0 or pretas == 0 then
    love.event.quit()
  end
  if jogador == 1 then
    jogador = 0
    x_escolhendo_peca = 8
    y_escolhendo_peca = 1
    x_escolhendo_jogada = 8
    y_escolhendo_jogada = 1
  else
    jogador = 1
    x_escolhendo_peca = 1
    y_escolhendo_peca = 1
    x_escolhendo_jogada = 1
    y_escolhendo_jogada = 1
  end
end

function move_peca_comum()
  tabuleiro[x_escolhendo_jogada][y_escolhendo_jogada] = jogador
  tabuleiro[x_escolhendo_peca][y_escolhendo_peca] = -1
  x_escolhendo_peca = x_escolhendo_jogada
  y_escolhendo_peca = y_escolhendo_jogada
  if (jogador == 0 and x_escolhendo_jogada == 1) or (jogador == 1 and x_escolhendo_jogada == 8) then
    vira_dama()
  end
end


function vira_dama()
  if tabuleiro[x_escolhendo_jogada][y_escolhendo_jogada] <= 1 then
    tabuleiro[x_escolhendo_jogada][y_escolhendo_jogada] = tabuleiro[x_escolhendo_jogada][y_escolhendo_jogada] + 2
  end
end

function mqttcb(t,m)
  local codigo, numero = m:match("(%a%d+) (%d+)")
  print(codigo, numero)
  if numero == "4" then
    mqtt_client:publish("paranodeA20", "recebi " .. m)
    if total_players == 0 then
      jogador_branco = codigo
      total_players = total_players + 1
    elseif total_players == 1 then
      jogado_preto = codigo
      total_players = total_players + 1
    end
  elseif (jogador == 0 and codigo == jogado_preto) or (jogador == 1 and codigo == jogador_branco) then
        controller(numero)
  end
end

function love.load()
  mouseX = 0
  mouseY = 0
  love.window.setMode(numColunas * tamanhoCasa, numLinhas * tamanhoCasa)  
  for linha = 1, numLinhas, 1 do
    tabuleiro[linha] = {}
    for coluna = 1, numColunas, 1 do
      if (linha + coluna) % 2 == 0 then
        if linha <= 3 then
          tabuleiro[linha][coluna] = 1 -- 1
        elseif linha >= numLinhas - 2 then
          tabuleiro[linha][coluna] = 0 -- 0
        else
          tabuleiro[linha][coluna] = -1
        end
      else
        tabuleiro[linha][coluna] = -1
      end
    end
  end
  mqtt_client = mqtt.client.create("139.82.100.100", 7981, mqttcb)
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
      
      if tabuleiro[linha][coluna] == 2 then -- dama preta
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("fill", x + tamanhoCasa / 2, y + tamanhoCasa / 2, tamanhoCasa / 2 - 5)
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("line", x + tamanhoCasa / 2, y + tamanhoCasa / 2, tamanhoCasa / 2 - 5)
      end
      
      if tabuleiro[linha][coluna] == 3 then -- dama branca
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", x + tamanhoCasa / 2, y + tamanhoCasa / 2, tamanhoCasa / 2 - 5)
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("line", x + tamanhoCasa / 2, y + tamanhoCasa / 2, tamanhoCasa / 2 - 5)
      end
      
    end
  end
    
  if jogador == 1 then
    love.graphics.setColor(1, 1, 1)
  elseif jogador == 0 then
    love.graphics.setColor(0, 0, 0)
  end
  love.graphics.rectangle("line", (y_escolhendo_peca - 1)*tamanhoCasa, (x_escolhendo_peca - 1)*tamanhoCasa, tamanhoCasa, tamanhoCasa)
  
  if estado == 1 then
    if jogador == 1 then
      love.graphics.setColor(1, 1, 1)
    elseif jogador == 0 then
      love.graphics.setColor(0, 0, 0)
    end
    love.graphics.rectangle("line", (y_escolhendo_jogada - 1)*tamanhoCasa, (x_escolhendo_jogada - 1)*tamanhoCasa, tamanhoCasa, tamanhoCasa)
  end

end

function love.update(dt)
  mqtt_client:handler()
end