# DbgDemo

This simple example show
Debug your LUA sript on tx screen in a widget in Companion.  
You can send formatted messages to the "log" window.  

All added information will appear in the widget ordered by name (msg).

![Image](./widget_screen_example.jpg)


See my DbgDemo widget !! -> https://github.com/Be-Gab/Dbg

## Warnings!
The variables added with the add() function do not follow the change in the value of the variables, they only display the value carried at the given point. The variable can be displayed several times with different labels (msg) by adding it to the dbg window at different points in the program.  
Do not use the Dbg widget in a production environment.  
Only use it in the Companion program during development!

## Import into your code
### Install
Download this widget, copy to your sdcard \WIDGET\Dbg directory and take this widget to the screen in Companion.
### The code

Use this codes beginning of your widget under developing.