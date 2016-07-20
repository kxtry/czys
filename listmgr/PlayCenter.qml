import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtMultimedia 5.6

Page {
    id: playCenter
    padding: 0
    clip:true

    Material.background: g_theme.themeColor

    Component.onCompleted: {
        g_musicBar.visible = false;
        resetListModel();
        g_playMusic.playlistChanged.connect(onPlaylistChanged);
    }

    Component.onDestruction: {
        g_musicBar.visible = true;
        g_playMusic.playlistChanged.disconnect(onPlaylistChanged);
        dlgHistory.close();
    }

    function onPlaylistChanged(){
        resetListModel();
    }

    function resetListModel(){
        listModel.clear();
        for(var i = 0; i < g_playMusic.playlist.itemCount; i++){
            var url = decodeURI(g_playMusic.playlist.itemSource(i));
            var filePath = url.substring(7);
            var fileName = 'unknow name';
            var iparam = url.lastIndexOf('param=');
            if(iparam > 0){
                var param = url.substring(iparam+6);
                param = JSON.parse(param);
                fileName = param.fileName;
                filePath = url.substring(7, iparam);
            }
            listModel.append({fileName:fileName,filePath:filePath});
        }
    }

    PopHistory{
        id:dlgHistory
        placeholderText: g_playMusic.listname
    }

    Rectangle {
        x:0
        y:0
        width:parent.width
        height:g_theme.topbar_height
        color:g_theme.topbar_background

        Material.foreground: g_theme.topbar_foreground

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                id:downArrow
                text:"\ue62d"
                font.family: "iconfont"
                font.pixelSize: 24
                onClicked: {
                    g_stackView.pop()
                }
            }

            Label {
                text: g_playMusic.listname
                font.pixelSize: 20
                font.bold: true
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            Item{
                width:downArrow.width
            }
        }
    }
    Pane{
        padding: 0
        anchors.topMargin: g_theme.topbar_height
        anchors.fill: parent

        Material.background: g_theme.alphaLv4

        ColumnLayout{
            anchors.fill: parent
            spacing: 0
            ListView {
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip:true

                id:listView

                model: ListModel{
                    id:listModel
                }

                Component {
                    id: songDelegate
                    Rectangle {
                        width: listView.width
                        height: 35
                        color:maMouse.pressed ? g_theme.list_accent : g_theme.list_background
                        Rectangle{
                            x:0
                            y:0
                            z:1
                            width:parent.width
                            height:1
                            color:g_theme.list_line
                            visible:index === 0 ? true : false
                        }
                        Text {
                            x:0
                            y:0
                            z:0
                            width:parent.width
                            height:parent.height
                            leftPadding: 10
                            rightPadding: 10
                            text: model.fileName
                            font.pixelSize: 15
                            verticalAlignment: Qt.AlignVCenter
                        }
                        Text {
                            x:parent.width - 30
                            y:0
                            z:1
                            width:parent.width
                            height:parent.height
                            verticalAlignment: Qt.AlignVCenter
                            text:'\ue623'
                            color:Material.color(Material.Pink)
                            font.family: "iconfont"
                            font.pixelSize: 20
                            visible: g_playMusic.playlist.currentIndex === index
                        }

                        Rectangle{
                            x:0
                            y:parent.height - 1
                            z:1
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
                                    g_playMusic.playIndex(index, 0, true);
                                }
                            }
                        }
                    }
                }

                delegate: songDelegate
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            ColumnLayout{
                Layout.fillWidth: true
                Layout.bottomMargin: 20
                spacing: 10



                Rectangle{
                    Layout.preferredHeight: 1
                    Layout.fillWidth: true
                    color:Material.color(Material.Grey)
                }
                Slider {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    orientation: Qt.Horizontal

                    property int iseek: g_playMusic.position
                    property int duration: g_playMusic.duration

                    onIseekChanged: {
                        if(!pressed){
                            value = iseek / duration;
                        }
                    }

                    onDurationChanged: {
                        if(!pressed){
                            value = iseek / duration;
                        }
                    }

                    onValueChanged: {
                        if(pressed){
                            g_playMusic.seek(g_playMusic.duration * value);
                        }
                    }

                    Label{
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.top: parent.top
                        text:'00:00/00:00'

                        property int durationH:g_playMusic.duration / 1000 / 3600
                        property int durationM:(g_playMusic.duration / 1000 % 3600) / 60
                        property int durationS:g_playMusic.duration / 1000 % 60
                        property int position:g_playMusic.position
                        property int duration: g_playMusic.duration
                        onDurationChanged: {
                            refresh();
                        }

                        onPositionChanged: {
                            refresh();
                        }

                        function refresh(){
                            var dh = durationH < 9 ? '0'+durationH : durationH;
                            var dm = durationM < 9 ? '0'+durationM : durationM;
                            var ds = durationS < 9 ? '0'+durationS : durationS;
                            var h = parseInt(g_playMusic.position / 1000 / 3600);
                            var m = parseInt((g_playMusic.position / 1000 % 3600) / 60);
                            var s = parseInt(g_playMusic.position / 1000 % 60);
                            if(h < 9){
                                h = '0' + h;
                            }
                            if(m < 9){
                                m = '0' + m;
                            }
                            if(s < 9){
                                s = '0' + s;
                            }

                            if(durationH > 0){
                                text = h+':'+m+':'+s+'/'+dh+':'+dm+':'+ds;
                            }else{
                                text = m+':'+s+'/'+dm+':'+ds;
                            }
                        }
                    }
                }
                RowLayout{
                    Layout.fillWidth: true
                    spacing: 20

                    Component.onCompleted: {
                        g_playMusic.playing.connect(onPlaying);
                        g_playMusic.paused.connect(onPaused);
                        g_playMusic.stopped.connect(onStopped);
                    }

                    Component.onDestruction: {
                        g_playMusic.playing.disconnect(onPlaying);
                        g_playMusic.paused.disconnect(onPaused);
                        g_playMusic.stopped.disconnect(onStopped);
                    }

                    function onPlaying(){
                        tbPlay.text = '\ue609';
                        console.log('playing');
                    }

                    function onPaused(){
                        tbPlay.text = '\ue607';
                        console.log('paused');
                    }

                    function onStopped(){
                        tbPlay.text = '\ue607';
                        console.log('stopped');
                    }

                    ToolButton {
                        id:tbHistory
                        text:"\ue656"
                        font.family: "iconfont"
                        font.pixelSize: 30
                        onClicked: {
                            dlgHistory.open();
                        }
                    }

                    Item{
                        Layout.fillWidth: true
                    }

                    ToolButton {
                        id:tbPrev
                        text:"\ue615"
                        font.family: "iconfont"
                        font.pixelSize: 30
                        onClicked: {
                            g_playMusic.playlist.previous();
                        }
                    }
                    ToolButton {
                        id:tbPlay
                        text:g_playMusic.playbackState === Audio.PlayingState ? "\ue609" : '\ue607'
                        font.family: "iconfont"
                        font.pixelSize: 45
                        onClicked: {
                            if(text === '\ue607'){
                                g_playMusic.play();
                            }else{
                                g_playMusic.pause();
                            }
                        }
                    }
                    ToolButton {
                        id:tbNext
                        text:"\ue614"
                        font.family: "iconfont"
                        font.pixelSize: 30
                        onClicked: {
                            g_playMusic.playlist.next();
                        }
                    }

                    Item{
                        Layout.preferredWidth: tbHistory.width
                    }

                    Item{
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
