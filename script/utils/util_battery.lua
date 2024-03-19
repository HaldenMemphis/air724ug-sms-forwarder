module(..., package.seeall)

function getBatteryVolval()
    local id = 5
    local adcval, voltval = adc.read(id)
    if adcval ~= 0xffff then
        log.info("ADC的原始测量数据和电压值:", adcval, voltval)
        return voltval
    end
    return -99
end


function checkBatteryPower( )
    local volt = getBatteryVolval()
    log.info("util_battery.checkTemperature","【电量检查】",volt)
    if (config.POWER_LIMIT >= volt and volt ~= -99) then
        return true
    end
    return false
end

sys.timerLoopStart(function() 
    if checkBatteryPower() then
        local msg = "【Low BatteryPower】: "
        util_notify.add(msg .. getBatteryVolval() .. "mv")
    end
end,config.POWER_CHECK_INTERVAL)

