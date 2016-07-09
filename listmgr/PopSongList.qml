import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Page {
    id: pane
    padding: 0
    clip:true

    property alias musicAll:mylist.musicAll
    property string folderName

    header: ToolBar {
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
                id: titleLabel
                text: folderName
                font.pixelSize: 20
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

    SongList{
        id:mylist
        listName:folderName
        anchors.fill: parent
        anchors.bottomMargin: g_musicBar.barHeight
    }
}
