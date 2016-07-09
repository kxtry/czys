import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import Qt.labs.folderlistmodel 2.1


Pane {
    id:filePage
    padding: 0

    property bool reinit: false
    property bool showFiles : true
    property bool folderAutoEnter : false

    signal done(string path)

    onVisibleChanged: {
        if(reinit){
            if ( filePage.visible ){
                stackView.replace(page)
            }else{
                stackView.clear()
            }
        }
    }

    StackView {
        id:stackView
        anchors.fill: parent
        initialItem: page
        visible:filePage.visible

        Component{
            id: page

            Page {
                id: panel
                property string path: "file:///"

                header: ToolBar {
                    height:30
                    Label{
                        anchors.fill: parent
                        padding:5
                        verticalAlignment: Label.AlignVCenter
                        font.pixelSize: 12
                        text: panel.path.substring(Math.max(7, panel.path.length - 50))
                    }
                }

                contentItem:ListView {
                    id: listView
                    currentIndex: -1
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: FolderListModel {
                        Component.onCompleted:{
                            showFiles = filePage.showFiles
                        }

                        folder: panel.path
                        id: folderModel
                    }

                    delegate: ItemDelegate {
                        width: listView.width
                        text: model.fileName
                        ColumnLayout{
                            anchors.fill: parent
                            Rectangle{
                                Layout.fillWidth: true
                                Layout.preferredHeight: 1
                                color:Material.foreground
                                visible:index === 0 ? true : false
                            }
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                            Rectangle{
                                Layout.fillWidth: true
                                Layout.preferredHeight: 1
                                color:Material.foreground
                            }
                        }

                        highlighted: ListView.isCurrentItem
                        onClicked: {
                            if (listView.currentIndex != index) {
                                listView.currentIndex = index
                                if(fileIsDir && filePage.folderAutoEnter){
                                    stackView.replace(page, {"path":fileURL})
                                }
                            }
                        }
                    }
                    ScrollIndicator.vertical: ScrollIndicator { }
                }


                footer: ToolBar {
                    RowLayout {
                        spacing: 5
                        anchors.fill: parent

                        ToolButton {
                            enabled: panel.path === "file:///" ? false : true
                            text: "Return"
                            onClicked: {
                                var path = panel.path
                                var i = path.lastIndexOf('/');
                                if ( i <= 8 ) {
                                    path = "file:///";
                                }else{
                                    path = path.substring(0, i);
                                }
                                stackView.replace(page, {"path":path})
                            }
                        }

                        ToolButton {
                            text: "Enter"
                            onClicked: {
                                var fileIsDir = listView.model.isFolder(listView.currentIndex);
                                if(fileIsDir){
                                    console.log('index:'+listView.currentIndex)
                                    var fileURL = listView.model.get(listView.currentIndex, 'fileURL');
                                    console.log('fileURL:'+fileURL)
                                    stackView.replace(page, {"path":fileURL})
                                }
                            }
                        }

                        ToolButton {
                            text: "Select"
                            onClicked: {
                                if(listView.currentIndex < 0){
                                    return
                                }
                                var selectPath = listView.model.get(listView.currentIndex, 'fileURL');
                                filePage.done(selectPath)
                            }
                        }

                        ToolButton {
                            text: "Cancel"
                            onClicked: {
                                filePage.done("")
                            }
                        }
                        Item{
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
                                    text: "Settings"
                                    onTriggered: {

                                    }
                                }
                                MenuItem {
                                    text: "filePage"
                                    onTriggered: {

                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


