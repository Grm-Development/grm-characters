fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Grm Development'
version '1.0.5'
description 'Grm Characters System'

shared_scripts {'@ox_lib/init.lua','init.lua'}
client_scripts {'escrow/client/*.lua'}
server_scripts {'escrow/server/*.lua'}
escrow_ignore {'open/**/**/*.lua'}

ui_page 'web/index.html'
loadscreen  'web/index.html'
loadscreen_cursor 'yes'
loadscreen_manual_shutdown 'yes'

files {'web/**/*.*','open/**/**/*.lua'}
dependencies {'ox_lib','oxmysql'}
