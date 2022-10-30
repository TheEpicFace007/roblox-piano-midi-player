-- Decompiled with the Synapse X Luau decompiler
-- script path: game:GetService("Players").LocalPlayer.PlayerGui.PianoGui.Main
Gui = script.Parent;
Player = game.Players.LocalPlayer;
player = game.Players.LocalPlayer;
PlayingEnabled = false;
SoundFonts = require(game.Workspace.Scripts.MainModule);
ScriptReady = false;
PianoId = nil;
local l__OsuMenu__1 = Player.PlayerGui:WaitForChild("OsuMenu");
Connector = game.Workspace:FindFirstChild("GlobalPianoConnector");
local l__Transpose__2 = script.Parent:WaitForChild("Transpose");
local v3 = time();
InputService = game:GetService("UserInputService");
Mouse = Player:GetMouse();
TextBoxFocused = false;
FocusLost = false;
ShiftLock = false;
letterNoteMap = "1!2@34$5%6^78*9(0qQwWeErtTyYuiIoOpPasSdDfgGhHjJklLzZxcCvVbBnm";
Gui.ScrollingFrame.Draggable = true;
function NPS()

end;
local u1 = false;
function Receive(p1, ...)
	local v4 = { ... };
	if not ScriptReady then
		return;
	end;
	if p1 == "activate" then
		if not PlayingEnabled then
			u1 = v4[4] == true;
			Activate(v4[1], v4[2], u1);
			specialPiano = v4[3];
			return;
		end;
	elseif p1 == "deactivate" then
		if PlayingEnabled then
			Deactivate();
		end;
		if v4[1] then
			if v4[1].Name == "DogePiano" then
				Gui.Parent.DogeGui.Frame.Visible = false;
				return;
			end;
		end;
	elseif p1 ~= "DDD" then
		if v4[1] == "DDD" then
			if Player.Name ~= v4[1] then
				if Player.Name == p1 then
					Deactivate();
					return;
				end;
			else
				Deactivate();
				return;
			end;
		elseif p1 == "play" then
			if Player ~= v4[1] then
				if v4[4] == "sus" then
					PlayNoteServer(v4[2], v4[3], v4[4], v4[5], v4[6], v4[7], v4[8]);
					return;
				end;
				PlayNoteSound(v4[2], v4[3], v4[4], v4[5], v4[6], v4[7], v4[8]);
			end;
		end;
	elseif Player.Name ~= v4[1] then
		if Player.Name == p1 then
			Deactivate();
			return;
		end;
	else
		Deactivate();
		return;
	end;
end;
Connector.OnClientEvent:connect(Receive);
function Activate(p2, p3, p4)
	PlayingEnabled = true;
	MakeHumanoidConnections();
	MakeKeyboardConnections();
	MakeGuiConnections();
	SetCamera(p2);
	SetSounds(p3);
	if not u1 then
		ShowPiano();
		return;
	end;
	l__OsuMenu__1.Enabled = true;
end;
function Deactivate()
	SpecialPiano = false;
	PlayingEnabled = false;
	BreakHumanoidConnections();
	BreakKeyboardConnections();
	BreakGuiConnections();
	HidePiano();
	HideSheets();
	ReturnCamera();
	Jump();
	if u1 then
		u1 = false;
		l__OsuMenu__1.Enabled = false;
	end;
end;
function Abort()
	SpecialPiano = false;
	Connector:FireServer("abort");
end;
function Digify(p5)
	local v5 = string.find(letterNoteMap, p5, 1, true);
	if v5 then
		return v5;
	end;
	return -1;
end;
local u2 = {};
local u3 = {};
local u4 = 1;
function PlayNoteClient(p6)
	local l__On__6 = player.Character.Humanoid.SeatPart.Parent.Parent:FindFirstChild("On");
	table.insert(u2, p6);
	table.insert(u3, p6);
	coroutine.resume(coroutine.create(start));
	if l__On__6 then
		if l__On__6.Value then
			PlayNoteSound(p6);
			HighlightPianoKey(p6);
			Connector:FireServer("play", p6, u4, l__Transpose__2.Value);
			return;
		end;
	end;
	if l__On__6 then
		if not l__On__6.Parent.Parent.IsActive.Value then
			PlayNoteSound(p6);
			HighlightPianoKey(p6);
			Connector:FireServer("play", p6, u4, l__Transpose__2.Value);
		end;
	else
		PlayNoteSound(p6);
		HighlightPianoKey(p6);
		Connector:FireServer("play", p6, u4, l__Transpose__2.Value);
	end;
end;
function PlayNoteServer(p7, p8, p9, p10, p11, p12, p13)
	PlayNoteSound(p7, p8, p9, p10, p11, SpecialPiano and p12, p13);
end;
function Transpose(p14)
	if 1 < p14 then
		p14 = 1;
	end;
	if p14 < -1 then
		p14 = -1;
	end;
	if l__Transpose__2.Value < 16 then
		if -16 < l__Transpose__2.Value then
			l__Transpose__2.Value = l__Transpose__2.Value + p14;
			PianoGui.TransposeLabel.Text = "Transposition: " .. l__Transpose__2.Value;
			return;
		end;
	end;
	if l__Transpose__2.Value == 16 then
		if p14 == -1 then
			l__Transpose__2.Value = l__Transpose__2.Value + p14;
			PianoGui.TransposeLabel.Text = "Transposition: " .. l__Transpose__2.Value;
			return;
		end;
	end;
	if l__Transpose__2.Value == -16 then
		if p14 == 1 then
			l__Transpose__2.Value = l__Transpose__2.Value + p14;
			PianoGui.TransposeLabel.Text = "Transposition: " .. l__Transpose__2.Value;
		end;
	end;
end;
function VolumeChange(p15)
	if u4 + p15 <= 1.5 then
		if 0.1 <= u4 + p15 then
			u4 = u4 + p15;
			PianoGui.VolumeLabel.Text = "Volume: " .. u4 * 100 .. "%";
		end;
	end;
end;
function Audio(p16, p17, ...)
	if not p17 then

	else
		return;
	end;
	({})[1] = ...;
end;
function LetterToNote(p18, p19, p20)
	local v7 = letterNoteMap:find(string.char(p18), 1, true);
	if v7 then

	else
		return;
	end;
	if p19 then
		local v8 = 1;
	elseif p20 then
		v8 = -1;
	else
		v8 = 0;
	end;
	return v7 + l__Transpose__2.Value + v8;
end;
local l__OsuPiano__9 = game.Workspace:WaitForChild("OsuPiano");
local u5 = false;
function KeyDown(p21, ...)
	if TextBoxFocused then
		return;
	end;
	local v10 = { ... };
	if not v10[1] then
		if v10[1] == false then
			local v11 = Enum.KeyCode[p21].Value;
		else
			v11 = p21.KeyCode.Value;
		end;
	else
		v11 = Enum.KeyCode[p21].Value;
	end;
	if u1 then
		osumain(v11);
		return;
	end;
	if 97 <= v11 then
		if not (v11 <= 122) then
			if 48 <= v11 then
				if v11 <= 57 then

				elseif v11 == 8 then
					Abort();
					return;
				elseif v11 == 32 then
					ToggleSheets();
					return;
				elseif v11 == 13 then
					ToggleCaps();
					return;
				elseif v11 == 274 then
					Transpose(-1);
					return;
				elseif v11 == 273 then
					Transpose(1);
					return;
				elseif v11 == 275 then
					VolumeChange(0.1);
					return;
				else
					if v11 == 276 then
						VolumeChange(-0.1);
					end;
					return;
				end;
			elseif v11 == 8 then
				Abort();
				return;
			elseif v11 == 32 then
				ToggleSheets();
				return;
			elseif v11 == 13 then
				ToggleCaps();
				return;
			elseif v11 == 274 then
				Transpose(-1);
				return;
			elseif v11 == 273 then
				Transpose(1);
				return;
			elseif v11 == 275 then
				VolumeChange(0.1);
				return;
			else
				if v11 == 276 then
					VolumeChange(-0.1);
				end;
				return;
			end;
		end;
	elseif 48 <= v11 then
		if v11 <= 57 then

		elseif v11 == 8 then
			Abort();
			return;
		elseif v11 == 32 then
			ToggleSheets();
			return;
		elseif v11 == 13 then
			ToggleCaps();
			return;
		elseif v11 == 274 then
			Transpose(-1);
			return;
		elseif v11 == 273 then
			Transpose(1);
			return;
		elseif v11 == 275 then
			VolumeChange(0.1);
			return;
		else
			if v11 == 276 then
				VolumeChange(-0.1);
			end;
			return;
		end;
	elseif v11 == 8 then
		Abort();
		return;
	elseif v11 == 32 then
		ToggleSheets();
		return;
	elseif v11 == 13 then
		ToggleCaps();
		return;
	elseif v11 == 274 then
		Transpose(-1);
		return;
	elseif v11 == 273 then
		Transpose(1);
		return;
	elseif v11 == 275 then
		VolumeChange(0.1);
		return;
	else
		if v11 == 276 then
			VolumeChange(-0.1);
		end;
		return;
	end;
	if not u5 then
		coroutine.resume(coroutine.create(NPS));
	end;
	local v12 = true;
	if (InputService:IsKeyDown(303) or InputService:IsKeyDown(304)) == ShiftLock then
		v12 = v10[1];
	end;
	PlayNoteClient((LetterToNote(v11, v12, InputService:IsKeyDown(305) or InputService:IsKeyDown(306))));
end;
function Input(p22)
	if p22.UserInputType.Name == "Keyboard" then
		if p22.UserInputState.Name == "Begin" then
			if FocusLost then

			else
				KeyDown(p22);
				return;
			end;
		else
			return;
		end;
	else
		return;
	end;
	FocusLost = false;
end;
function TextFocus()
	TextBoxFocused = true;
end;
function TextUnfocus()
	FocusLost = true;
	TextBoxFocused = false;
end;
KeyboardConnection = nil;
JumpConnection = nil;
FocusConnection = InputService.TextBoxFocused:connect(TextFocus);
UnfocusConnection = InputService.TextBoxFocusReleased:connect(TextUnfocus);
function MakeKeyboardConnections()
	KeyboardConnection = InputService.InputBegan:connect(Input);
end;
function BreakKeyboardConnections()
	KeyboardConnection:disconnect();
end;
PianoGui = Gui.PianoGui;
SheetsGui = Gui.SheetsGui;
SheetsVisible = false;
function ShowPiano()
	PianoGui:TweenPosition(UDim2.new(0.5, -355, 1, -230), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true);
end;
function HidePiano()
	PianoGui:TweenPosition(UDim2.new(0.5, -380, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true);
end;
function ShowSheets()
	SheetsGui:TweenPosition(UDim2.new(0.5, -200, 1, -520), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true);
end;
function HideSheets()
	SheetsGui:TweenPosition(UDim2.new(0.5, -200, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.5, true);
end;
function ToggleSheets()
	SheetsVisible = not SheetsVisible;
	if SheetsVisible then
		ShowSheets();
		return;
	end;
	HideSheets();
end;
function IsBlack(p23)
	if p23 % 12 ~= 2 then
		if p23 % 12 ~= 4 then
			if p23 % 12 ~= 7 then
				if p23 % 12 ~= 9 then
					if p23 % 12 == 11 then

					else
						return;
					end;
				end;
			end;
		end;
	end;
	return true;
end;
function HighlightPianoKey(p24)
	local v13 = nil;
	if p24 < 62 then
		if 0 < p24 then

		else
			delay(0.5, function()
				RestorePianoKey(p24);
			end);
			return;
		end;
	else
		delay(0.5, function()
			RestorePianoKey(p24);
		end);
		return;
	end;
	v13 = PianoGui.Keys[p24];
	if IsBlack(p24) then
		v13.BackgroundColor3 = Color3.new(0.19607843137254902, 0.19607843137254902, 0.19607843137254902);
	else
		v13.BackgroundColor3 = Color3.new(0.7843137254901961, 0.7843137254901961, 0.7843137254901961);
	end;
	delay(0.5, function()
		RestorePianoKey(p24);
	end);
end;
function RestorePianoKey(p25)
	local v14 = nil;
	if p25 < 62 then
		if 0 < p25 then
			v14 = PianoGui.Keys[p25];
			if IsBlack(p25) then

			else
				v14.BackgroundColor3 = Color3.new(1, 1, 1);
				return;
			end;
		else
			return;
		end;
	else
		return;
	end;
	v14.BackgroundColor3 = Color3.new(0, 0, 0);
end;
function PianoKeyPressed(p26, p27)
	local l__Name__15 = p26.UserInputType.Name;
	if l__Name__15 ~= "MouseButton1" then
		if l__Name__15 == "Touch" then
			PlayNoteClient(p27);
		end;
	else
		PlayNoteClient(p27);
	end;
end;
function ExitButtonPressed(p28)
	local l__Name__16 = p28.UserInputType.Name;
	if l__Name__16 ~= "MouseButton1" then
		if l__Name__16 == "Touch" then
			Deactivate();
		end;
	else
		Deactivate();
	end;
end;
function SheetsButtonPressed(p29)
	local l__Name__17 = p29.UserInputType.Name;
	if l__Name__17 ~= "MouseButton1" then
		if l__Name__17 == "Touch" then
			ToggleSheets();
		end;
	else
		ToggleSheets();
	end;
end;
function ToggleCaps()
	ShiftLock = not ShiftLock;
	if ShiftLock then
		PianoGui.CapsButton.BackgroundColor3 = Color3.new(1, 0.6666666666666666, 0);
		PianoGui.CapsButton.BorderColor3 = Color3.new(0.6039215686274509, 0.403921568627451, 0);
		PianoGui.CapsButton.TextColor3 = Color3.new(1, 1, 1);
		return;
	end;
	PianoGui.CapsButton.BackgroundColor3 = Color3.new(0.5490196078431373, 0.5490196078431373, 0.5490196078431373);
	PianoGui.CapsButton.BorderColor3 = Color3.new(0.26666666666666666, 0.26666666666666666, 0.26666666666666666);
	PianoGui.CapsButton.TextColor3 = Color3.new(0.7058823529411765, 0.7058823529411765, 0.7058823529411765);
end;
function CapsButtonPressed(p30)
	local l__Name__18 = p30.UserInputType.Name;
	if l__Name__18 ~= "MouseButton1" then
		if l__Name__18 == "Touch" then
			ToggleCaps();
		end;
	else
		ToggleCaps();
	end;
end;
PianoKeysConnections = {};
ExitButtonConnection = nil;
SheetsButtonConnection = nil;
CapsButtonConnection = nil;
TransDnConnection = nil;
TransUpConnection = nil;
VolumeUpConnection = nil;
VolumeDownConnection = nil;
function MakeGuiConnections()
	local v19, v20, v21 = pairs(PianoGui.Keys:GetChildren());
	while true do
		local v22, v23 = v19(v20, v21);
		if v22 then

		else
			break;
		end;
		v21 = v22;
		PianoKeysConnections[v22] = v23.InputBegan:connect(function(p31)
			PianoKeyPressed(p31, tonumber(v23.Name));
		end);	
	end;
	ExitButtonConnection = PianoGui.ExitButton.InputBegan:connect(ExitButtonPressed);
	SheetsButtonConnection = PianoGui.SheetsButton.InputBegan:connect(SheetsButtonPressed);
	CapsButtonConnection = PianoGui.CapsButton.InputBegan:connect(CapsButtonPressed);
	TransDnConnection = PianoGui.TransDnButton.MouseButton1Click:connect(function()
		Transpose(-1);
	end);
	TransUpConnection = PianoGui.TransUpButton.MouseButton1Click:connect(function()
		Transpose(1);
	end);
	VolumeUpConnection = PianoGui.VolumeUpButton.MouseButton1Click:connect(function()
		VolumeChange(0.1);
	end);
	VolumeDownConnection = PianoGui.VolumeDownButton.MouseButton1Click:connect(function()
		VolumeChange(-0.1);
	end);
end;
function BreakGuiConnections()
	local v24, v25, v26 = pairs(PianoKeysConnections);
	while true do
		local v27, v28 = v24(v25, v26);
		if v27 then

		else
			break;
		end;
		v26 = v27;
		v28:disconnect();	
	end;
	ExitButtonConnection:disconnect();
	SheetsButtonConnection:disconnect();
	CapsButtonConnection:disconnect();
end;
local v29 = {};
local l__SoundFontLabel__30 = Gui.SoundFontLabel;
for v31, v32 in pairs(SoundFonts) do
	table.insert(v29, v31);
end;
table.sort(v29);
l__SoundFontLabel__30.Text = "Font: " .. v29[1];
local u6 = 1;
Gui.Right.MouseButton1Click:Connect(function()
	u6 = u6 + 1;
	if #v29 < u6 then
		u6 = 1;
	end;
	l__SoundFontLabel__30.Text = "Font: " .. v29[u6];
end);
Gui.Left.MouseButton1Click:Connect(function()
	u6 = u6 - 1;
	if u6 < 1 then
		u6 = #v29;
	end;
	l__SoundFontLabel__30.Text = "Font: " .. v29[u6];
end);
local l__ScrollingFrame__33 = Gui.ScrollingFrame;
local v34 = 0;
for v35, v36 in pairs(v29) do
	local v37 = Instance.new("TextButton", l__ScrollingFrame__33);
	v37.Name = v36;
	v37.Text = v36;
	v37.Position = UDim2.new(0, 0, 0, v34);
	v37.Size = UDim2.new(0, 184, 0, 26);
	v34 = v34 + 31;
	v37.MouseButton1Click:connect(function()
		u6 = v35;
		l__SoundFontLabel__30.Text = "Font: " .. v29[u6];
	end);
end;
ContentProvider = game:GetService("ContentProvider");
LocalSounds = {};
SoundFolder = Gui.SoundFolder;
ExistingSounds = {};
ContentProvider:PreloadAsync(workspace.Scripts.MainModule:GetDescendants());
function SetSounds(p32)
	ContentProvider:PreloadAsync(workspace.Scripts.MainModule:GetDescendants());
	LocalSounds = p32;
end;
local u7 = 15;
local u8 = 2;
local u9 = 0;
function PlayNoteSound(p33, p34, p35, p36, p37, p38)
	if p35 == true then

	end;
	local v38 = 1;
	if 61 < p33 then
		v38 = 1.059463 ^ (p33 - 61);
	elseif p33 < 1 then
		v38 = 1.059463 ^ (-(1 - p33));
	end;
	if 61 < p33 then
		local v39 = 61;
	elseif p33 < 1 then
		v39 = 1;
	else
		v39 = p33;
	end;
	p33 = v39;
	local v40 = (p33 - 1) % 12 + 1;
	local v41 = math.ceil(p33 / 12);
	local v42 = math.ceil(v40 / 2);
	Audio();
	local v43 = Instance.new("Sound", SoundFolder);
	local v44 = SoundFonts[v29[u6]];
	v43.SoundId = "https://roblox.com/asset/?id=" .. v44[v42];
	local v45 = 0;
	local v46 = 0;
	local v47 = 0;
	if v44[7] then
		if type(v44[7]) == "table" then
			local v48, v49, v50 = pairs(v44[7]);
			while true do
				local v51 = nil;
				local v52 = nil;
				v52, v51 = v48(v49, v50);
				if v52 then

				else
					break;
				end;
				v50 = v52;
				if v52 == "Pos" then
					v45 = v51;
				elseif v52 == "Vol" then
					v46 = v51;
				elseif v52 == "Len" then
					v47 = v51;
				end;			
			end;
		end;
	end;
	if p34 then
		local v53 = -(1 / p35 ^ 2) * (game.Workspace.CurrentCamera.CoordinateFrame.p - p34).magnitude ^ 2 + 1;
		if v53 < 0.01 then
			v43:Destroy();
			return;
		end;
		v43.Volume = v53 * p37 + v46;
	else
		v43.Volume = u4 + v46;
	end;
	if not p38 then
		if specialPiano then
			local v54 = 0.04;
		else
			v54 = (v41 - 0.9) / 15;
		end;
	else
		v54 = 0.04;
	end;
	v43.TimePosition = 16 * (v41 - 1) + 8 * (1 - v40 % 2) + v54 + v45;
	v43.Pitch = v38;
	v43:Play();
	table.insert(ExistingSounds, 1, v43);
	if u7 <= #ExistingSounds then
		ExistingSounds[u7]:Stop();
		ExistingSounds[u7] = nil;
	end;
	if u8 == 1 then
		u9 = 5 + v47;
	else
		if u8 == 2 then
			u9 = 2 + v47;
		elseif u8 == 3 then
			u9 = 0.75 + v47;
		end;
		Tween(v43, {
			Volume = 0
		}, u9, false, Enum.EasingStyle.Quart, Enum.EasingDirection.In, 0, false);
	end;
	delay(u9, function()
		v43:Stop();
		v43:remove();
	end);
end;
Camera = game.Workspace.CurrentCamera;
function Jump()
	local l__Character__55 = Player.Character;
	if l__Character__55 then
		local l__Humanoid__56 = l__Character__55:FindFirstChild("Humanoid");
		if l__Humanoid__56 then
			l__Humanoid__56.Jump = true;
		end;
	end;
end;
function HumanoidChanged(p39, p40)
	if p40 == "Jump" then
		p39.Jump = false;
		return;
	end;
	if p40 == "Sit" then
		p39.Sit = true;
		return;
	end;
	if p40 == "Parent" then
		Deactivate();
		Abort();
	end;
end;
function HumanoidDied()
	Deactivate();
end;
function SetCamera(p41)
	Camera.CameraType = Enum.CameraType.Scriptable;
	Camera:Interpolate(p41, p41 + p41.lookVector, 0.5);
end;
function ReturnCamera()
	Camera.CameraType = Enum.CameraType.Custom;
end;
HumanoidChangedConnection = nil;
HumanoidDiedConnection = nil;
function MakeHumanoidConnections()
	local l__Character__57 = Player.Character;
	if l__Character__57 then
		local l__Humanoid__58 = l__Character__57:FindFirstChild("Humanoid");
		if l__Humanoid__58 then
			HumanoidChangedConnection = l__Humanoid__58.Changed:connect(function(p42)
				HumanoidChanged(l__Humanoid__58, p42);
			end);
			HumanoidDiedConnection = l__Humanoid__58.Died:connect(HumanoidDied);
		end;
	end;
end;
function BreakHumanoidConnections()
	HumanoidChangedConnection:disconnect();
	HumanoidDiedConnection:disconnect();
end;
function osumain(p43)
	local v59 = nil;
	v59 = l__OsuPiano__9.Case.GUI.S.B.Tracks;
	if p43 == 100 then
		local v60 = v59["1"]:GetChildren();
		if 0 < #v60 then
			if 0.88 < unpack(v60).Position.X.Scale then
				Connector:FireServer("osuhit", "D", true);
			else
				Connector:FireServer("osuhit", "D", false);
			end;
		else
			Connector:FireServer("osuhit", "D", false);
		end;
	elseif p43 == 102 then
		local v61 = v59["2"]:GetChildren();
		if 0 < #v61 then
			if 0.88 < unpack(v61).Position.X.Scale then
				Connector:FireServer("osuhit", "F", true);
			else
				Connector:FireServer("osuhit", "F", false);
			end;
		else
			Connector:FireServer("osuhit", "F", false);
		end;
	elseif p43 == 106 then
		local v62 = v59["3"]:GetChildren();
		if 0 < #v62 then
			if 0.88 < unpack(v62).Position.X.Scale then
				Connector:FireServer("osuhit", "J", true);
			else
				Connector:FireServer("osuhit", "J", false);
			end;
		else
			Connector:FireServer("osuhit", "J", false);
		end;
	elseif p43 == 107 then
		local v63 = v59["4"]:GetChildren();
		if 0 < #v63 then
			if 0.88 < unpack(v63).Position.X.Scale then
				Connector:FireServer("osuhit", "K", true);
			else
				Connector:FireServer("osuhit", "K", false);
			end;
		else
			Connector:FireServer("osuhit", "K", false);
		end;
	end;
	if p43 == 8 then
		Abort();
	end;
end;
local u10 = false;
function start()
	if not u10 then
		u10 = true;
		if 18 < #u2 then
			print(player.Name .. " has just been killed due to Chord Spam");
			player.Character:FindFirstChildOfClass("Humanoid").Health = -1;
		elseif 12 < #u2 then
			print("You have played a 12 note chord (or greater)");
		end;
		u2 = {};
		u10 = false;
	end;
end;
local l__Second__64 = script.Parent.Parent:WaitForChild("Speed").Frame.Second;
l__Second__64.Text = "Notes Per Second: " .. #u3 .. "\nPrevious: 0";
local v65 = { 34617889, 1345469984 };
local u11 = { 34617889, 1345469984 };
function Whitelisted(p44)
	local v66, v67, v68 = pairs(u11);
	while true do
		local v69, v70 = v66(v67, v68);
		if v69 then

		else
			break;
		end;
		v68 = v69;
		if v70 == p44 then
			return true;
		end;	
	end;
	return false;
end;
local u12 = 0;
local l__LocalPlayer__13 = game.Players.LocalPlayer;
function NPS()
	if not u5 then
		u5 = true;
		local v71 = 0;
		while true do
			v71 = v71 + 1;
			l__Second__64.Text = "Notes Per Second: " .. #u3 .. "\nPrevious: " .. u12;
			if 200 < #u3 then
				if not Whitelisted(l__LocalPlayer__13.UserId) then
					l__LocalPlayer__13:Kick("[SYSTEM] You have been kicked on assumption of spamming");
				elseif 180 < #u3 then
					if not Whitelisted(l__LocalPlayer__13.UserId) then
						if PlayingEnabled then
							Deactivate();
						end;
					end;
				end;
			elseif 180 < #u3 then
				if not Whitelisted(l__LocalPlayer__13.UserId) then
					if PlayingEnabled then
						Deactivate();
					end;
				end;
			end;
			wait(0.1);
			if v71 ~= 10 then

			else
				break;
			end;		
		end;
		u12 = #u3;
		u3 = {};
		l__Second__64.Text = "Notes Per Second: " .. #u3 .. "\nPrevious: " .. u12;
		u5 = false;
	end;
end;
local l__Frame__72 = script.Parent.Parent:WaitForChild("AutoPlayer"):WaitForChild("Frame");
local v73 = {};
local l__ContextActionService__74 = game.ContextActionService;
local l__Transpose__75 = script.Parent:WaitForChild("Transpose");
l__Frame__72.Info.Text = "In order to use this, you must: \nput your notes into the notes textbox, hit play, then hit one (or several) of the keybinds to play the notes\n\nKeybinds:\nDash [-] | Equals [=] | LeftBracket ([) | RightBracket (]) | SemiColon [;] | Comma [,] | Period [.] \n";
l__Frame__72.Draggable = true;
local l__TweenService__14 = game:GetService("TweenService");
function Tween(p45, p46, p47, p48, ...)
	local v76 = l__TweenService__14:Create(p45, TweenInfo.new(p47, ...), p46);
	v76:Play();
	if p48 then
		v76.Completed:wait();
	end;
end;
function play(p49)
	local v77 = {};
	local v78 = {};
	local v79 = #p49;
	local v80 = 1 - 1;
	while true do
		local v81 = string.sub(p49, v80, v80);
		if v81 ~= " " then
			if v81 ~= "" then
				if v81 ~= "]" then
					if v81 ~= "[" then
						if v81 ~= "-" then
							if v81 ~= "|" then
								if string.match(v81, "%p") then
									if v81 == "!" then
										v81 = "One";
									elseif v81 == "@" then
										v81 = "Two";
									elseif v81 == "#" then
										v81 = "Three";
									elseif v81 == "$" then
										v81 = "Four";
									elseif v81 == "%" then
										v81 = "Five";
									elseif v81 == "^" then
										v81 = "Six";
									elseif v81 == "&" then
										v81 = "Seven";
									elseif v81 == "*" then
										v81 = "Eight";
									elseif v81 == "(" then
										v81 = "Nine";
									elseif v81 == ")" then
										v81 = "Zero";
									end;
									table.insert(v77, v81);
								elseif string.match(v81, "%u") then
									table.insert(v77, string.upper(v81));
								elseif string.match(v81, "%d") then
									if v81 == "1" then
										v81 = "One";
									elseif v81 == "2" then
										v81 = "Two";
									elseif v81 == "3" then
										v81 = "Three";
									elseif v81 == "4" then
										v81 = "Four";
									elseif v81 == "5" then
										v81 = "Five";
									elseif v81 == "6" then
										v81 = "Six";
									elseif v81 == "7" then
										v81 = "Seven";
									elseif v81 == "8" then
										v81 = "Eight";
									elseif v81 == "9" then
										v81 = "Nine";
									elseif v81 == "0" then
										v81 = "Zero";
									end;
									table.insert(v78, v81);
								elseif string.match(v81, "%l") then
									table.insert(v78, string.upper(v81));
								end;
							end;
						end;
					end;
				end;
			end;
		end;
		if 0 <= 1 then
			if v80 < v79 then

			else
				break;
			end;
		elseif v79 < v80 then

		else
			break;
		end;
		v80 = v80 + 1;	
	end;
	local v82, v83, v84 = pairs(v78);
	while true do
		local v85, v86 = v82(v83, v84);
		if v85 then

		else
			break;
		end;
		v84 = v85;
		coroutine.resume(coroutine.create(KeyDown), v86, false);	
	end;
	local v87, v88, v89 = pairs(v77);
	while true do
		local v90, v91 = v87(v88, v89);
		if v90 then

		else
			break;
		end;
		v89 = v90;
		coroutine.resume(coroutine.create(KeyDown), v91, true);	
	end;
end;
function Passing(p50, p51)
	if p50 then
		if p51 then
			l__LocalPlayer__13.Character.Head.AutoPlaying.AutoPlayingLabel.Visible = true;
		else
			l__LocalPlayer__13.Character.Head.AutoPlaying.AutoPlayingLabel.Visible = false;
		end;
		if p50 ~= -420 then
			pcall(play, p50);
		end;
	end;
end;
local u15 = false;
local u16 = 1;
function HitKey(p52, p53, p54)
	pcall(function()
		local l__Text__92 = l__Frame__72.NoteFrame.ScrollingFrame.Notes.Text;
		local v93 = 0;
		if p53 == Enum.UserInputState.Begin then
			if u15 then
				if 1 < #l__Text__92 then
					if string.sub(l__Text__92, u16, u16) then
						if #l__Text__92 < u16 then
							u16 = 1;
						end;
						local v94 = string.sub(l__Text__92, u16, u16);
						while true do
							if not string.match(v94, "%a") then
								if not string.match(v94, "%p") then
									if string.match(v94, "%d") then
										if v94 ~= "[" then
											if v94 ~= " " then
												if v94 ~= "" then
													if v94 ~= "-" then
														if v94 ~= "|" then
															if v94 ~= "  " then
																if v94 == "\n" then

																else
																	break;
																end;
															end;
														end;
													end;
												end;
											end;
										end;
									end;
								elseif v94 ~= "[" then
									if v94 ~= " " then
										if v94 ~= "" then
											if v94 ~= "-" then
												if v94 ~= "|" then
													if v94 ~= "  " then
														if v94 == "\n" then

														else
															break;
														end;
													end;
												end;
											end;
										end;
									end;
								end;
							elseif v94 ~= "[" then
								if v94 ~= " " then
									if v94 ~= "" then
										if v94 ~= "-" then
											if v94 ~= "|" then
												if v94 ~= "  " then
													if v94 == "\n" then

													else
														break;
													end;
												end;
											end;
										end;
									end;
								end;
							end;
							v93 = v93 + 1;
							if v94 == "[" then
								local v95 = "";
								local v96 = 0;
								while true do
									if v94 ~= "]" then

									else
										break;
									end;
									v96 = v96 + 1;
									v94 = string.sub(l__Text__92, u16, u16);
									if v94 ~= "[" then
										if v94 ~= "]" then
											v95 = v95 .. v94;
										end;
									end;
									if v94 ~= "" then

									else
										break;
									end;
									if v94 ~= " " then

									else
										break;
									end;
									u16 = u16 + 1;
									if not (20 < v96) then

									else
										break;
									end;								
								end;
								local v97 = #v95;
								local v98 = 1 - 1;
								while true do
									local v99 = string.sub(v95, v98, v98);
									if v99 ~= "]" then
										if not string.find(v99, "]") then
											if Digify(v99) ~= -1 then
												Passing(v99, true);
											end;
										end;
									end;
									if 0 <= 1 then
										if v98 < v97 then

										else
											break;
										end;
									elseif v97 < v98 then

									else
										break;
									end;
									v98 = v98 + 1;								
								end;
							elseif v94 ~= "[" then
								if v94 ~= "]" then
									u16 = u16 + 1;
									if #l__Text__92 < u16 then
										u16 = 1;
										v94 = string.sub(l__Text__92, u16, u16);
										break;
									end;
									v94 = string.sub(l__Text__92, u16, u16);
								end;
							end;
							if not (20 < v93) then

							else
								break;
							end;						
						end;
						if Digify(v94) ~= -1 then
							Passing(v94, true);
							u16 = u16 + 1;
						else
							u16 = u16 + 1;
						end;
					end;
				end;
			end;
		end;
		l__Frame__72.NoteReadout.Text = string.gsub(string.sub(l__Text__92, u16, u16 + 60), "\n", "");
	end);
end;
l__Frame__72.Play.MouseButton1Click:Connect(function()
	if l__Frame__72.Play.Text ~= "Play" then
		l__Frame__72.Play.Text = "Play";
		l__LocalPlayer__13.Character.Head.AutoPlaying.AutoPlayingLabel.Visible = false;
		Connector:FireServer("off11");
		u15 = false;
		return;
	end;
	l__Frame__72.Play.Text = "Stop";
	l__LocalPlayer__13.Character.Head.AutoPlaying.AutoPlayingLabel.Visible = true;
	Passing(-420, true);
	Connector:FireServer("on11");
	u15 = true;
	u16 = 1;
end);
l__Frame__72.NoteButton.MouseButton1Click:connect(function()
	if l__Frame__72.NoteFrame.Visible then
		l__Frame__72.NoteFrame.Visible = false;
		return;
	end;
	l__Frame__72.NoteFrame.Visible = true;
end);
local u17 = false;
function SustainHit(p55, p56, p57)
	pcall(function()
		local v100 = nil;
		if p56 == Enum.UserInputState.Begin then
			v100 = player.PlayerGui.TextStuff.Sustain;
			if u17 then

			elseif u8 ~= 2 then
				u8 = 2;
				v100.Visible = true;
				v100.Text = "Sustain ON";
				wait(0.5);
				v100.Visible = false;
				return;
			else
				u8 = 3;
				v100.Visible = true;
				v100.Text = "Sustain OFF";
				wait(0.5);
				v100.Visible = false;
				return;
			end;
		else
			return;
		end;
		if u8 == 3 then
			u8 = 1;
			v100.Visible = true;
			v100.Text = "Original Sustain";
			wait(0.5);
			v100.Visible = false;
			return;
		end;
		if u8 == 1 then
			u8 = 2;
			v100.Visible = true;
			v100.Text = "Sustain ON";
			wait(0.5);
			v100.Visible = false;
			return;
		end;
		u8 = 3;
		v100.Visible = true;
		v100.Text = "Sustain OFF";
		wait(0.5);
		v100.Visible = false;
	end);
end;
l__ContextActionService__74:BindAction("KeyInteracted", HitKey, false, Enum.KeyCode.Period, Enum.KeyCode.Comma, Enum.KeyCode.Minus, Enum.KeyCode.Equals, Enum.KeyCode.Semicolon, Enum.KeyCode.LeftBracket, Enum.KeyCode.RightBracket);
l__ContextActionService__74:BindAction("KeyInt", SustainHit, false, Enum.KeyCode.BackSlash);
l__Frame__72.Top.Close.MouseButton1Click:connect(function()
	u15 = false;
	l__LocalPlayer__13.Character.Head.AutoPlaying.AutoPlayingLabel.Visible = false;
	Connector:FireServer("off11");
	l__Frame__72.Visible = false;
end);
local u18 = false;
local u19 = false;
l__Frame__72.Top.Minimize.MouseButton1Click:Connect(function()
	if u18 then
		u18 = false;
		Tween(l__Frame__72, {
			Size = UDim2.new(0, 312, 0, 300)
		}, 0.5, true, Enum.EasingStyle.Linear);
		for v101, v102 in pairs(l__Frame__72:GetChildren()) do
			if not v102:IsA("Frame") and not v102:IsA("Script") then
				v102.Visible = true;
			end;
		end;
		if u19 then
			l__Frame__72.NoteFrame.Visible = true;
		end;
		return;
	end;
	u18 = true;
	if l__Frame__72.NoteFrame.Visible then
		u19 = true;
		l__Frame__72.NoteFrame.Visible = false;
	else
		u19 = false;
	end;
	for v103, v104 in pairs(l__Frame__72:GetChildren()) do
		if not v104:IsA("Frame") and not v104:IsA("Script") then
			v104.Visible = false;
		end;
	end;
	Tween(l__Frame__72, {
		Size = UDim2.new(0, 312, 0, 30)
	}, 0.5, true, Enum.EasingStyle.Linear);
end);
local l__Settings__105 = l__LocalPlayer__13.PlayerGui:WaitForChild("Settings");
local l__Frame__106 = l__Settings__105.Frame;
local l__Buttons__107 = l__Frame__106.Buttons;
local u20 = true;
l__Settings__105.Button.MouseButton1Click:Connect(function()
	if not u20 then
		Tween(l__Frame__106, {
			Position = UDim2.new(0.5, -160, 2, -125)
		}, 0.5, true, Enum.EasingStyle.Linear);
		u20 = true;
		return;
	end;
	if u20 then
		Tween(l__Frame__106, {
			Position = UDim2.new(0.5, -160, 0.45, -125)
		}, 0.5, true, Enum.EasingStyle.Linear);
		u20 = false;
	end;
end);
local v108 = { "ES", "SusBind", "SusOld" };
l__Buttons__107.CanvasSize = UDim2.new(0, 0, 0, #v108 * 26);
local v109 = 0;
local v110, v111, v112 = pairs(v108);
while true do
	local v113, v114 = v110(v111, v112);
	if not v113 then
		break;
	end;
	if v113 ~= 1 then
		v109 = v109 + 26;
	end;
	if v114 ~= "SusOld" then
		local v115 = l__Settings__105.RefText:Clone();
		v115.Parent = l__Buttons__107;
	else
		v115 = l__Settings__105.RefBtn:Clone();
		v115.Parent = l__Buttons__107;
	end;
	local v116 = l__Settings__105.RefLabel:Clone();
	v116.Parent = l__Buttons__107;
	v115.Visible = true;
	v116.Visible = true;
	v115.Position = UDim2.new(1, -85, 0, v109);
	v116.Position = UDim2.new(0, 15, 0, v109);
	if v114 == "ES" then
		v116.Text = "Max existing sounds(15-40): " .. u7;
		v115.FocusLost:Connect(function(p58, p59)
			pcall(function()
				if p58 and tonumber(v115.Text) <= 40 and tonumber(v115.Text) >= 15 then
					u7 = tonumber(v115.Text);
					v116.Text = "Max existing sounds(15-40): " .. u7;
					v115.Text = "";
					return;
				end;
				if not (not p58) and tonumber(v115.Text) > 40 or tonumber(v115.Text) < 15 then
					v115.Text = "";
				end;
			end);
		end);
	elseif v114 == "SusBind" then
		v115.ClearTextOnFocus = true;
		v116.Text = "Enter an Enum Keycode to bind sustain:";
		v115.FocusLost:Connect(function(p60, p61)
			pcall(function()
				if not p60 or not pcall(function()
					local v117 = Enum.KeyCode[v115.Text];
				end) then
					if p60 then
						v115.Text = "Error";
					end;
					return;
				end;
				pcall(function()
					l__ContextActionService__74:UnbindAction("SusKey");
				end);
				l__ContextActionService__74:BindAction("SusKey", SustainHit, false, Enum.KeyCode[v115.Text]);
				v115.Text = "Success";
			end);
		end);
	elseif v114 == "SusOld" then
		v116.Text = "Toggle original sustain as option:";
		v115.Text = "Off";
		v115.MouseButton1Click:Connect(function()
			if v115.Text == "Off" then
				u17 = true;
				u8 = 3;
				SustainHit(nil, Enum.UserInputState.Begin, nil);
				v115.Text = "On";
				return;
			end;
			u17 = false;
			u8 = 1;
			SustainHit(nil, Enum.UserInputState.Begin, nil);
			v115.Text = "Off";
		end);
	end;
end;
ScriptReady = true;
