local sw1 = 3
local sw2 = 4
local sw3 = 5
local sw4 = 8
gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)
gpio.mode(sw3,gpio.INT,gpio.PULLUP)
gpio.mode(sw4,gpio.INT,gpio.PULLUP)

local meuid = "A18"
local m = mqtt.Client("clientid " .. meuid, 120)

function publicaA18(c,chave,meuid)
  c:publish("paraloveA18","A18 "..chave,0,0, 
            function(client) print("mandou! "..chave) end)
end

function publicaA20(c,chave,meuid)
  c:publish("paraloveA20","A18 "..chave,0,0, 
            function(client) print("mandou! "..chave) end)
end

function novaInscricao (c)
  local msgsrec = 0
  function novamsg (c, t, m)
    print("mensagem ".. msgsrec .. ", topico: ".. t .. ", dados: " .. m)
    msgsrec = msgsrec + 1
  end
  c:on("message", novamsg)

end

function conectado (client)
    function nodeBotao1(level,timestamp)
    gpio.trig(sw1)
    publicaA18(client,1)
    publicaA20(client,1)
    tmr.create():alarm(200, tmr.ALARM_SINGLE,
            function(t)
                gpio.trig(sw1, "down", nodeBotao1)
            end)
    end
    gpio.trig(sw1, "down", nodeBotao1)
    
    function nodeBotao2(level,timestamp)
    gpio.trig(sw2)
    publicaA18(client,2)
    publicaA20(client,2)
    tmr.create():alarm(200, tmr.ALARM_SINGLE,
            function(t)
                gpio.trig(sw2, "down", nodeBotao2)
            end)
    end
    gpio.trig(sw2, "down", nodeBotao2)
    
    function nodeBotao3(level,timestamp)
    gpio.trig(sw3)
    publicaA18(client,3)
    publicaA20(client,3)
    tmr.create():alarm(200, tmr.ALARM_SINGLE,
            function(t)
                gpio.trig(sw3, "down", nodeBotao3)
            end)
    end
    gpio.trig(sw3, "down", nodeBotao3)
    
    function nodeBotao4(level,timestamp)
    gpio.trig(sw4)
    publicaA18(client,4)
    publicaA20(client,4)
    tmr.create():alarm(200, tmr.ALARM_SINGLE,
            function(t)
                gpio.trig(sw4, "down", nodeBotao4)
            end)
    end
    gpio.trig(sw4, "down", nodeBotao4)

end

m:connect("139.82.100.100", 7981, false, 
          conectado,
          function(client, reason) print("failed reason: "..reason) end)
