-------------------------
-- Demo Tab for SideBar
-------------------------
local style = props['style.*.32']
local colorback = style:match('back:(#%x%x%x%x%x%x)')
local colorfore = style:match('fore:(#%x%x%x%x%x%x)') or '#000000'
local panel_width = tonumber(props['sidebar.width']) or 326
local tab4 = gui.panel(panel_width)
local label_text
local label_icon
-------------------
-- treeview explorer
local filetree = false
if filetree then
local ftree = gui.tree(true, false) -- haslines[true], editable[false]
if colorback then ftree:set_tree_colour(colorfore,colorback) end
tab4:add(ftree,'top',200)
local imgcnt = ftree:set_iconlib([[%windir%\system32\shell32.dll]], true )
ftree:set_theme( true ) --set 'explorer' theme

do
	local idx_ico_folder = 3
	local idx_ico_file = 70

	function get_idx_by_ext( ext )
		local shell_icons = {
			txt = 70,
			lua = 70,
			properties = 70,
			bat = 71,
			exe = 24,
			dll = 90,
			lib = 90,
			pdb = 90,
			mp3 = 116,
			ico = 127,
			bmp = 127,
			png = 127,
			html = 242,
			xml = 242,
		}
		return shell_icons[ext] or 69
	end

	function iterate_dir( _path, itm )
		local t = gui.files(_path.."\\*", true)
		for k, v in ipairs(t) do
			local knot = ftree:add_item(v, itm, idx_ico_folder, idx_ico_folder, {name = _path.."\\"..v, dir = true})
			iterate_dir( _path.."\\"..v, knot )
		end
		local t = gui.files(_path.."\\*", false)
		for k, v in ipairs(t) do
			local idx_ico = get_idx_by_ext( v:match("%.(.+)$") )
			ftree:add_item(v, itm, idx_ico, idx_ico, {name = _path.."\\"..v, dir = false})
		end
	end
	local base_path = props['SciteDefaultHome']:match("(.-\\)")
	local tm = os.clock()
	local knot = ftree:add_item(base_path, nil, idx_ico_folder, idx_ico_folder, {name = base_path, dir = true})
	iterate_dir( base_path, knot )
	print('time=', os.clock()-tm)

	ftree:on_double_click(function(sel_item)
		--label_text:set_text('db click tree:'.. tostring(tree:tree_get_item_data(sel_item)))
		local data = ftree:tree_get_item_data(sel_item)
		if not data.dir then scite.Open( data.name ) end
	end)
end
end
-------------------
local tree = gui.tree(true,false) -- haslines[true], editable[false]
if colorback then tree:set_tree_colour(colorfore,colorback) end
tab4:add(tree, "none")
tree:position(5,370)
tree:size(150,120)
--local itm1 = tree:add_item("item1", nil, 1) -- ("caption" [, parent_item = root][, icon_idx=-1][, sel_icon_idx=-1][, data=nil])
--[[tree:add_item("item2", itm1, 1)
tree:add_item("item3")
local itm4 = tree:add_item("item4")
local itm5 = tree:add_item("item5", itm4,-1)
local itm6 = tree:add_item("item6", itm5,0)
local itm7 = tree:add_item("item7", itm6,0)]]
-- local imgcnt = tree:set_iconlib([[toolbar\cool.dll]]) --path [, small_size = true] return count of loaded icons
-- local imgcnt = tree:set_iconlib([[%windir%\system32\shell32.dll]], false ) 
-- local imgcnt = tree:set_iconlib([[%SystemRoot%\system32\shell32.dll]])
--[[tree:add_item("qwerty", nil, 1)
tree:add_item("qwerty2", nil, 1)
tree:add_item("qwerty3", nil, 1)]]

local imgcnt = tree:set_iconlib([[toolbar\cool.dll]]) --path [, small_size = true] return count of loaded icons
-- local imgcnt = tree:set_iconlib([[%windir%\system32\shell32.dll]] )
local lib1_itm = tree:add_item("cool icons", nil, 16)
for icon_idx=0, imgcnt-1 do
	tree:add_item("item_"..icon_idx, lib1_itm, icon_idx, icon_idx, icon_idx )
end

-- tree:set_selected_item(itm5)
-- print("test:",tree:tree_item_get_text(itm5))
tree:on_select(function(sel_item)
	label_text:set_text('select tree:'.. tree:tree_get_item_text(sel_item))
end)
tree:on_double_click(function(sel_item)
	local data = tree:tree_get_item_data(sel_item)
	label_text:set_text('db click tree:'.. tostring(data))
	label_icon:set_icon([[toolbar\cool.dll]], data)
end)

-- tree:set_tree_editable(true)
-- function tree_test_menu() label_text:set_text('menu for tree clicked') end --ok
-- tree:context_menu{"test|tree_test_menu"} -- ok
-------------------
local listbox = gui.listbox(77)
tab4:add(listbox, "none")
listbox:position(170,370)
listbox:size(150,120)
for i=1,15 do
	listbox:append("line"..i, i*i)
end

-- listbox:insert(idx, "caption"[,data]) -- ok
-- listbox:select(10) -- ok
listbox:remove(2) --ok
-- print("lb1:",listbox:count())
-- listbox:clear() --ok
-- print("lb2:",listbox:count()) -- ok
-- print("select=",listbox:select()) --ok
-- print("line_0_text=",listbox:get_line_text(4))
-- print("line_0_data=",listbox:get_line_data(4))
function list_test_menu() label_text:set_text('menu for list clicked') end
listbox:context_menu{"test|list_test_menu"}

tab4:on_command(function(id, state)
	if id==77 then
		--[[
		1 - clicked
		2 - db clicked
		4 - focused
		5 - unfocused
		]]
		if state==2 then
		-- 	print("db clicked list:",listbox:get_line_text(listbox:select()))
			label_text:set_text("list db clicked:"..listbox:get_line_text(listbox:select()))
		end
		if state==1 then
			label_text:set_text("list clicked:"..listbox:get_line_data(listbox:select()))
		end
	end
end)
-------------------

local btn = gui.button("btn1",11)
tab4:add(btn,"none")
btn:position(20,260)
btn:size(50,30)

local btn2 = gui.button("btn2",22, true)
tab4:add(btn2,"none")
btn2:position(80,260)
btn2:size(50,30)

local chbox = gui.checkbox("checkbox",33, false) -- caption, id, treestate
tab4:add(chbox,"none")
chbox:position(185,260)

local rbtn = gui.radiobutton("radio_1",44, true) -- caption, id, auto
tab4:add(rbtn,"none")
rbtn:position(20,295)
rbtn:check(true)

local rbtn2 = gui.radiobutton("radio_2",55, true)
tab4:add(rbtn2,"none")
rbtn2:position(100,295)

local chbox3 = gui.checkbox("threestate",34, true) -- caption, id, treestate
tab4:add(chbox3,"none")
chbox3:position(185,295)

-- LABEL --
--[[
-- text alignment
left   0
center 1
right  2

-- markers
#define SS_BLACKRECT        0x00000004
#define SS_GRAYRECT         0x00000005
#define SS_WHITERECT        0x00000006

-- icon, bitmap
#define SS_ICON             0x00000003L
#define SS_BITMAP           0x0000000EL

-- borders
#define SS_BLACKFRAME       0x00000007
#define SS_GRAYFRAME        0x00000008
#define SS_WHITEFRAME       0x00000009
#define SS_ETCHEDFRAME      0x00000012

-- text with border
#define SS_SUNKEN           0x00001000 
]]

label_text = gui.label("StaticText",
	0
--  + 0x00001000
 + 0x00001000
--  + 0x00000003
 -- + 0x0000000E
 )
tab4:add(label_text, "none")
label_text:position(50, 155)
------- label icon -------
label_icon = gui.label("", 0x00000003)
tab4:add(label_icon, "none")
label_icon:position(20, 155)
label_icon:set_icon([[toolbar\cool.dll]])
--------------------------
--[[ trackbar style option
#define TBS_AUTOTICKS           0x0001
#define TBS_VERT                0x0002
#define TBS_HORZ                0x0000
#define TBS_TOP                 0x0004
#define TBS_BOTTOM              0x0000
#define TBS_LEFT                0x0004
#define TBS_RIGHT               0x0000
#define TBS_BOTH                0x0008
#define TBS_NOTICKS             0x0010
#define TBS_ENABLESELRANGE      0x0020
#define TBS_FIXEDLENGTH         0x0040
#define TBS_NOTHUMB             0x0080
#define TBS_TOOLTIPS            0x0100
#define TBS_REVERSED            0x0200
]]
local trbar1 = gui.trackbar(0x20 + 0x200, 77) -- style, id
tab4:add(trbar1,"none")
trbar1:position(20,235)
trbar1:size(250, 20)
-- trbar1:size(20, 250) -- vert
-- trbar1:range(20,80)
--[[
-- style TBS_ENABLESELRANGE required
local selmin, selmax = trbar1:select() -- get selmin, selmax
trbar1:select(20,80) -- set selection
trbar1:sel_clear() -- clear selection
]]
local prog
tab4:on_scroll( function(id, pos)
	if id==77 then
		label_text:set_text("scroll to: " .. pos)
		prog:set_progress_pos( pos )
	end
end)

--[[
#define CBS_SIMPLE            0x0001L
#define CBS_DROPDOWN          0x0002L
#define CBS_DROPDOWNLIST      0x0003L
#define CBS_OWNERDRAWFIXED    0x0010L
#define CBS_OWNERDRAWVARIABLE 0x0020L
#define CBS_AUTOHSCROLL       0x0040L
#define CBS_OEMCONVERT        0x0080L
#define CBS_SORT              0x0100L
#define CBS_HASSTRINGS        0x0200L
#define CBS_NOINTEGRALHEIGHT  0x0400L
#define CBS_DISABLENOSCROLL   0x0800L
#define CBS_UPPERCASE         0x2000L
#define CBS_LOWERCASE         0x4000L
]]
-----------------------------------
local cbbox = gui.combobox(90, 0 -- id, style
+ 0x0001
+ 0x0040
) 
tab4:add(cbbox, "none")
cbbox:position(20,5)
cbbox:size(250,85)
for i=1,10 do
	cbbox:cb_append("text1_"..i)
end
cbbox:cb_setcursel(1)
-----------------------------------
local cbbox = gui.combobox(89, 0 -- id, style
+ 0x0002
+ 0x0040
) 
-- tab4:add(cbbox, "top")
tab4:add(cbbox, "none")
cbbox:position(20,90)
cbbox:size(250,20)
for i=1,10 do
	cbbox:cb_append("text2_"..i)
end
cbbox:cb_setcursel(2)
------------------------------------
local cbbox = gui.combobox(88, 0 -- id, style
+ 0x0003
+ 0x0040
) 
-- tab4:add(cbbox, "top")
tab4:add(cbbox, "none")
cbbox:position(20,120)
cbbox:size(250,10)
for i=1,10 do
	cbbox:cb_append("text3_"..i)
end

-- cbbox:cb_items_h(15) -- ok
cbbox:cb_setcursel(1) -- ok
-- print(cbbox:cb_getcursel(), cbbox:get_text())
cbbox:cb_setcursel(-1) -- clear selection
-- cbbox:cb_clear()
cbbox:cb_setcursel(3)

local btn3 = gui.button("Tree Explorer", 133, true)
tab4:add(btn3, "none")
btn3:position(20,200)
btn3:size(80,20)

tab4:tooltip(133,"подсказка")

local btn4 = gui.button("TreeEdit ON", 134, true)
tab4:add(btn4, "none")
btn4:position(110,200)
btn4:size(80,20)
--[[
#define ES_LEFT             0x0000L
#define ES_CENTER           0x0001L
#define ES_RIGHT            0x0002L
#define ES_MULTILINE        0x0004L
#define ES_UPPERCASE        0x0008L
#define ES_LOWERCASE        0x0010L
#define ES_PASSWORD         0x0020L
#define ES_AUTOVSCROLL      0x0040L
#define ES_AUTOHSCROLL      0x0080L
#define ES_NOHIDESEL        0x0100L
#define ES_OEMCONVERT       0x0400L
#define ES_READONLY         0x0800L
#define ES_WANTRETURN       0x1000L
#define ES_NUMBER           0x2000L
]]
local editbox = gui.editbox(
0
-- + 0x2000
+ 0x0001
-- + 0x0002
+ 0x0100
-- + 0x0800
-- + 0x0004
-- + 0x1000
)
tab4:add(editbox, "none")
editbox:position(190, 155)
editbox:size(80,20)
editbox:set_text("EditBox")

-------------- progress bar ---------------
prog = gui.progress() --args: vertical=false, hasborder=false, smooth=false, smoothrevers=false
tab4:add(prog, "none")
prog:position(20, 180)
prog:size(250,10)
prog:set_progress_pos( 40 )
-- prog:progress_set_barcolor( "#FF0000" ) -- d'not work
-- prog:progress_set_bkcolor( "#00FF00" )-- d'not work

-- btn for test 'go' method
local btn5 = gui.button("Progress GO", 135, true)
tab4:add(btn5, "none")
btn5:position(200,200)
btn5:size(70,20)

--------------------------------------------
local tree_explorer = false
local tree_editable = false
local move_modes = {"off","on"}
local move_mode = 0
tab4:on_command(function(id, state)
-- 	print(string.format("command from [%d], state [%d]", id, state))
	if id == 333 then
		move_mode = (move_mode+1)%(#move_modes)
		label_text:set_text('mode:'..move_modes[move_mode+1])
	end
	if id==135 then
		prog:progress_go( )
	end
	if id==88 then -- combobox
		if state == 1 then
-- 			print(cbbox:get_text(), state)
			label_text:set_text("cbox_text:"..cbbox:get_text())
		end
	end
	
	if id==44 then
		label_text:set_text('radio_1_clicked')
	end
	
	if id==55 then
		label_text:set_text('radio_2_clicked')
	end
	
	if id==11 then
		label_text:set_text('btn_1_clicked')
		trbar1:select(30,60)
		--trbar1:set_pos(trbar1:get_pos()+5)
	-- 	print(">>",chbox:state(),chbox:check(),"<<")
	-- 	chbox:check( not chbox:check() )
		--rbtn:check( not rbtn:check() )
	end
	
	if id==22 then
		label_text:set_text('btn_2_clicked')
		trbar1:sel_clear()
-- 		print(trbar1:select())
		--print('pos = ',trbar1:get_pos())
	end
	
	if id==33 then
		label_text:set_text('checkbox:'..(chbox:check() and 'on' or 'off').." state="..chbox:state())
	end
	
	if id==34 then
		label_text:set_text('check3box:'..tostring(chbox3:state()))
	end
	
	if id==133 then
		tree_explorer = not tree_explorer
		tree:set_theme(tree_explorer)
		btn3:set_text(tree_explorer and "Tree Normal" or "Tree Explorer")
	end
	
	if id==134 then
		tree_editable = not tree_editable
		tree:set_tree_editable(tree_editable)
		btn4:set_text(tree_editable and "TreeEdit OFF" or "TreeEdit ON")
	end
	
	return true
end)

function panel_test_menu() print('panel ok') end
tab4:context_menu{"Скрыть панель|SideBar_ShowHide"}

----- iconed_list -------
local iconed_list = gui.list(false, false, true) -- singlesel, multiline, iconed
iconed_list:set_iconlib()
tab4:add(iconed_list, "none")
iconed_list:position(20, 315)
iconed_list:size(250, 50)
iconed_list:add_item("iconed_list_item1", nil, 0)
iconed_list:add_item("iconed_list_item2", nil, 2)

--------- updown ---------
--[[
#define UDS_WRAP                0x0001
#define UDS_ALIGNRIGHT          0x0004
#define UDS_ALIGNLEFT           0x0008
#define UDS_AUTOBUDDY           0x0010
#define UDS_ARROWKEYS           0x0020
#define UDS_HORZ                0x0040
#define UDS_NOTHOUSANDS         0x0080
#define UDS_HOTTRACK            0x0100
]]
local style = 0
+0x0020
+0x0008
+0x0080
-- +0x0100
-- +0x0001

local updown = gui.updown(tab4, editbox, style ) --buddy, style
--tab4:add(updown, "none")
-- updown:position(280,105)
-- updown:size(30,30)
updown:set_range(-50,50)
updown:set_current(7)

-------- positioner ---------

local btn3 = gui.button("-><-",333, true)
tab4:add(btn3,'none')
btn3:position(20, 495)
btn3:size(55,30)

local moved_ctrl = btn3
label_text:set_text("mode["..move_modes[move_mode+1].."]")
local step = 1
AddEventHandler("OnKey", function(key, shift, ctrl, alt, char)
	if tab4:bounds() then
		--if key == 32 then move_mode = (move_mode+1)%(#move_modes) print('mode:',move_modes[move_mode]) end
		if move_mode == 0 then return false end
		--print('tab4 onkey', key)
		if move_mode == 1 and key>36 and key<41 then
			local _,_,_,w,h = moved_ctrl:bounds()
			local x,y = moved_ctrl:position()
			if ctrl then -- position
				if key == 38 then y = y - step end
				if key == 40 then y = y + step end
				if y<0 then y = 0 end
				if key == 37 then x = x - step end
				if key == 39 then x = x + step end
				if x<0 then x = 0 end
			elseif alt then -- size
				if key == 38 then h = h - step end
				if key == 40 then h = h + step end
				if h<5 then h = 5 end
				if key == 37 then w = w - step end
				if key == 39 then w = w + step end
			elseif shift then -- step
				if key == 38 then step = step - 5 end
				if key == 40 then step = step + 5 end
				if key == 37 then step = step - 1 end
				if key == 39 then step = step + 1 end
				if step<1 then step = 1 end
				if step>100 then step = 100 end
			end
			moved_ctrl:position(x,y)
			moved_ctrl:size(w,h)
			label_text:set_text(string.format("[ %d : %d ] [ %d : %d ][step = %d]",x,y,w,h, step))
		end
		return true -- true - break event
	end
end)

---------------------------------
return {caption="Test", wnd = tab4, icon_idx = 37}