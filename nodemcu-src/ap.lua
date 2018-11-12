wifi.setmode(wifi.STATION)
wifi.sta.disconnect() -- this is supposed to fix the iPhone issue
print("Start soft AP as mizefi with pw=12345678 and ip=192.168.0.1")
wifi.setmode(wifi.SOFTAP) 
wifi.setphymode(wifi.PHYMODE_G)
local cfg={
    ssid="Clicker2",
    pwd="12345678"
}
wifi.ap.config(cfg)
cfg={}
cfg ={
    ip="192.168.0.1",
    netmask="255.255.255.0",
    gateway="192.168.0.1",
}
wifi.ap.setip(cfg)
led2 = 4
pwm.setup(led2, 200, 1000)
pwm.setduty(led2, 480)
tmr.delay(500000)
pwm.stop(led2)
srv =net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        buf = buf.."HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<html><head>";
        buf = buf.."<meta name='viewport' content='width=device-width, user-scalable=no'></head><body>";
        buf = buf.."<h1>Clicker Controller</h1>";

        buf = buf.."<p> <form action= method=\"post\">";
        buf = buf.."<INPUT TYPE=\"text\" name=\"userid\" placeholder=\"SSID\">";
        buf = buf.."<input type=\"password\" name=\"userpw\" placeholder=\"PASSWORD\">";
        buf = buf.."<input type=\"submit\" value=\"Submit\"></form>"; 
        buf = buf.."<p> <a href=\"?rst=true\"><button style='height:200px;width:200px'>Reset!</button></a></p>";         
        print(_GET.userid, _GET.userpw)
        if _GET.rst == "true" then
            node.restart()
        end            
        if _GET.userpw == nil then
        else
            if string.len(_GET.userpw) >= 8 then
                file.open("credentials.lua", "w")
                file.write("SSID = \"")
                file.write(_GET.userid)
                file.write("\"\n")
                file.write("PASSWORD = \"")
                file.write(_GET.userpw)
                file.write("\"\n")
                file.close()
            else
                print("The password must be at least eight characters long")
                buf = buf.."<script language=\"javascript\"> alert(\"The password must be at least eight characters long\"); </script></body></html>"; 
            end
        end            
        print(_GET.userid, _GET.userpw)   
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
