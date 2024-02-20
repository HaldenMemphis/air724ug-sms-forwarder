module(..., package.seeall)

local temperature = "-99"

-- 模块温度返回回调函数
-- @temperature: srting类型，如果要对该值进行运算，可以使用带float的固件将该值转为number
local function getTemperatureCb(_temperature)
    if _temperature ~= nil then
        temperature = _temperature:gsub("%s+", "")
    end
end

-- function getOriginalTemperature()
--     -- 获取模块温度
--     misc.getTemperature(getTemperatureCb)
--     return temperature
-- end    

function get()
    -- 获取模块温度
    misc.getTemperature(getTemperatureCb)
    return temperature
end

function checkTemperature( )
    log.info("util_temperature.checkTemperature","【温度检查】",tonumber(get()))
    if (config.TEMP_LIMIT <= tonumber(get())) then
        return true
    end
    return false
end

sys.timerLoopStart(function() 
    if checkTemperature() then
        local msg = "【High Temperature】: "
        util_notify.add(msg .. get())
    end
end,config.TEMP_CHECK_INTERVAL)


get()
