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

        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
