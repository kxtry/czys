import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import KxObject 1.0

KxObject {
    property color themeColor:Material.color(Material.Green)
    property color lightThemeColor:Material.color(Material.LightGreen)

    property color background:themeColor
    property color primary: themeColor
    property color foreground:Material.color(Material.Grey)
    property color accent:alphaLv5

    property color topbar_background:alphaLv1
    property color topbar_foreground:'#FFFFFF'
    property int topbar_height: 50

    property color tabbar_background:alphaLv5
    property color tabbar_primary: themeColor
    property color tabbar_foreground:Material.color(Material.Grey)
    property color tabbar_accent:themeColor
    property color tabbar_line: Material.color(Material.Grey)

    property color musicbar_background:alphaLv5
    property color musicbar_foreground:themeColor
    property color musicbar_line: Material.color(Material.Grey)
    property color musicbar_slider: themeColor

    property color menu_background:lightThemeColor
    property color menu_foreground:alphaLv5


    property color alphaLv1: '#1FFFFFFF'
    property color alphaLv2: '#3FFFFFFF'
    property color alphaLv3: '#5FFFFFFF'
    property color alphaLv4: '#7FFFFFFF'
    property color alphaLv5: '#9FFFFFFF'


}
