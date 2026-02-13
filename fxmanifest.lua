fx_version 'cerulean'
game 'gta5'

author 'Mrk'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/src/style.css',
    'html/src/script.js',
}

server_script {
    'server/*.lua'
}

client_script {
    'client/*.lua'
}

shared_script {
    '@es_extended/imports.lua'
}

dependencies {
    'es_extended',
    'ox_target'
}