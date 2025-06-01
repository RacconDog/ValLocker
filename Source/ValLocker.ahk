#Requires AutoHotkey v2.0

#SuspendExempt
^!s::Pause  ; Ctrl+Alt+S
#SuspendExempt False

; Data map: each key maps to an array: [float1, float2, stringClass]
data := Map()
data["Reyna"] := ["Duelist"]
data["Waylay"] := ["Duelist"]
data["Jett"] := ["Duelist"]
data["Cypher"] := ["Sentinel"]
data["Gekko"] := ["Initiator"]

myGui := Gui("Resize", "Simple Selection")
myGui.OnEvent("Close", (*) => ExitApp())

combo := myGui.AddComboBox("w200")

keys := []
for key in data
    keys.Push(key)
combo.Add(keys)

global agentClass := "Duelist"
global agentName := "Jett"

lockPos :=
combo.OnEvent("Change", (*) => UpdateVars())

UpdateVars() {
    global combo, data, agentClass, agentName
    key := combo.Text
    if data.Has(key) 
    {
        vals := data[key]
        agentClass := vals[1]
        agentName := key  ; <== this is what you asked for
    }

    ; MsgBox(agentName "  " agentClass)
}

myGui.Show()
UpdateVars()

foundAgentClass := false


while (true)
    {
        ; MsgBox(PixelGetColor(1250, 506))
        FoundX := 0
        FoundY := 0
        
        if (ImageSearch(&FoundX, &FoundY, 0, 0, 1920, 1080, "*25 " A_ScriptDir "\data\" agentClass "Icon.png") = 1 && foundAgentClass = false)
            {
                ; MsgBox "found class"
                foundAgentClass := true
                Click(FoundX, FoundY)
                Sleep(50)
                Click 5
            }
            if (ImageSearch(&FoundX, &FoundY, 0, 0, 1920, 1080, "*5 " A_ScriptDir . "\data\" agentName "Icon.png") && foundAgentClass = true)
                {
                    ; MsgBox((FoundX +15), (FoundY +15))
                    ; Sleep(50)
                    Click((FoundX), (FoundY))
                    Click 5
                    Sleep(50)
                    ;click the lockin button
                    Click(953, 752)
                    Sleep(200)
                    ; Click(1)
                    Click "Down"
                    Sleep(100)
                    Click "Up"
                    ; Click(1)
                    foundAgentClass := false
                    Sleep(100000)
                    ; Click(10)
                    ; Sleep(100000)
                    ; Pause
    }
}

IsCloseColor(colorOne, colorTwo, dist) {
    rgb_h := HexToRGB(colorOne)
    rgb_c := HexToRGB(colorTwo)

    dx := rgb_h.r - rgb_c.r
    dy := rgb_h.g - rgb_c.g
    dz := rgb_h.b - rgb_c.b

    distance := Sqrt(dx*dx + dy*dy + dz*dz)
    return distance <= dist
}

HexToRGB(hex) {
    ; Remove "0x" or "#" prefix if present
    if SubStr(hex, 1, 2) = "0x"
        hex := SubStr(hex, 3)
    else if SubStr(hex, 1, 1) = "#"
        hex := SubStr(hex, 2)

    if StrLen(hex) != 6
        throw ValueError("Invalid hex string: " hex)

    r := Integer("0x" . SubStr(hex, 1, 2))
    g := Integer("0x" . SubStr(hex, 3, 2))
    b := Integer("0x" . SubStr(hex, 5, 2))

    return { r: r, g: g, b: b }
}
