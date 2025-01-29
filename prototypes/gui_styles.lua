-- Add custom GUI styles for the clock GUI
local gui_styles = data.raw["gui-style"]["default"]

-- Custom style for the clock frame
gui_styles["itsabouttime-clock-frame"] = {
    type = "frame_style",
    parent = "frame",
    padding = 4,
    horizontal_flow_style = {
        type = "horizontal_flow_style",
        horizontal_spacing = 4,
        vertical_align = "center",
    },
}

-- Custom style for the time label
gui_styles["itsabouttime-time-label"] = {
    type = "label_style",
    parent = "label",
    font = "itsabouttime-time-font",
    left_padding = 4,
    right_padding = 4,
}
