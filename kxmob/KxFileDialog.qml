import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import KxFileSearch 1.0

Popup {
    id:dlgFile
    modal: true
    focus: true
    padding: 0

    margins:30

    x:margins
    y:margins
    width:parent.width - margins*2
    height:parent.height - margins*2
    contentWidth: parent.width - margins*2
    contentHeight: parent.height - margins*2

    property bool reinit: false
    property bool showFiles : true
    property bool folderAutoEnter : false

    signal done(string path);

    Material.background: g_theme.themeColor

    onVisibleChanged: {
        if(visible && reinit){
            stackView.replace(fileComponent, {"path":'/'})
        }
    }

    Component{
        id: fileComponent

        ColumnLayout {
            id: panel
            spacing: 0
            property string path: "/"
            property string pathsel:''

            Label{
                Layout.preferredHeight: 30
                Layout.fillWidth: true
                padding:5
                verticalAlignment: Label.AlignVCenter
                font.pixelSize: 12
                text: panel.path
                clip:true

                Rectangle{
                    x:0
                    y:parent.height - 1
                    width:parent.width
                    height:1
                    color:Material.color(Material.Grey)
                }
            }

            KxFileSearch {
                id: fileSearch
            }

            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: -1
                clip:true

                model: ListModel{
                    id:fileListModel

                    Component.onCompleted: {
                        fileSearch.searchResult.connect(onSearchResult);
                        fileSearch.statusChanged.connect(onStatusChanged);
                        fileSearch.search(panel.path);
                    }

                    function onSearchResult(path, file, isDir){
                        if(!dlgFile.showFiles && !isDir){
                            return;
                        }
                        var i = file.lastIndexOf('/');
                        var name = file.substring(i+1);
                        var info ={
                            fileName:name,
                            filePath:file,
                            isDir:isDir
                        }

                        fileListModel.append(info);
                        if(file === panel.pathsel){
                            listView.currentIndex = fileListModel.count - 1
                        }
                    }

                    function onStatusChanged(){
                        if(fileSearch.state === 'stop'){
                            listView.positionViewAtIndex(listView.currentIndex, ListView.Visible)
                        }
                    }
                }

                delegate: Rectangle {
                    width: listView.width
                    color: listView.currentIndex === index ? g_theme.list_accent : g_theme.list_background
                    height: 40
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
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        spacing: 0

                        Label{
                            Layout.preferredWidth: 20
                            text: model.isDir ? "\ue61b" : ''
                            font.family: "iconfont"
                            font.pixelSize: 18
                        }
                        Label{
                            Layout.fillWidth: true
                            horizontalAlignment: Label.Left
                            text:model.fileName
                        }
                    }
                    Rectangle{
                        x:0
                        y:parent.height - 1
                        width:listView.width
                        height:1
                        color:g_theme.list_line
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if (listView.currentIndex != index) {
                                listView.currentIndex = index
                                if(model.isDir && dlgFile.folderAutoEnter){
                                    stackView.replace(fileComponent, {"path":model.filePath})
                                }
                            }
                        }
                    }
                }
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            Rectangle{
                Layout.preferredHeight: 1
                Layout.fillWidth: true
                color:Material.color(Material.Grey)
            }

            RowLayout {
                spacing: 5
                Layout.preferredHeight: 50
                Layout.fillWidth: true
                ToolButton {
                    enabled: panel.path === "/" ? false : true
                    text: "\ue640"
                    font.family: "iconfont"
                    font.pixelSize: 24
                    onClicked: {
                        var path = panel.path
                        var i = path.lastIndexOf('/');
                        if ( i <= 0 ) {
                            path = "/";
                        }else{
                            path = path.substring(0, i);
                        }
                        stackView.replace(fileComponent, {"path":path, 'pathsel':panel.path})
                    }
                }

                ToolButton {
                    text: "\ue63f"
                    font.family: "iconfont"
                    visible: !dlgFile.folderAutoEnter
                    font.pixelSize: 24
                    onClicked: {
                        if(listView.currentIndex < 0){
                            //ToolTip容易出BUG
                            //ToolTip.show('必须选择一个目录或文件', 1500);
                            return
                        }
                        var info = listView.model.get(listView.currentIndex);
                        if(info.isDir){
                            stackView.replace(fileComponent, {"path":info.filePath})
                        }
                    }
                }

                ToolButton {
                    text: "\ue645"
                    font.family: "iconfont"
                    font.pixelSize: 24
                    onClicked: {
                        if(listView.currentIndex < 0){
                            //ToolTip容易出BUG
                            //ToolTip.show('必须选择一个目录或文件', 1500);
                            return
                        }
                        var info = listView.model.get(listView.currentIndex);
                        dlgFile.done(info.filePath);
                        dlgFile.close();
                    }
                }

                ToolButton {
                    text: "\ue628"
                    font.family: "iconfont"
                    font.pixelSize: 24
                    onClicked: {
                        dlgFile.close();
                    }
                }
            }
        }
    }

    contentItem:StackView {
        id:stackView
        anchors.fill: parent
        initialItem: fileComponent

//        Material.background: g_theme.alphaLv1

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
}


