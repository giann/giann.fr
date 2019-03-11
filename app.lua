local lapis = require("lapis")

local app = lapis.Application()
app:enable("etlua")
app.layout = require "views.layout"
app.views_prefix = "views"
app.flows_prefix = "flows"

app:get("/", function(self)
    return { render = "index" } -- what is this string documented as?
end)

return app
