import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtMultimedia 5.6
import KxFileSearch 1.0
import KxTagParser 1.0
import "../kxmob"

Pane {
    id:musicBar
    padding:0

    readonly property int barHeight: 50
    property alias songName: songName.text
    property alias tbPlay: tbPlay

    signal clicked();

    Material.background: g_theme.musicbar_background
    Material.foreground: g_theme.musicbar_foreground

    Component.onCompleted: {
        g_playMusic.playing.connect(onPlaying);
        g_playMusic.paused.connect(onPaused);
        g_playMusic.stopped.connect(onStopped);
    }

    Component.onDestruction: {
        console.log('onDestruction');
        g_playMusic.playing.disconnect(onPlaying);
        g_playMusic.paused.disconnect(onPaused);
        g_playMusic.stopped.disconnect(onStopped);
    }

    function onPlaying(){
        tbPlay.text = '\ue609';
    }

    function onPaused(){
        tbPlay.text = '\ue607';
    }

    function onStopped(){
        tbPlay.text = '\ue607';
    }

    ColumnLayout{
        z:100
        width:parent.width
        height:barHeight
        spacing: 0
        Rectangle {
            Layout.preferredHeight: 1
            Layout.fillWidth: true
            color:g_theme.musicbar_line

            Rectangle {
                x:0
                y:0
                width: g_playMusic.position / g_playMusic.duration * parent.width
                height:3
                color:g_theme.musicbar_slider
            }
        }

        RowLayout {
            spacing: 5
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.rightMargin: 20

            Label {
                id:songName
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.leftMargin: 10
            }
            ToolButton {
                id:tbPlay
                text:g_playMusic.playbackState === Audio.PlayingState ? "\ue609" : '\ue607'
                font.family: "iconfont"
                font.pixelSize: 24
                onClicked: {
                    if(text === '\ue607'){
                        g_playMusic.play();
                    }else{
                        g_playMusic.pause();
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredHeight: 1
            Layout.fillWidth: true
            color:g_theme.musicbar_line
        }
    }

    MouseArea {
        z:0
        anchors.fill: parent
        onClicked: {
            musicBar.clicked();
        }
    }
}



