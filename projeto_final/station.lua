-- wifi id e senha
wificonf = {
  ssid = "",
  pwd = "",
  save = false,
  got_ip_cb = function (con)
                print (con.IP)
              end
}
wifi.setmode(wifi.STATION)
wifi.sta.config(wificonf)
