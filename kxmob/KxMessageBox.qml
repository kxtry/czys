import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

Popup {
    id: msgbox

    property string title
    property string content
    property alias okText: okButton.text
    property alias cancelText: cancelButton.text
    modal: true
    focus: true

    signal result(int val)

    Component.onCompleted: {
        width = Math.min(g_window.width, g_window.height) / 3 * 2
        height = msgColumn.implicitHeight + topPadding + bottomPadding
        x = (g_window.width - width - leftPadding - rightPadding) / 2;
        y = (g_window.height - height - topPadding - bottomPadding) / 2;
        contentWidth = width;
        contentHeight = height;
        console.log('width:'+width+',height:'+height)
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

    contentItem: ColumnLayout {
        id: msgColumn
        spacing: 20

        Material.background:g_theme.themeColor
        Label {
            text: title
            font.bold: true
        }

        Label {
            text: content
            wrapMode: Label.WrapAnywhere
            verticalAlignment: Label.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        RowLayout {
            spacing: 10

            Material.background:g_theme.themeColor
            Button {
                id: okButton
                text: qsTr("Ok")
                onClicked: {
                    msgbox.close()
                    msgbox.result(1)
                }
                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }

            Button {
                id: cancelButton
                text: qsTr("Cancel")
                onClicked: {
                    msgbox.close()
                    msgbox.result(0)
                }
                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }
        }
    }
}
