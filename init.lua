-- wifi login
username = <username>
password = <password>

-- adafruit IO data
AIO_key = <AIO_key>
AIO_username = <AIO_username>
AIO_feedname = <feedname>

wifi.setmode(wifi.STATION)
wifi.sta.config(username,password)


function HexadecimalToColor(x)
    if type(x) == 'number' then
        x = string.format('%x+', x):upper()
    end
        x = x:match'%x+':upper()
    if x:len() ~= 6 then
        return error('Invalid hexadecimal color code: ' .. x)
    end
    return {
        r = loadstring('return 0x'..x:sub(1,2))();
        g = loadstring('return 0x'..x:sub(3,4))();
        b = loadstring('return 0x'..x:sub(5,6))();
    }
end

m = mqtt.Client(AIO_key, 120, AIO_username, AIO_key)
m:on("message", function(conn, topic, data)
    if data ~= nil then
        local color = HexadecimalToColor(string.gsub(data, "#", "", 1))
        ws2812.writergb(4, string.char(color.r, color.g, color.b):rep(3))
    end
end)
m:connect("io.adafruit.com", 1883, 0, function(conn) m:subscribe(AIO_username .. "/feeds/" .. AIO_feedname, 0, function(conn) print("subscribe success") end) end)
