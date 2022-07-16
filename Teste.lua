setDefaultTab("Teste")
macro(250, "Dancinha", "Ctrl+D", function()
    turn(math.random(0, 3)) -- turn to a random direction.
 end)

macro(100, "PRISON50%", function()   
                        if g_game.isAttacking() and g_game.getAttackingCreature():isPlayer() and g_game.getAttackingCreature():getHealthPercent() < 50 
            then
                        say("Suiton:Prision ")
            end
            end)
