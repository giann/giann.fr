local lapis = require("lapis")

local app = lapis.Application()
app:enable("etlua")
app.layout = require "giann_fr.views.layout"
app.views_prefix = "giann_fr.views"
app.flows_prefix = "giann_fr.flows"

app:get("/", function(self)
    return { render = "index" } -- what is this string documented as?
end)

return app
