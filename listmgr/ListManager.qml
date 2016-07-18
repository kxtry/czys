import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import Qt.labs.settings 1.0
import "./../kxmob"

Page {
    id: g_listmgr
    padding: 0
    focus: true

    property var musicAll

    Material.background: g_theme.themeColor

    Component.onCompleted: {
        g_listmgr.musicAll = JSON.parse(g_settings.musicAll);
    }

    header: Rectangle {
        width:parent.width
        height:g_theme.topbar_height
        color:g_theme.topbar_background

        Material.foreground: g_theme.topbar_foreground
        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                text:"\ue662"
                font.family: "iconfont"
                font.pixelSize: 24
                onClicked: {
                    g_stackView.push('qrc:/listmgr/AboutPlayer.qml');
                }
            }

            Label {
                id: titleLabel
                text: '纯真有声'
                font.pixelSize: 20
                font.bold: true
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                text:"\ue60b"
                font.family: "iconfont"
                font.pixelSize: 24
                onClicked: {
                    optionsMenu.open()
                }

                KxMenu {
                    id: optionsMenu
                    x: parent.width - width
                    y: g_theme.topbar_height-1

                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: '清空列表'
                        onTriggered: {
                            g_settings.musicAll = '';
                            songList.musicAll = {};
                            folderList.musicAll = {};
                        }
                    }
                    MenuItem {
                        text: qsTr("SongSearch")
                        onTriggered: g_stackView.push(songSearch)
                    }
                    MenuItem {
                        text: '退出'
                        onTriggered: {
                            g_window.close();
                        }
                    }
                }
            }
        }
    }

    Component {
        id: songSearch
        SongSearch {
            onResult:{
                g_listmgr.musicAll = songs;
                var temp = JSON.stringify(songs);
                if(g_settings.musicAll !== temp){
                    g_settings.musicAll = temp;
                }
                songList.musicAll = songs;
                folderList.musicAll = songs;
            }
        }
    }

    Pane{
        padding: 0
        anchors.fill: parent

        Material.background: g_theme.alphaLv5

        TabBar {
            id: tabBar
            width: parent.width
            anchors.top: parent.top
            currentIndex: swipeView.currentIndex

            Material.accent: g_theme.tabbar_accent
            Material.foreground: g_theme.tabbar_foreground
            Material.background: g_theme.tabbar_background

            background: Rectangle {
                color:g_theme.alphaLv3
                Rectangle{
                    x:0
                    y:parent.height - 1
                    width:parent.width
                    height:1
                    color: g_theme.tabbar_line
                }
            }

            TabButton {
                text: qsTr("\ue620Song")
                font.family: "iconfont"
                font.pixelSize: 16
                font.bold: checked ? true : false
            }

            TabButton {
                text: qsTr("\ue61bFolder")
                font.family: "iconfont"
                font.pixelSize: 16
                font.bold: checked ? true : false
            }
        }

        SwipeView {
            id: swipeView
            anchors.fill: parent
            anchors.topMargin: tabBar.height
            anchors.bottomMargin: g_musicBar.barHeight
            currentIndex: tabBar.currentIndex

            Material.background: g_theme.alphaLv2

            SongList{
                id:songList
                width: swipeView.width
                height: swipeView.height

                Component.onCompleted: {
                    musicAll = g_listmgr.musicAll;
                }
            }

            FolderList{
                id:folderList
                width: swipeView.width
                height: swipeView.height

                Component.onCompleted: {
                    musicAll = g_listmgr.musicAll;
                }
            }
        }
    }
}

