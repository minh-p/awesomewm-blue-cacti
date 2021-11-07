local wibox = require("wibox")
local gears = require("gears")

local Calendar = {}
local styles = {}
local function rounded_shape(size, partial)
    if partial then
        return function(cr, width, height)
                   gears.shape.partially_rounded_rect(cr, width, height,
                        false, true, false, true, 5)
               end
    else
        return function(cr, width, height)
                   gears.shape.rounded_rect(cr, width, height, size)
               end
    end
end
styles.month   = { padding      = 5,
                   border_width = 0,
                   shape        = rounded_shape(10)
}
styles.normal  = { shape    = rounded_shape(5) }
styles.focus   = { fg_color = '#000000',
                   bg_color = '#ffffff',
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = rounded_shape(5, true)
}
styles.header  = {
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = rounded_shape(10)
}
styles.weekday = { fg_color = '#7788af',
                   markup   = function(t) return '<b>' .. t .. '</b>' end,
                   shape    = rounded_shape(5)
}
local function decorate_cell(widget, flag, date)
    if flag=='monthheader' and not styles.monthheader then
        flag = 'header'
    end
    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end
    -- Change bg color for weekends
    local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
    local weekday = tonumber(os.date('%w', os.time(d)))
    local default_bg = (weekday==0 or weekday==6) and '#012355' or '#012355'
    local ret = wibox.widget {
        {
            widget,
            margins = (props.padding or 2) + (props.border_width or 0),
            widget  = wibox.container.margin
        },
        shape              = props.shape,
        shape_border_color = props.border_color or '#b9214f',
        shape_border_width = props.border_width or 0,
        fg                 = props.fg_color or '#ffffff',
        bg                 = props.bg_color or default_bg,
        widget             = wibox.container.background
    }
    return ret
end
function Calendar.create()
    local calendarWidget = wibox.widget {
        fn_embed = decorate_cell,
        widget   = wibox.widget.calendar.month
    }

    return calendarWidget
end

return Calendar
