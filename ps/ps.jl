ENV["JULIA_CONDAPKG_BACKEND"] = "Null"
using PythonCall
const duck = pyimport("duckduckgo_search").DDGS

function search_console(name::String,base_url::String)::Dict
    sleep(1)
    return pyconvert(Dict,duck().text(name*" "*base_url,max_results=1)[0])
end

const playstation::String = "https:/store.playstation.com/en-us/product/"
const xbox::String ="https://www.xbox.com/en-US/games/store/"
const switch::String = "https://www.nintendo.com/us/store/products/"
const epic::String = "https://store.epicgames.com/en-US/"

function get_playstation(game::String)::String
    data = search_console(game, playstation)
    cond1 = occursin("product",data["href"]) || occursin("concept",data["href"])
    cond2 = occursin(lowercase(game)*" -",lowercase(data["title"])) || occursin(lowercase(game)*" |",lowercase(data["title"]))
    if cond1 && cond2 
        return data["href"]
    else 
        return ""
    end
end

function get_xbox(game::String)::String
    data = search_console(game, xbox)
    cond1 = occursin(lowercase(split(game)[1]),data["href"]) ||  occursin("/games/",data["href"])
    cond2 = occursin(lowercase("Buy "*game*" |"),lowercase(data["title"])) || occursin(lowercase(game*" |"),lowercase(data["title"])) 
    if cond1 && cond2 
        return data["href"]
    else 
        return ""
    end
end

function get_switch(game::String)::String
    data = search_console(game, switch)
    cond1 = occursin("products",data["href"]) || occursin(lowercase(split(game)[1]),data["href"])
    cond2 = occursin(lowercase(game*" - Nintendo"),lowercase(data["title"])) || occursin(lowercase(game*" For Nintendo Switch -"),lowercase(data["title"]))
    if cond1 && cond2 
        return data["href"]
    else 
        return ""
    end
end

function get_epic(game::String)::String
    data = search_console(game, epic)
    cond1 = occursin("/p/",data["href"]) || occursin(lowercase(split(game)[1]),data["href"])
    cond2 = occursin(lowercase(game*" |"),lowercase(data["title"])) 
    if cond1 && cond2 
        return data["href"]
    else 
        return ""
    end
end