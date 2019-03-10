local builtins = require "fourmi.builtins"
local colors   = require "term.colors"
local plan     = require "fourmi.plan"
local task     = require "fourmi.task"
local sh       = builtins.sh
local sht      = builtins.task.sh
local outdated = builtins.task.outdated

local startLapisTask = task "lapis-start"
    :description "Start lapis server"
    :perform(function(self, env)
        local ok, err = sh("lapis", "server", env or "development")
        if ok then
            print(colors.yellow "Lapis started listening on localhost:8080")
        else
            error(err)
        end
    end)

local stopLapisTask = sht("lapis", "term")
    :name "lapis-term"
    :property("successMessage", "Lapis stopped")
    :property("failureMessage", "Lapis instance not running")
    :property("ignoreError", true)

local downloadFengari = task "fengari"
    :description "Get fengari"
    :perform(function(self)
        return sh(
            "curl",
            "-L", "https://github.com/fengari-lua/fengari-web/releases/download/v0.1.4/fengari-web.js",
            "-o", "static/js/fengari-web.js")
            and "static/js/fengari-web.js"
    end)

return {
    plan "serve"
        :description "Start server"
        :task(
            stopLapisTask .. startLapisTask
        ),

    plan "stop"
        :description "Stop server"
        :task(
            stopLapisTask
        ),

    plan "fengari"
        :description "Get fengari"
        :task(
            downloadFengari
        ),

    plan "all"
        :description "Build giann.fr"
        :task(
            (outdated "static/js/fengari-web.js" & downloadFengari)
                .. stopLapisTask .. startLapisTask
        )
}
