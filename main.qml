import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtCharts 2.15

import "devices"
import "common"

Window {
    width: Screen.width * 0.3
    height: Screen.height * 0.4
    visible: true

    StackView {
        id: globalStackView
        anchors.fill: parent
        initialItem: gripperComponent
    }

    Component {
        id: gripperComponent
        GripperPage { }
    }

    InfoPopup {
        id: globalInfoPopup
    }
}
