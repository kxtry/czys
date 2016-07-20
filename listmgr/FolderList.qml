import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Pane {
    id: pane
    padding: 0
    clip:true

    property var musicAll

    signal play(string file, string name)

    onMusicAllChanged: {
        listModel.clear();
        for(var id in musicAll){
            var info ={
                fileName:id.substring(id.lastIndexOf('/')+1),
                filePath:id,
                fileCount:musicAll[id].length
            }
            listModel.append(info);
        }
    }

    Component {
        id: songList
        PopSongList{
        }
    }

    ListView {
        id:listView
        anchors.fill: parent

        model: ListModel{
            id:listModel
        }

        Component {
            id: folderDelegate
            Rectangle {
                width: listView.width
                height: 55
                color:maMouse.pressed ? g_theme.list_accent : g_theme.list_background
                Rectangle{
                    x:0
                    y:0
                    width:parent.width
                    height:1
                    color:g_theme.list_line
                    visible:index === 0 ? true : false
                }
                ColumnLayout{
                    anchors.fill: parent
                    Item{
                        Layout.fillHeight: true
                    }

                    Text {
                        Layout.preferredHeight: 18
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        text: model.fileName
                        font.pixelSize: 15
                        verticalAlignment: Qt.AlignVCenter
                    }

                    Text {
                        Layout.preferredHeight: 12
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        text: '共'+model.fileCount+'首，' + model.filePath
                        font.pixelSize: 10
                        verticalAlignment: Qt.AlignVCenter
                    }
                    Item{
                        Layout.fillHeight: true
                    }
                }
                Rectangle{
                    x:0
                    y:parent.height - 1
                    width:parent.width
                    height:1
                    color:g_theme.list_line
                }
                MouseArea{
                    id:maMouse
                    anchors.fill: parent
                    onClicked: {
                        var songs = pane.musicAll[model.filePath];
                        g_stackView.push(songList, {musicAll:songs, folderName:model.fileName})
                    }
                }
            }
        }
        delegate: folderDelegate
        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
