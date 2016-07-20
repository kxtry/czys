import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQml.Models 2.1

Menu {
    property int menuWidth: 180
    modal:true
    clip: true

    Material.background: g_theme.alphaLv4
    Component.onCompleted: {
        //菜单必须设置背景宽度，才能正确显示文本，这应该是它的一个BUG。
        if(menuWidth < 100){
            menuWidth = 100;
        }
    }

    background:Rectangle{
        id:myback
        implicitWidth: menuWidth
        color:g_theme.themeColor
        Rectangle {
            anchors.fill: parent
            color:g_theme.alphaLv5
        }
    }
}


