function love.conf(t)
    t.window = t.window or t.screen

    -- Set window/screen flags here.
    t.window.width = 960
    t.window.height = 600

    t.screen = t.screen or t.window
end