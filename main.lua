-- states: 
-- 1 = menu 
-- 2 = game 
-- 3 Game Over 
-- 4 Highscore Board 
-- 5 help 
-- 6 settings 
-- For design Settings, main menu, help and highscore board  
-- esc = Exit Game

Frank = {} 
Ethan = {}
GameOver = {}
--Highscore = {}
hsBoard = {}

screenWidth, screenHeight = love.window.getDimensions()
require("Tserial")

function reset_game()
	MusicToggle = true 
	StartGameButton = { x = 290, y = 200, GameImage = love.graphics.newImage("Button.png"), clicked = false}
	HighScoreButton = { x = 290, y = 260, ScoreImage = love.graphics.newImage("Button.png"), clicked = false}
	SettingsButton = { x = 290, y = 320, SettingsImage = love.graphics.newImage("Button.png"), clicked = false}
	HelpButton = { x = 770, y = 580, HelpImage = love.graphics.newImage("Help.png"), clicked = false}
	StartGameWidth, StartGameHeight = StartGameButton.GameImage:getDimensions()
	HighScoreWidth, HighScoreHeight = HighScoreButton.ScoreImage:getDimensions()
	SettingsWidth, SettingsHeight = SettingsButton.SettingsImage:getDimensions()
	HelpWidth, HelpHeight = HelpButton.HelpImage:getDimensions()
	buttonFont = love.graphics.newFont(35)
	titlefont = love.graphics.newFont("Awesome.ttf", 70)
	love.graphics.setFont(titlefont)
	statefont = love.graphics.newFont("Awesome.ttf", 15)
	love.graphics.setFont(statefont)
	helpfont = love.graphics.newFont("Awesome.ttf", 20)
	love.graphics.setFont(helpfont)
	Score = 0
	GameStarted = false
	GameoverIdle = love.graphics.newImage("GameOver.jpg")
	GameOver.image=GameoverIdle
	GameOver.GameoverX = -245
	GameOver.GameoverX_velocity	= 600
	GameOver.GameoverY = 0 
	GameOver.GameoverY_velocity = 600 
	FrankIdle = love.graphics.newImage("Frank.jpg")
    Frank.image=FrankIdle 
    Frank.FrankX = 100
    Frank.FrankY = 430
	Frank.FrankW = Frank.image:getWidth()
	Frank.FrankH = Frank.image:getHeight()
    Frank.speed = 300
    Frank.FrankY_velocity = 100
    FrankGravity = 700
    jumpHeight = -600
	EthanIdle = love.graphics.newImage("Ethan.png")
	Ethan.image=EthanIdle
	Ethan.EthanX = 500
	Ethan.EthanY = 420
	Ethan.EthanW = Ethan.image:getWidth()
	Ethan.EthanH = Ethan.image:getHeight()
    Ethan.speed = 330
    Ethan.EthanX_velocity = 300
    EthanGravity = 600
	Line = love.graphics.newImage("Blackline.png")
	ToggleButton = { x = 290, y = 200, ToggleImage = love.graphics.newImage("Button.png"), clicked = false}
	ToggleWidth, ToggleHeight = ToggleButton.ToggleImage:getDimensions()
	jumpsound = love.audio.newSource("Hit Marker.wav", "static") -- Loads jump sound
    theme = love.audio.newSource("Minecraft Music [Full Playlist].mp3") -- Loads theme music
    theme:setVolume(0.3) -- Sets theme music to 30%
	CurrentScore = 0
	end 

function love.load()
	reset_game()
	state = 1;
 	
end 

function love.draw()
		if state == 1 then -- draw the menu
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(statefont)
		love.graphics.print("Main menu - press 2 to go to game.\n press 4 to go to highscore board.\n press 5 to go to help guide.\n press 6 to go to settings. ");
		love.graphics.setFont(titlefont)
		love.graphics.print("Main Menu", 250, 40)
		love.graphics.draw(StartGameButton.GameImage, StartGameButton.x, StartGameButton.y) --This is where we draw your button
		love.graphics.draw(HighScoreButton.ScoreImage, HighScoreButton.x, HighScoreButton.y) 
		love.graphics.draw(HelpButton.HelpImage, HelpButton.x, HelpButton.y)  
		love.graphics.draw(SettingsButton.SettingsImage, SettingsButton.x, SettingsButton.y)  
		love.graphics.setFont(statefont)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print("Start Game", 390, 205)
		love.graphics.print("Highscore Board", 380, 265)
		love.graphics.print("Settings", 405, 325)
		love.graphics.print("?", 780, 582)	
		love.graphics.setBackgroundColor(20,20,150)
		love.audio.stop(theme)
		love.audio.stop(jumpsound)
	elseif state  == 2 then -- draw the game 
		love.graphics.setColor(255,255,255)
		love.audio.play(theme)
		love.graphics.setFont(statefont)
		love.graphics.setBackgroundColor(20,20,150) -- r,g,b 
		love.graphics.print("Score: " .. Score, 720, 20)
		love.graphics.draw(Ethan.image, Ethan.EthanX, Ethan.EthanY)
		love.graphics.draw(Frank.image, Frank.FrankX, Frank.FrankY)
		love.graphics.draw(Line, 10, 520)
		love.graphics.print("Game - press 4 to go to Highscore Board.\n press 1 to go to Main Menu.")
	elseif state == 3 then -- draw game over
			love.graphics.setColor(255,255,255)
			love.graphics.setFont(statefont)
			love.audio.stop(jumpsound)
			love.audio.stop(theme)
			love.graphics.draw(GameOver.image, GameOver.GameoverX, GameOver.GameoverY)
			love.graphics.print("Game Over - press 1 to go to Main menu ")
	elseif state == 4 then  -- draw the Highscore board 
			love.audio.stop(theme)
			love.graphics.setColor(255,255,255)		
			love.graphics.setFont(titlefont)
			 --[[for i=1, 5 do
				 love.graphics.print(hsBoard[i], screenWidth / 2 - 100, 100 + i * 70)
			 end--]]
			 
			for key, value in pairs(hsBoard) do
				love.graphics.print(value, screenWidth / 2 - 100, 100 + key * 70)
			end
			 
			love.graphics.print("Highscore Board",160, 50)
			love.graphics.setBackgroundColor(20,20,150)
			love.graphics.setFont(statefont) 
			love.graphics.print("Highscore Board  - press 5 to go to help guide. \n press 1 to go to Main Menu.")
	elseif state == 5 then -- draw the help screen
			love.audio.stop(theme)
			love.graphics.setColor(255,255,255)
			love.graphics.setBackgroundColor(20,20,150)
			love.graphics.setFont(titlefont)
			love.graphics.print("Help Guide",250, 25)
			love.graphics.setFont(statefont)
			love.graphics.print("help guide  - press 6 to go to settings screen.\n press 1 to go to Main Menu")
			love.graphics.setFont(helpfont)
			love.audio.stop(theme)
			love.graphics.print("Starting from the main menu there are 4 button to click, game, highscore, help", 50, 105)
			love.graphics.print("and settings. \n \n You press the Start Game button or 2 in the keyboard to go in game. \n When you are in game the instructions are that you press space to jump", 50, 130)
			love.graphics.print("over the obstacle and get as many points as you can up until you hit the", 55, 210)
			love.graphics.print("obstacle and when that happens game over pops up on which means you", 55, 230)
			love.graphics.print("have died (or lost). Now to go into the highscore menu you press 1 to go", 56, 250)
			love.graphics.print("back to the menu screen then you either click the highscore button on the", 56, 270)
			love.graphics.print(" screen or press 4 to see the highest score anyone has done in the leaderboard.", 51, 290)
			love.graphics.print(" \n \n Now go back into the main menu by pressing 1.Now If you want to see the \n instructions you either press 5 on the keyboard or click the ? button.", 50, 310)
			love.graphics.print("it will bring you to a screen with all of the instructions to use the menus and", 55, 390)
			love.graphics.print("\n playing the game.  \n \n After you have read the instructions go back to the main \n menu which is 1 on the keyboard. Then you click the settings button or", 50, 390)
			love.graphics.print("press 6 on the keyboard to change the settings off the game. For instance", 55, 490)
			love.graphics.print("you can change the difficulty of the game to easy, normal or hard and If", 55, 510)
			love.graphics.print("you want the music on or off. Then go back to the menu after you are", 55, 530)
			love.graphics.print("done adjusting the settings.", 55, 550)
	elseif state == 6 then -- draw the settings screen
			love.graphics.setColor(255,255,255)
			love.graphics.setFont(titlefont)
			love.graphics.print("Settings",280, 50)
			love.graphics.setFont(helpfont)
			love.graphics.print("Music: ", 220, 205)
			if MusicToggle == true then 
				love.graphics.draw(ToggleButton.ToggleImage, ToggleButton.x, ToggleButton.y)
				love.graphics.setColor(0, 0, 0)
				love.graphics.print("On", 400, 205)
			else
				love.graphics.draw(ToggleButton.ToggleImage, ToggleButton.x, ToggleButton.y)
				love.graphics.setColor(0, 0, 0) 
				love.audio.stop(theme)
				love.graphics.print("Off", 400, 205)
		end  
		love.audio.stop(theme)
		love.graphics.setColor(255, 255, 255)
		love.graphics.setBackgroundColor(20,20,150)
		love.graphics.print("settings - press 1 to go to Main Menu") 
	end 
end 

function love.update(dt)
	--print(MusicToggle)
	if state == 2 then
		if (Frank.FrankY_velocity ~= 430) then
			Frank.FrankY = Frank.FrankY + Frank.FrankY_velocity * dt
			Frank.FrankY_velocity = Frank.FrankY_velocity + FrankGravity * dt
			if (Frank.FrankY > 430) then
				Frank.FrankY_velocity = 430
				Frank.FrankY = 430
			end
		end
	end
	 	 
	if state == 2 then
		if GameStarted then 
			Ethan.EthanX = Ethan.EthanX - Ethan.EthanX_velocity * dt
		end 
	end
		
		if collide(Frank:hitbox(), Ethan:hitbox()) then 
			state = 3 
		end  	
		
	if state == 2 then
		if MusicToggle == true then 
			local ethan_width = Ethan.image:getWidth()	
			if Ethan.EthanX + ethan_width < 0 then 
				local width, height = love.graphics.getDimensions()
				love.audio.play(jumpsound)
				love.audio.play(theme)
				Ethan.EthanX = width
				CurrentScore = Score                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   re = Score
				Score = Score + 1 
			end 
			
			else MusicToggle = false
				local ethan_width = Ethan.image:getWidth()	
				if Ethan.EthanX + ethan_width < 0 then 
					local width, height = love.graphics.getDimensions()
					love.audio.stop(jumpsound)
					love.audio.stop(theme)
					Ethan.EthanX = width
					CurrentScore = Score                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   re = Score
					Score = Score + 1 
				end 
		end 
	end 

	if (GameOver.GameoverY_velocity ~= 600) then
		GameOver.GameoverY = GameOver.GameoverY + GameOver.GameoverY_velocity * dt
		GameOver.GameoverY_velocity = GameOver.GameoverY_velocity * dt
		
		if (GameOver.GameoverY > 0) then 
			GameOver.GameoverY_velocity = 0 
			GameOver.GameoverY = 0
		end 
	end 
		
		if (GameOver.GameoverX_velocity ~= 600) then
			GameOver.GameoverX = GameOver.GameoverX + GameOver.GameoverX_velocity * dt
			GameOver.GameoverX_velocity = GameOver.GameoverX_velocity * dt
		
		if (GameOver.GameoverX > -245) then 
			GameOver.GameoverX_velocity = -245 
			GameOver.GameoverX = -245
		end  
end

function love.keypressed(key)

	if state == 1 then 
		if key == "2" then 
			state = 2 
			saveScores()
			--reset_game()
		end 
		
		if key == "4" then 
			state = 4 
			loadScores()
		end 
		
		if key == "5" then 
			state = 5
		end 
		
		if key == "6" then 
			state = 6 
		end
		
	elseif state == 2 then  
		if key == "return" then
			GameStarted = true 
		end 
	
		if key == "1" then 
			state = 1 
			reset_game()
		end 
		
		if key == "4" then 
			state = 4	
		end 
	
		elseif state == 3 then   
			if key == "1" then
			table.insert(hsBoard, Score)
			saveScores()
			reset_game()
				state = 1
			end
		
		elseif state == 4 then 
		if key == "5" then
			state = 5 
		end 
		
		if key == "1" then 
			state = 1 
		end 
		
		elseif state == 5 then 
		if key == "6" then 
			state = 6 
		end 
		
		if key == "1" then 
			state = 1 
		end 
		
		elseif state == 6 then 
		if key == "1" then 
			state = 1 
		end 
	end 	 
	
	 if key == "escape" then
      love.event.quit()
	  end 
	  
		if (key == " ") then

			if (Frank.FrankY_velocity == 430) then
				Frank.FrankY_velocity = jumpHeight
			
				if GameStarted == true and CurrentScore ~= Score and CurrentScore < 14  then
					Ethan.EthanX_velocity = Ethan.EthanX_velocity + 15
				end
			end
		end
	end 
end 

 function saveScores()
	 table.sort(hsBoard, function (a, b) return a > b end)
	
	 love.filesystem.write("Highscore.txt", TSerial.pack(hsBoard));	
 end			

 function loadScores()
	 local tbl = {};
	
	 if(love.filesystem.exists("Highscore.txt")) then
		 local contents = love.filesystem.read("Highscore.txt") 
		 tbl = TSerial.unpack(contents)
		-- print(tbl[1])
		 -- for key, value in pairs(tbl) do 
			-- table.insert(hsBoard, "Score - " .. tbl[value])
		-- end
		hsBoard = {}
		for key, value in pairs(tbl) do
			table.insert(hsBoard, value)
		end
		
		table.sort(hsBoard, function (a, b) return a > b end)
	end
 end
			
function love.mousepressed(mx, my, btn) 
	if state == 1 then  
		if mx > StartGameButton.x and my > StartGameButton.y and mx < (StartGameButton.x + StartGameWidth) and my < (StartGameButton.y + StartGameHeight) then
			state = 2
		end
		
		if mx > HighScoreButton.x and my > HighScoreButton.y and mx < (HighScoreButton.x + HighScoreWidth) and my < (HighScoreButton.y + HighScoreHeight) then
			state = 4
		end
		
		if mx > HelpButton.x and my > HelpButton.y and mx < (HelpButton.x + HelpWidth) and my < (HelpButton.y + HelpHeight) then
			state = 5
		end
		
		if mx > SettingsButton.x and my > SettingsButton.y and mx < (SettingsButton.x + SettingsWidth) and my < (SettingsButton.y + SettingsHeight) then
			state = 6
		end
	end
	
	if state == 6 then  
		if MusicToggle == true then 
			if mx > ToggleButton.x and my > ToggleButton.y and mx < (ToggleButton.x + ToggleWidth) and my < (ToggleButton.y + ToggleHeight) then
				MusicToggle = false 
			end 
				else MusicToggle = true 
		end 
	end 
end 

function collide(box1, box2, box3)
	return box1.x < box2.x + box2.w and 
		   box1.x + box1.w > box2.x and 
		   box1.y < box2.y + box2.h and 
		   box2.y < box1.y + box1.h
end

function Frank:hitbox()
	local tbl = {x = Frank.FrankX, y = Frank.FrankY, w = Frank.FrankW, h = Frank.FrankH }
	return tbl; 
end

function Ethan:hitbox()
	local tbl = {x = Ethan.EthanX, y = Ethan.EthanY, w = Ethan.EthanW, h = Ethan.EthanH }
	return tbl; 
end