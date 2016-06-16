local default_gui = data.raw["gui-style"].default

local function button_graphics(xpos, ypos)
    return {
        type = "monolith",

        top_monolith_border = 0,
        right_monolith_border = 0,
        bottom_monolith_border = 0,
        left_monolith_border = 0,

        monolith_image = {
            filename = "__CredoTimeLapseMod__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 16,
            height = 16,
            x = xpos,
            y = ypos,
        },
    }
end


default_gui.CTLM_button_with_icon = {
    type = "button_style",
    parent = "slot_button_style",

    scalable = true,

    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,

    width = 17,
    height = 17,

    default_graphical_set = button_graphics( 0,  0),
    hovered_graphical_set = button_graphics(16,  0),
    clicked_graphical_set = button_graphics(32,  0),
}



default_gui.CTLM_settings = {
    type = "button_style",
    parent = "CTLM_button_with_icon",

    default_graphical_set = button_graphics( 0, 16),
    hovered_graphical_set = button_graphics(16, 16),
    clicked_graphical_set = button_graphics(32, 16),
}
