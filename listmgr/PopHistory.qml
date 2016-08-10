import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Popup {
    id:dlgPopup
    modal: true
    focus: true
    padding: 0

    margins:30

    property alias placeholderText:nameField.text

    property string playitems

    x:margins
    y:margins
    width:parent.width - margins*2
    height:parent.height - margins*2
    contentWidth: parent.width - margins*2
    contentHeight: parent.height - margins*2

    function hasPlayList(name){
        for(var i = 0; i < historyListModel.count; i++){
            var info = historyListModel.get(i);
            if(info.name === name){
                return true;
            }
        }
        return false;
    }

    onOpened: {
        var idx = listView.currentIndex;
        var items = []
        for(var i = 0; i < g_playMusic.playlist.itemCount; i++){
            var url = g_playMusic.playlist.itemSource(i);
            items.push(url.toString());
        }
        playitems = JSON.stringify(items);
        if(g_settings.history == ''){
            return;
        }
        historyListModel.clear();
        var history = JSON.parse(g_settings.history);
        for(i = 0; i < history.length; i++){
            var info = history[i];
            console.log(JSON.stringify(info));
            historyListModel.append(info)
        }
        listView.currentIndex = idx;
    }

    onClosed: {
        var musics = [];
        for(var i = 0; i < historyListModel.count; i++){
            var info = historyListModel.get(i);
            musics.push(info);
        }
        g_settings.history = JSON.stringify(musics);
    }

    background: Rectangle{
        color:g_theme.themeColor
        radius: 5
        Rectangle{
            anchors.fill: parent
            color:g_theme.alphaLv4
            radius: 5
        }
    }

    contentItem:ColumnLayout{
        spacing:0
        Label{
            Layout.preferredHeight: 30
            Layout.fillWidth: true
            padding:5
            verticalAlignment: Label.AlignVCenter
            font.pixelSize: 12
            text: '历史快照'
            clip:true


            Rectangle{
                x:0
                y:parent.height - 1
                width:parent.width
                height:1
                color:Material.color(Material.Grey)
            }
        }
        ListView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip:true
            currentIndex: -1

            boundsBehavior: Flickable.StopAtBounds

            id:listView

            model: ListModel{
                id:historyListModel
            }

            Component {
                id: historyDelegate
                Rectangle {
                    width: listView.width
                    height: 45
                    color:listView.currentIndex === index ? g_theme.list_accent : g_theme.list_background
                    Rectangle{
                        x:0
                        y:0
                        width:parent.width
                        height:1
                        color:g_theme.list_line
                        visible:index === 0 ? true : false
                    }
                    RowLayout{
                        anchors.fill: parent
                        z:10
                        Text {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.leftMargin: 10
                            text: model.name
                            font.pixelSize: 15
                            verticalAlignment: Qt.AlignVCenter
                        }
                        Label{
                            Layout.fillHeight: true
                            Layout.preferredWidth: 50
                            text: '\ue612'
                            font.pixelSize: 15
                            font.family: 'iconfont'
                            verticalAlignment: Label.AlignVCenter
                            horizontalAlignment: Label.AlignHCenter

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    historyListModel.remove(index, 1);
                                }
                            }
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
                            if(listView.currentIndex !== index){
                                listView.currentIndex = index;
                            }
                        }
                    }
                }
            }

            delegate: historyDelegate
            ScrollIndicator.vertical: ScrollIndicator { }
        }
        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color:Material.color(Material.Grey)
        }

        RowLayout{
            Layout.preferredHeight: 50
            Layout.fillWidth: true
            spacing: 0
            TextField {
                id:nameField
                Layout.leftMargin: 5
                Layout.fillWidth: true
            }
            ToolButton{
                text:'新增'
                onClicked: {
                    var name = nameField.text;
                    if(hasPlayList(name)){
                        ToolTip.show('名字已经存在，请重新命名', 1500);
                        return;
                    }
                    var playidx = g_playMusic.playlist.currentIndex;
                    var iseek = g_playMusic.position;
                    historyListModel.append({
                                                name:name,
                                                items:playitems,
                                                seekpos:iseek,
                                                playidx:playidx
                                            });
                }
            }
            ToolButton{
                text:'更新'
                onClicked: {
                    var name = nameField.text;
                    for(var i = 0; i < historyListModel.count; i++){
                        var info = historyListModel.get(i);
                        if(info.name === name){
                            var playidx = g_playMusic.playlist.currentIndex;
                            var iseek = g_playMusic.position;
                            info.items = playitems;
                            info.seekpos = iseek;
                            info.playidx = playidx;
                            ToolTip.show('已经更新', 1500);
                            return;
                        }
                    }
                    ToolTip.show('没有更新的对象', 1500);
                }
            }
            ToolButton{
                text:'加载'
                onClicked: {
                    if(listView.currentIndex < 0){
                        ToolTip.show('没有选择目标对象', 1500);
                        return;
                    }

                    var info = historyListModel.get(listView.currentIndex);
                    g_playMusic.resetPlayList(JSON.parse(info.items), info.name, true);
                    g_playMusic.playIndex(info.playidx, info.seekpos, false);
                    dlgPopup.close();
                }
            }
            ToolButton{
                Layout.rightMargin: 5
                text:'退出'
                onClicked: {
                    dlgPopup.close()
                }
            }
        }
    }
}
