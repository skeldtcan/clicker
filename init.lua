dofile("credentials.lua")

print(SSID)
if SSID == nil then
    print("WIFI Mode")
    dofile("ap.lua")
elseif PASSWORD == nil then
    print("WIFI Mode")
    dofile("ap.lua")
else 
    print("STATION Mode")
    function startup()
        if file.open("init.lua") == nil then
            print("init.lua deleted or renamed")
        else
            print("Running")
            file.close("init.lua")
            dofile("webserver.lua")
        end
    end
    print("Connecting to WiFi access point...")
    wifi.setmode(wifi.STATION)
    wifi.sta.config(SSID, PASSWORD)
    wifi.sta.connect()
    local count = 0
    tmr.alarm(1, 1000, 1, function()
        if wifi.sta.getip() == nil then
            print("Waiting for IP address...")
            count = count + 1
            print(count)
            if count > 9 then
                file.open("credentials.lua", "w")
                file.write("SSID = nil")
                file.write("\n")
                file.write("PASSWORD = nil")
                file.write("\n")
                file.close()
                dofile("init.lua")
            end
        else
            tmr.stop(1)
            print("WiFi connection established, IP address: " .. wifi.sta.getip())
            print("You have 3 seconds to abort")
            print("Waiting...")
            tmr.alarm(0, 3000, 0, startup)
        end
    end)
    print("hello-----why it operate?")
end
