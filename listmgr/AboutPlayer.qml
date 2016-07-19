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

    Material.background: g_theme.themeColor

    header: Rectangle{
        width:parent.width
        height:g_theme.topbar_height
        color:g_theme.topbar_background

        Material.foreground: g_theme.topbar_foreground
        RowLayout{
            anchors.fill: parent
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
                text:'关于'
                font.pixelSize: 20
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                font.bold: true
                Layout.fillWidth: true
            }
            Item{
                width: tbReturn.width
            }
        }
    }

    Pane{
        padding: 0
        anchors.fill: parent
        Material.background: g_theme.alphaLv4
        ColumnLayout{
            anchors.fill: parent
            spacing:0

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
                    txt += '<br>源码仓库：<a href="https://github.com/kxtry/czys">https://github.com/kxtry/czys</a>'
                    txt += '<br>版本号：1.1'
                    text = txt;
                }

                onLinkActivated:{
                    console.log(link + " link activated");
                    desktopServices.openUrl(link);
                }
            }
        }
    }

    KxDesktopServices{
        id:desktopServices;
    }
}
