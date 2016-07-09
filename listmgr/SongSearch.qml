import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import KxFileSearch 1.0
import KxTagParser 1.0
import "../kxmob"

Page {
    id:songSearch

    property StackView stackView
    property variant songDict
    property int songCount: 0

    signal result(variant songs);

    Component.onCompleted: {
        songDict = {}
        songCount = 0;
        g_musicBar.visible = false;
        try{
            console.log('searchPath:'+g_settings.searchPath)
            var paths = JSON.parse(g_settings.searchPath);
            if(paths instanceof Array){
                for(var id in paths){
                    var folder = {filePath:paths[id]};
                    folderListModel.append(folder);
                }
            }
        }catch(e){

        }
    }

    Component.onDestruction: {
        g_musicBar.visible = true;
    }

    KxMessageBox {
        id:msgbox
        title:'提示'
        content:'是否把当前的搜索结果替代当前所有列表。'
        okText:'确定'
        cancelText: '取消'


        onResult:{
            if(val === 1){
                songSearch.result(songSearch.songDict)
            }
            g_stackView.pop()
        }
    }

    KxFileDialog{
        id: fileDialog
        showFiles: false

        onDone: {
            for(var i = 0; i < folderListModel.count; i++){
                var folder = folderListModel.get(i);
                if(folder.filePath === path){
                    return;
                }
            }
            folderListModel.append({filePath:path})
        }
    }

    contentItem:ColumnLayout{
        spacing: 20

        ToolBar {
            Layout.fillWidth: true
            RowLayout {
                spacing: 20
                anchors.fill: parent

                ToolButton {
                    id:leftArrow
                    text: "\ue62d"
                    font.family: "iconfont"
                    font.pixelSize: 24
                    onClicked:{
                        if(songSearch.songCount > 0){
                            msgbox.open()
                        }else{
                            g_stackView.pop()
                        }
                    }
                }

                Label {
                    id: titleLabel
                    text: '歌曲搜索'
                    font.pixelSize: 20
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

                    Menu {
                        id: optionsMenu
                        x: parent.width - width
                        transformOrigin: Menu.TopRight
                        MenuItem {
                            text: '添加搜索目录'
                            onTriggered: {
                                fileDialog.open();
                            }
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Label {
                anchors.fill: parent
                verticalAlignment: Label.AlignVCenter
                horizontalAlignment: Label.AlignHCenter
                text:'请右上角菜单，指定搜索路径。'
                visible: folderListModel.count > 0 ? false : true
            }

            ColumnLayout{
                anchors.fill: parent
                visible: folderListModel.count > 0 ? true : false
                ListView {
                    id:listView
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    clip:true

                    model: ListModel{
                        id: folderListModel
                    }

                    Component {
                        id: folderDelegate
                        Rectangle {
                            width: listView.width
                            height: 45
                            color:maMouse.pressed ? "#D3D3D3" : Material.background
                            Rectangle{
                                x:0
                                y:0
                                width:parent.width
                                height:1
                                color:Material.color(Material.Grey)
                                visible:index === 0 ? true : false
                            }
                            RowLayout{
                                anchors.fill: parent
                                z:10
                                Text {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    Layout.leftMargin: 10
                                    text: model.filePath
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
                                            folderListModel.remove(index, 1);
                                        }
                                    }
                                }
                            }
                            Rectangle{
                                x:0
                                y:parent.height - 1
                                width:parent.width
                                height:1
                                color:Material.color(Material.Grey)
                            }
                            MouseArea{
                                id:maMouse
                                anchors.fill: parent
                                onClicked: {

                                }
                            }
                        }
                    }
                    delegate: folderDelegate
                    ScrollIndicator.vertical: ScrollIndicator { }
                }


                RowLayout{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    Layout.maximumHeight: 30
                    BusyIndicator {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 30
                        padding: 7
                        id: busySearch
                        visible:false
                    }
                    Label {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        leftPadding: 5
                        rightPadding: 5
                        verticalAlignment: Label.AlignVCenter
                        id:filePath
                        elide:Text.ElideLeft
                        font.pixelSize: 12
                    }
                }

                Label {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20
                    wrapMode: Label.Wrap
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: 18
                    text: songSearch.songCount
                }
                RowLayout{
                    Layout.preferredHeight: 50
                    Layout.bottomMargin: 30

                    Item{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                    }

                    Button{
                        id: btnSearch
                        text:qsTr("Search")
                        visible: true
                        Layout.preferredHeight: 50
                        onClicked: {
                            var paths = [];
                            songSearch.songDict = {};
                            songSearch.songCount = 0;
                            for(var i = 0; i < folderListModel.count; i++){
                                var folder = folderListModel.get(i);
                                fileSearch.search(folder.filePath);
                                paths.push(folder.filePath);
                            }
                            g_settings.searchPath = JSON.stringify(paths);
                            console.log('paths:'+g_settings.searchPath);
                        }
                    }

                    Button{
                        id: btnPause
                        text:qsTr("Pause")
                        visible: false
                        Layout.preferredHeight: 50
                        onClicked: {
                            fileSearch.pause();
                        }
                    }

                    Button{
                        id: btnResume
                        text:qsTr("Resume")
                        visible: false
                        Layout.preferredHeight: 50
                        onClicked: {
                            fileSearch.resume();
                        }
                    }

                    Button{
                        id:btnStop
                        text:qsTr("Stop")
                        visible: false
                        Layout.preferredHeight: 50
                        onClicked: {
                            fileSearch.stop();
                        }
                    }
                    Item{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                    }

                }
            }
        }

    }

    KxTagParser {
        id: tagParser
    }

    KxFileSearch {
        id: fileSearch

        onStatusChanged: {
            console.log(state)
            switch(state){
            case "start":
                busySearch.visible = false
                btnSearch.visible = false
                btnPause.visible = true
                btnResume.visible = false
                btnStop.visible = true
                break;
            case "pause":
                busySearch.visible = false
                btnSearch.visible = false
                btnPause.visible = false
                btnResume.visible = true
                btnStop.visible = true
                break;
            case "stop":
                busySearch.visible = true
                btnSearch.visible = true
                btnPause.visible = false
                btnResume.visible = false
                btnStop.visible = false
                break;
            }

            if(state === "start"){
                busySearch.visible = true
            }else{
                busySearch.visible = false
            }

        }

        onSearchResult: {
            filePath.text = file
            if(isDir){
                fileSearch.search(file)
            }else{
                var exts = [".mp3", ".wma", ".ogg"];
                for(var i = 0; i < exts.length; i++) {
                    var ext = exts[i];
                    var hit = file.substring(file.length - ext.length).toLowerCase()
                    if(hit === ext) {
                        songSearch.songCount++;
                        var tag = tagParser.get(file);
                        var info = {
                            "filePath":file,
                            "fileName":file.substring(file.lastIndexOf('/')+1, file.length - ext.length),
                            "tag":tag
                        }
                        if(typeof(songSearch.songDict[folder]) === 'undefined'){
                            songSearch.songDict[folder] = [];
                        }
                        songSearch.songDict[folder].push(info);
                    }
                }
            }
        }
    }
}



