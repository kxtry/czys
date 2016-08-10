import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Pane {
    id: songList
    padding: 0
    clip:true

    property var musicAll
    property string listName: '所有音乐'

    onMusicAllChanged: {
        listModel.clear();
        for(var id in musicAll){
            var song = musicAll[id];
            if(song instanceof Array){
                for(var i = 0; i < song.length; i++){
                    listModel.append(song[i]);
                }
            }else{
                listModel.append(song);
            }
        }
    }


    ListView {
        clip:true
        anchors.fill: parent
        id:listView
        currentIndex:-1

        model: ListModel{
            id:listModel
        }

        Component {
            id: songDelegate
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
                        text: model.filePath
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
                        if (listView.currentIndex != index) {
                            listView.currentIndex = index;
                            var musics = []
                            for(var i = 0; i < listModel.count; i++){
                                var info = listModel.get(i);
                                var param = {
                                    fileName:info.fileName
                                }
                                var url = encodeURI("file://" +info.filePath+'?param='+JSON.stringify(param));
                                musics.push(url);
                            }
                            //console.log('musics:' + JSON.stringify(musics));
                            g_playMusic.resetPlayList(musics, listName, true);
                            g_playMusic.playIndex(index, 0, true);
                        }
                    }
                }
            }
        }

        delegate: songDelegate
        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
