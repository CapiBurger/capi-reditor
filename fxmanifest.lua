fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'capi3d-reditor'
author 'capi3d'
description 'ROCKSTAR EDTIOR MENU by capi3d'
version '1.0.0'

client_scripts {
  "lua/*.lua"
}

shared_scripts {
  'config.lua'
}

ui_page 'html/index.html'

files {
  'html/*.html',
  'html/css/*.css',
  'html/js/*.js',
  'html/fonts/*.ttf',
  'html/img/png/*.png',
  'html/img/jpg/*.jpg',

  'html/sounds/*.mp3',
  'html/sounds/*.wav',
  'html/sounds/*.ogg',
}
