import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtMultimedia 5.6
import Qt.labs.settings 1.0
import KxBluetooth 1.0
import "kxmob"
import "listmgr"

ApplicationWindow {
    id: g_window
    visible: true
    width: 360
    height: 520

    property bool exitApp:false

    Settings {
        id: g_settings
        property string musicAll
        property string playlist
        property int playidx: 0
        property int seekpos: 0

        property string history

        property string searchPath
    }

    Component.onCompleted: {

    }

    StackView{
        id:g_stackView
        anchors.fill: parent
        initialItem: ListManager{
        }

        pushEnter: Transition {
        }

        pushExit: Transition {
        }

        popEnter: Transition {
        }

        popExit: Transition {
        }

        replaceEnter: Transition {
        }

        replaceExit: Transition {
        }
    }

    Audio {
        id: g_playMusic

        property string listname:''

        signal playlistChanged();

        Component.onCompleted: {
            var list = JSON.parse(g_settings.playlist);
            if(list.items.length > 0){
                resetPlayList(list.items, list.name);
                playIndex(g_settings.playidx, g_settings.seekpos, false)
            }
        }

        function resetPlayList(items, name){
            var pltxt = JSON.stringify({name:name, items:items});
            if(g_settings.playlist !== pltxt){
                g_settings.playlist = pltxt;
            }

            var urls = [];
            for(var i = 0; i < playlist.itemCount; i++){
                urls.push(playlist.itemSource(i));
            }
            if(JSON.stringify({name:name, items:urls}) === pltxt){
                return;
            }
            playlist.clear();
            listname = name;
            for(i = 0; i < items.length; i++){
                var url = items[i];
                playlist.addItem(url);
            }
            g_playMusic.playlistChanged();
        }

        function playIndex(idx, iseek, bplay){
            console.log('idx:'+idx+',iseek:'+iseek+',on:'+bplay);
            playlist.currentIndex = idx;
            if(iseek > 0){
                seek(iseek);
            }
            if(bplay){
                play();
            }else{
                pause();
            }
        }

        playlist: Playlist{
            onCurrentIndexChanged: {
                var url = decodeURI(currentItemSource);
                console.log('url:'+url);
                var i = url.lastIndexOf('param=');
                if(i < 0){
                    g_musicBar.songName = 'unknow name';
                }else{
                    var param = url.substring(i+6);
                    param = JSON.parse(param);
                    g_musicBar.songName = param.fileName;
                }
                g_settings.playidx = currentIndex;
                g_settings.seekpos = 0;
            }
        }

        onPositionChanged: {
            if(Math.abs(g_settings.seekpos - position) > 1000*10){
                g_settings.seekpos = position;
            }
        }
    }

    Component {
        id:playCenter
        PlayCenter{
        }
    }

    MusicBar{
        id:g_musicBar
        x:0
        y:g_window.height-barHeight
        z:100
        width:g_window.width
        height:50

        onClicked: {
            g_stackView.push(playCenter);
        }
    }

    KxBluetooth{
        onConnected:{
            console.log('device.connect:'+device);
        }

        onDisconnected:{
            console.log('device.disconnect:'+device);
            g_playMusic.pause();
        }
    }

    KxMessageBox{
        id:dlg
        title:'提示'
        content:'是否继续退出'
        okText:'继续退出'
        cancelText: '放弃'

        onResult:{
            if(val === 1){
                g_window.exitApp = true;
                //g_window.close();
                Qt.quit();
            }
        }
    }

    onClosing:{
        if(g_stackView.depth > 1){
            g_stackView.pop();
            close.accepted = false;
        }else{
            close.accepted = g_window.exitApp;
            console.log('exitApp:'+g_window.exitApp);
            if(!close.accepted){
                dlg.open();
            }
        }
    }
}
