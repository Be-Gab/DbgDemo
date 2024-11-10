local app_name = "DbgDemo"
--[[
 ______________________________________________________________________
/   main.lua                                                           \
                DEMO of Tool for widget test and development.          |
                Debug support with messages and variables              |
                show on the TX simulator screen, for Horus TX          |
                                                                       |
 Author:  BeGab                                                        |
 Date:    2024-08-28                                                   |
 Version: 0.8.0                                                        |
 URL : https://github.com/Be-Gab/DbgDemo                               |
                                                                       |
                      Copyright (C) "BeGab"                            |
                                                                       |
_______________________________________________________________________|
 License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html               |
                                                                       |
 This program is free software; you can redistribute it and/or modify  |
 it under the terms of the GNU General Public License version 2 as     |
 published by the Free Software Foundation.                            |
                                                                       |
 This program is distributed in the hope that it will be useful        |
 but WITHOUT ANY WARRANTY; without even the implied warranty of        |
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         |
 GNU General Public License for more details.                          |
\______________________________________________________________________/
]]


local options =	{ 
		{ "WidgetID"	, STRING, "-Dbg ID-" } ,
		{ "SourceID"	, SOURCE, 1  }	,
		{ "ShowWID"		, BOOL  , 0  }
						}

dbg = nil

local function loadDbgOLD(widget)

	if dbg ~= nil then
		return
	end 
	
	-- !!!!
  local chunk, errMsg = loadScript( "/WIDGETS/Dbg/dbg.lua" )()
  
  if errMsg then
    widget.errMsg = errMsg
	 print( "dbg:" ..  errMsg )
  else
    dbg = chunk()
  end
  
end


local function loadDbg()

   print(  "load dbg: Load Start ")  
 
	if dbg ~= nil then
		return dbg
	end 

  local chunk, errMsg = loadScript( "/WIDGETS/Dbg/dbg.lua" )
  
  if errMsg then
    print(  "load dbg: " .. errMsg )  
  else
    dbg = chunk()
  end

   print(  "load dbg: Load End ")  
  
end

local function create(zone, options)
	-- Runs one time when the widget instance is registered
	-- Store zone and options in the widget table for later use

	local widget = {
		zone = zone,
		options = options
	}

	-- Dbg Example ----------------

	loadDbg(widget)
	
	dbg.set( "DBG_COLS" , 2 )		-- default: 1

	m = model.getInfo()
	
	dbg.set( "DBG_COLS" , 2 )		-- default: 1
	dbg.set( "DBG_LOG_SWITCH_ID" , widget.options.SourceID )
	
	dbg.printAssoc( "m:" , m )
	dbg.add( "Model info (table):" , m ) 

	t = { 
			 ["one"]  = 1  ,
			 ["two"] = 2  ,
			 ["last"] = 3   
		 }	

	dbg.printAssoc( "t:" , t )
	dbg.add( "(t) in Create() :" , t ) 
	
	dbg.add( "DBG_COLS:" , dbg.get( "DBG_COLS" ) )
	dbg.log( "DBG_COLS:" , dbg.get( "DBG_COLS" ) )

	dbg.add( "zone.w" , zone.w )
	dbg.add( "zone.h" , zone.h )
	
	dbg.add( "Test String Value" , "ThisString" )
	dbg.add( "Test Numeric Value" , 99.123 )
	dbg.add( "Test Boolean Value" , true )
	dbg.add( "Test Numeric2 Value" , 199.00123 )
	dbg.add( "Test NIL Value" , nil )
	
	
	dbg.printAssoc( "dbg.getT()" , dbg.getT() )
	dbg.printAssoc( "dbg.getTKeys()" , dbg.getTK() )   

	-- dbg.add("123456789012345678901234567890123456789012345678901234567890", 60 )
	-- dbg.add("         1         2         3         4         5         6", 60 )
	
	dbg.log( "widget Create()", "-- END --" )

	-- Dbg Example ---- END -------


	-- Return widget table to EdgeTX
	return widget
end

local function update(widget, options)
	-- Runs if options are changed from the Widget Settings menu
	widget.options = options
	
	dbg.set( "DBG_WIDGET_ID" , widget.options.WidgetID )
	dbg.set( "DBG_LOG_SWITCH_ID" , widget.options.SourceID )
	
	if widget.options.ShowWID == 1 then
		dbg.set( "DBG_WIDGET_ID" , widget.options.WidgetID )
	else
		dbg.set( "DBG_WIDGET_ID" , "" )
	end
	
end

local function background(widget)
	-- Runs periodically only when widget instance is not visible
	
	dbg.add( "Source ID:"	,           widget.options.SourceID ) 
	dbg.add( "Source State:", getValue( widget.options.SourceID ) )
	dbg.add( "Show W ID:"	, widget.options.ShowWID )

	dbg.logDbg( "Switch is ON. SwID: " , widget.options.SourceID )
	
end

local function refresh(widget, event, touchState)
	-- Runs periodically only when widget instance is visible
	-- If full screen, then event is 0 or event value, otherwise nil
	
	background(widget)
	
	lcd.drawText(  0, 0, "WidgetID: " .. widget.options.WidgetID ,MIDSIZE )
	lcd.drawText(  0,20, "Cols    : " .. dbg.get( "DBG_COLS" ), MIDSIZE )

end

return {
  name = app_name,
  create = create,
  refresh = refresh,
  background = background,
  options = options,
  update = update
}