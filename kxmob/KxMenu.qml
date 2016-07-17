import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQml.Models 2.1

Item {

    default property alias col: myCol.children
    Column {
        id:myCol
        anchors.fill: parent
    }

    onColChanged: {
        console.log('menuListModel.count=')
        console.log('menuListModel.count='+col.count)
    }

    Component.onCompleted: {
        var w = 0,h = 0;



    }

//    ObjectModel {
//        id: menuListModel;
//    }

//    contentItem:ListView{
//        anchors.fill: parent
//        model:menuListModel
//    }
}


