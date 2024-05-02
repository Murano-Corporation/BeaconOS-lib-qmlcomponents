import QtQuick 2.12

CompImageIcon {
    id: compHealthDashboardViewNavBtnRootOmega

    property alias alertCount: indicatorAlertCount.alertCount
    property string tabName: ''


    signal clicked()

    source: "file:///usr/share/BeaconOS-lib-images/images/AlertFill.svg"
    color: "White"
    opacity: enabled ? 1.0 : 0.3
    MouseArea{

        onClicked: compHealthDashboardViewNavBtnRootOmega.clicked()

        anchors{
            fill: parent
        }
    }

    CompIndicatorAlertCount {
        id: indicatorAlertCount

        alertCount: compHealthDashboardContentRootOmega.alertCount
    }
}
