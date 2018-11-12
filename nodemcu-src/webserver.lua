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
        buf = buf.."<a href=\"?pin=ON\"><button style='height:200px;width:200px'>Click!</button></a>&nbsp;&nbsp;&nbsp;";
        buf = buf.."<a href=\"?PWrst=ON\"><button style='height:200px;width:200px'>Password Reset!</button></a>&nbsp;&nbsp;&nbsp;";
        buf = buf.."<a href=\"?Regrst=ON\"><button style='height:200px;width:200px'>Registry Reset!</button></a></body></html>";
        local _on,_off = "",""
        if(_GET.pin == "ON")then
            pwm.setduty(led2, 280)
            tmr.delay(500000)
            pwm.setduty(led2, 480)
            tmr.delay(500000)
            pwm.stop(led2)
        end
        if(_GET.PWrst == "ON")then
            file.open("credentials.lua", "w")
                file.open("credentials.lua", "w")
                file.write("SSID = nil")
                file.write("\n")
                file.write("PASSWORD = nil")
                file.write("\n")
                file.close()
                dofile("init.lua")
        end
        if(_GET.Regrst == "ON")then

        end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
