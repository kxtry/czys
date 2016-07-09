import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import KxDesktopServices 1.0

Page {
    id: pane
    padding: 0
    clip:true

    Component.onCompleted: {
        g_musicBar.visible = false;
    }

    Component.onDestruction: {
        g_musicBar.visible = true;
    }

    ColumnLayout{
        anchors.fill: parent
        spacing:0
        RowLayout{
            Layout.fillWidth: true
            ToolButton {
                id:tbReturn
                text:"\ue61e"
                font.family: "iconfont"
                font.pixelSize: 24
                onClicked: {
                    g_stackView.pop();
                }
            }
            Label{
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                text:'关于...'
                font.pixelSize: 20
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                font.bold: true
            }
            Item{
                Layout.preferredWidth: tbReturn.width
            }
        }
        Rectangle{
            Layout.preferredHeight: 1
            Layout.bottomMargin: 10
            Layout.fillWidth: true
            color:Material.color(Material.Grey)
        }

        Label{
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            wrapMode: Label.WrapAnywhere
            font.pixelSize: 18
            lineHeight:1.5

            Component.onCompleted: {
                var txt = '<br>如果你追求一个纯粹的本地播放器，那你可以试试这个,特别是喜欢听有声书的朋友。'
                txt += '<br>播放器主页：<a href="http://www.kxtry.com/czys">http://www.kxtry.com/czys</a>'
                txt += '<br>有声书主页：<a href="http://www.aixuefo.com">http://www.aixuefo.com</a>'
                text = txt;
            }

            onLinkActivated:{
                console.log(link + " link activated");
                desktopServices.openUrl(link);
            }
        }
    }

    KxDesktopServices{
        id:desktopServices;
    }
}
