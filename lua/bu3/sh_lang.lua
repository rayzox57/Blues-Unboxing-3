

BU3.Lang = {}
BU3.Lang.Current = 'en'
BU3.Lang.Pack = {}

BU3.Lang.Get = function(s,...)
    s = BU3.Lang.Pack[s] or string.format('Unknown %s String in Lang %s',s,BU3.Lang.Current)
    return string.format(s,...)
end